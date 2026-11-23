# Arquivo principal de configuração do NixOS.
#
# Documentação:
#   - man configuration.nix
#   - https://search.nixos.org/options  (todas as opções disponíveis)
#   - https://nixos.org/manual/nixos/stable/

{ config, pkgs, ... }:

{
  # ---------------------------------------------------------------------------
  # Nix (o gerenciador de pacotes)
  # ---------------------------------------------------------------------------

  # Habilita os comandos modernos: `nix` (subcomandos) e `nix flake`.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---------------------------------------------------------------------------
  # Boot
  # ---------------------------------------------------------------------------

  imports = [
    # Resultado do `nixos-generate-config` (discos, CPU, kernel modules...).
    ./hardware-configuration.nix
  ];

  # Usa o systemd-boot como gerenciador de boot (UEFI).
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ---------------------------------------------------------------------------
  # Rede
  # ---------------------------------------------------------------------------

  networking.hostName = "nixos";

  # NetworkManager cuida do Wi-Fi, cabo, VPN, etc. (inclusive pela interface do KDE).
  networking.networkmanager.enable = true;

  # ---------------------------------------------------------------------------
  # Idioma, fuso horário e teclado
  # ---------------------------------------------------------------------------

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "pt_BR.UTF-8";

  # Formatos regionais (datas, números, moeda) em pt_BR.
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Teclado ABNT2 no X11 (sessão gráfica) e no console (TTY).
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";

  # ---------------------------------------------------------------------------
  # Ambiente gráfico (Niri + SDDM)
  # ---------------------------------------------------------------------------

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs.niri.enable = true;

  # ---------------------------------------------------------------------------
  # Energia / bateria
  # ---------------------------------------------------------------------------

  # O UPower é quem expõe a bateria via D-Bus. O Noctalia (e vários outros apps,
  # como gerenciadores de energia) consultam esse serviço para mostrar o nível
  # de carga; sem ele a bateria simplesmente não aparece.
  services.upower.enable = true;

  # ---------------------------------------------------------------------------
  # Impressão e som
  # ---------------------------------------------------------------------------

  services.printing.enable = true;

  # PipeWire é o servidor de áudio atual (substitui o PulseAudio).
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Para aplicações JACK, descomente:
    # jack.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Usuário
  # ---------------------------------------------------------------------------

  users.users."lucas" = {
    isNormalUser = true;
    description = "Lucas ";
    # wheel = pode usar sudo | networkmanager = pode gerenciar a rede
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];
  };

  # ---------------------------------------------------------------------------
  # Programas do sistema
  # ---------------------------------------------------------------------------

  # Firefox desativado (o Flatpak está habilitado mais abaixo, caso queira usá-lo).
  programs.firefox.enable = false;

  # nix-ld: permite executar binários dinâmicos pré-compilados que NÃO foram
  # empacotados pelo Nix (por exemplo, um `.AppImage`, um binário baixado de um
  # site, instaladores do VS Code/JetBrains, ferramentas de terceiros...).
  #
  # Sem isso esses binários falham com erro do tipo:
  #   "No such file or directory" ao rodar um ELF (por falta do linker/loader).
  #
  # O nix-ld cria `/lib64/ld-linux-x86-64.so.2` apontando para o loader do Nix,
  # e as bibliotecas listadas em `libraries` ficam disponíveis para esses
  # binários (elas fazem o papel das libs de sistema de uma distro comum).
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # libstdc++ (necessária para a maioria dos programas compilados em C++).
    stdenv.cc.cc.lib
  ];
  # Obs.: `programs.nix-ld.package` não é necessário, o padrão já é `pkgs.nix-ld`.

  # Permite instalar pacotes com licença não livre (ex.: drivers, codecs...).
  nixpkgs.config.allowUnfree = true;

  # Pacotes disponíveis para todos os usuários (comando/início de sessão).
  environment.systemPackages = with pkgs; [
    # --- Editores e terminal ---
    neovim # Editor (config do LazyVim em ./nvim, veja a seção "Dotfiles")
    fish
    kitty

    # --- Ferramentas de desenvolvimento ---
    git
    lazygit # Interface de git no terminal (no Neovim: <leader>gg)
    ripgrep # Busca por texto (usada pelo Telescope/busca do Neovim)
    fd # Busca por arquivos (usada pelo Telescope)
    curl # Downloads (usado pelo LazyVim e por plugins)
    unzip # Extração (usada por alguns plugins)
    gcc # Compilador C: necessário para o nvim-treesitter compilar os parsers
    wl-clipboard # Clipboard do Neovim integrado ao Wayland

    # --- Wayland / Niri / Noctalia ---
    niri
    noctalia-shell
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    polkit_gnome
    libnotify
    brightnessctl
    pamixer
    playerctl
    grim
    slurp
    swappy
    swaybg
    nautilus

    # --- Apps do dia a dia ---
    flatpak
    fastfetch
    zapzap
    localsend
    libreoffice
    # wget
  ];

  # ---------------------------------------------------------------------------
  # Dotfiles versionados neste repositório
  # ---------------------------------------------------------------------------

  # Cada programa lê sua config em ~/.config/<nome>. Apontamos esses caminhos
  # para as pastas correspondentes deste repositório: as configs ficam
  # versionadas no git e, ao mesmo tempo, no lugar onde os programas esperam
  # encontrá-las.
  #
  # `L+` = cria/atualiza um symlink a cada boot (idempotente).
  # Obs.: usamos o caminho REAL do repositório como texto. Se usássemos a
  # interpolação de path do Nix aqui, a pasta seria copiada para /nix/store
  # (somente leitura) e o LazyVim/Noctalia não conseguiriam gravar seus arquivos.
  systemd.tmpfiles.rules = [
    "L+ /home/lucas/.config/nvim - - - - /home/lucas/Projetos/dotfiles/nvim"
    "L+ /home/lucas/.config/niri - - - - /home/lucas/Projetos/dotfiles/niri"
    "L+ /home/lucas/.config/noctalia - - - - /home/lucas/Projetos/dotfiles/noctalia"
    "L+ /home/lucas/.config/kitty - - - - /home/lucas/Projetos/dotfiles/kitty"
    "L+ /home/lucas/.config/fish - - - - /home/lucas/Projetos/dotfiles/fish"
  ];

  # ---------------------------------------------------------------------------
  # Flatpak
  # ---------------------------------------------------------------------------

  services.flatpak.enable = true;

  # Faz o sistema e o KRunner encontrarem os atalhos (.desktop) dos apps Flatpak.
  environment.extraInit = ''
    XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
  '';

  # Integração com os portais XDG (diálogos de arquivo, screenshots, etc.)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };

  # ---------------------------------------------------------------------------
  # Serviços opcionais (descomente se precisar)
  # ---------------------------------------------------------------------------

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # services.openssh.enable = true;

  # Firewall:
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  # Copia esta configuração para /run/current-system/configuration.nix
  # system.copySystemConfiguration = true;

  # ---------------------------------------------------------------------------
  # Versão do estado do sistema
  # ---------------------------------------------------------------------------

  # Define a primeira versão do NixOS instalada nesta máquina. Serve para manter
  # compatibilidade com dados criados por versões anteriores (bancos de dados,
  # configs em /var/lib, etc.). NÃO altere isso após a instalação, mesmo que
  # atualize o sistema — veja `man configuration.nix` (opção system.stateVersion).
  system.stateVersion = "26.05";
}
