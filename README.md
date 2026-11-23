# dotfiles

Configs de NixOS + Niri/Noctalia/Kitty/Fish/Neovim.

## Instalar

Instale o NixOS pelo instalador gráfico (ele cria as partições, o mount e o
`/etc/nixos/hardware-configuration.nix`). Depois, no sistema já instalado:

```bash
nix-shell -p git --run 'git clone https://github.com/SEU-USUARIO/dotfiles.git ~/Projetos/dotfiles'
cd ~/Projetos/dotfiles
./install.sh
sudo nixos-rebuild switch
```

O `install.sh` só cria os links simbólicos:

- `/etc/nixos/configuration.nix` → `nixos/configuration.nix` do repo
- `~/.config/{nvim,niri,noctalia,kitty,fish}` → as pastas correspondentes do repo

O `hardware-configuration.nix` **não é copiado** — cada máquina usa o dela, gerado
pelo instalador. Por isso o `import` no `configuration.nix` é absoluto
(`/etc/nixos/hardware-configuration.nix`).

Para atualizar:

```bash
cd ~/Projetos/dotfiles && git pull
sudo nixos-rebuild switch
```
