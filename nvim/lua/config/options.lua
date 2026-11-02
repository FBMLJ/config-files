-- Opções do Neovim (`:h option-list`).
--
-- O LazyVim já define um monte de padrões; coloque aqui só o que você quer
-- diferente. Cada bloco tem o "porquê" do ajuste.

local opt = vim.opt

-- ---------------------------------------------------------------------------
-- Visual
-- ---------------------------------------------------------------------------

-- Números relativos: a linha atual mostra o número absoluto e as outras a
-- distância até ela. Facilita usar `5j` / `5k` para pular linhas.
opt.relativenumber = true

-- Mantém 8 linhas de contexto acima/abaixo do cursor ao rolar a tela.
opt.scrolloff = 8

-- Divisão vertical de janelas abre à direita e horizontal embaixo (mais natural).
opt.splitright = true
opt.splitbelow = true

-- ---------------------------------------------------------------------------
-- Comportamento
-- ---------------------------------------------------------------------------

-- Compartilha o clipboard com o sistema (precisa de wl-clipboard/xclip).
opt.clipboard = "unnamedplus"

-- Busca ignora maiúsculas/minúsculas, a menos que você digite alguma maiúscula.
opt.ignorecase = true
opt.smartcase = true

-- Tempo (ms) de espera por uma tecla após `<leader>` etc.
opt.timeoutlen = 400

-- Recarrega o arquivo se ele mudar fora do Neovim (ex.: `git checkout`).
opt.autoread = true
