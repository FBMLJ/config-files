#!/usr/bin/env bash
# Mantém este comportamento:
#   - 1 janela (coluna) no workspace -> ocupa 100% da tela
#   - 2+ colunas -> comportamento normal do niri (novas janelas abrem em 50%
#     e a tela rola horizontalmente com Mod+Left/Right)
#
# Ao abrir a segunda janela, a coluna que estava em 100% volta para 50%.
# O niri não tem essa opção nativa, então este script escuta os eventos do
# compositor. É iniciado pelo `spawn-at-startup` em ./config.kdl.

declare -A last_count
declare -A single_window

pid_file="${XDG_RUNTIME_DIR:-/tmp}/niri-auto-column-width.pid"

# Evita duas instâncias (ex.: config recarregada).
if [ -f "$pid_file" ] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
    exit 0
fi
echo $$ > "$pid_file"
trap 'rm -f "$pid_file"' EXIT

# Transforma o JSON de um array em uma linha por objeto. Divide apenas na
# fronteira real entre objetos (},{"id":), para não quebrar por causa de
# títulos de janela que contenham vírgulas/chaves.
split_objects() {
    sed -e 's/},{"id":/}\n{"id":/g' -e 's/^\[//' -e 's/\]$//'
}

# Extrai o "id" do começo de cada objeto.
object_id() {
    sed -n 's/^{"id":\([0-9][0-9]*\).*/\1/p'
}

focused_workspace_id() {
    niri msg --json workspaces \
        | split_objects \
        | grep '"is_focused":true' \
        | object_id
}

focused_window_id() {
    niri msg --json windows \
        | split_objects \
        | grep '"is_focused":true' \
        | object_id
}

# Lista os índices das colunas usadas pelas janelas tile do workspace.
workspace_columns() {
    local ws_id=$1
    niri msg --json windows \
        | split_objects \
        | grep "\"workspace_id\":$ws_id," \
        | grep -v '"is_floating":true' \
        | sed -n 's/.*"pos_in_scrolling_layout":\[\([0-9][0-9]*\),[0-9][0-9]*\].*/\1/p' \
        | sort -n | uniq
}

# Retorna o id de uma janela qualquer da coluna indicada.
window_in_column() {
    local ws_id=$1 col=$2
    niri msg --json windows \
        | split_objects \
        | grep "\"workspace_id\":$ws_id," \
        | grep -v '"is_floating":true' \
        | grep "\"pos_in_scrolling_layout\":\[$col," \
        | head -n1 \
        | object_id
}

# Foca a janela, muda a largura da coluna e devolve o foco para onde estava.
set_column_width() {
    local window_id=$1 width=$2 orig_focus

    [ -z "$window_id" ] && return

    orig_focus=$(focused_window_id)
    niri msg action focus-window --id "$window_id" >/dev/null 2>&1
    niri msg action set-column-width "${width}%" >/dev/null 2>&1
    if [ -n "$orig_focus" ] && [ "$orig_focus" != "$window_id" ]; then
        niri msg action focus-window --id "$orig_focus" >/dev/null 2>&1
    fi
}

check() {
    local ws_id columns count column window_id prev

    ws_id=$(focused_workspace_id)
    [ -z "$ws_id" ] && return

    columns=$(workspace_columns "$ws_id")
    count=$(printf '%s\n' "$columns" | grep -c .)
    prev="${last_count[$ws_id]:-unset}"

    if [ "$count" -eq 1 ]; then
        column=$(printf '%s\n' "$columns" | head -n1)
        window_id=$(window_in_column "$ws_id" "$column")
        if [ "$prev" != "1" ]; then
            set_column_width "$window_id" 100
        fi
        single_window[$ws_id]=$window_id
    elif [ "$count" -ge 2 ]; then
        if [ "$prev" = "1" ]; then
            # A janela que estava em tela cheia volta para 50%.
            set_column_width "${single_window[$ws_id]:-}" 50
        elif [ "$prev" = "unset" ]; then
            # Primeira execução com várias janelas: normaliza todas para 50%.
            for column in $columns; do
                set_column_width "$(window_in_column "$ws_id" "$column")" 50
            done
        fi
        # Com 2+ janelas, as demais larguras ficam como o niri decidir.
        unset 'single_window[$ws_id]'
    fi

    last_count[$ws_id]=$count
}

check

# Escuta os eventos e reavalia quando janelas/workspaces mudam.
while true; do
    niri msg --json event-stream | while IFS= read -r line; do
        case "$line" in
            *'"WindowOpenedOrChanged"'*|*'"WindowClosed"'*|*'"WindowsChanged"'*|*'"WorkspaceActivated"'*)
                check
                ;;
        esac
    done
    sleep 1
done
