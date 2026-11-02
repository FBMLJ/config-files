# Edit this configuration file to define what should be installed on

# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:


{
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	imports =

		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		];

# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
		networking.networkmanager.enable = true;

# Set your time zone.
	time.timeZone = "America/Sao_Paulo";

# Select internationalisation properties.
	i18n.defaultLocale = "pt_BR.UTF-8";

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

# Enable the X11 windowing system.
# You can disable this if you're only using the Wayland session.
	services.xserver.enable = true;

# Enable the KDE Plasma Desktop Environment.
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;

# Configure keymap in X11
	services.xserver.xkb = {
		layout = "br";
		variant = "";
	};

# Configure console keymap
	console.keyMap = "br-abnt2";

# Enable CUPS to print documents.
	services.printing.enable = true;

# Enable sound with pipewire.
	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
# If you want to use JACK applications, uncomment this
# jack.enable = true;
	};

# Enable touchpad support (enabled default in most desktopManager).
# services.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users."lucas" = {
		isNormalUser = true;
		description = "Lucas ";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
			kdePackages.kate
#  thunderbird
		];
	};

# Install firefox.
	programs.firefox.enable = true;

# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

# List packages installed in system profile.
# You can use https://search.nixos.org/ to find more packages (and options).
	environment.systemPackages = with pkgs; [
		neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		git
			flatpak
			fastfetch
			fish
			kitty
			zapzap
			localsend
			libreoffice

#   wget
	];

# SERVIÇOS ADICIONADOS 
# SERVIÇOS ADICIONADOS 
	services.flatpak.enable = true;

# Força o sistema e o KRunner a lerem os atalhos (.desktop) do Flatpak
	environment.extraInit = ''
		XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
		'';

# Integração correta para o ambiente KDE Plasma
	xdg.portal = {
		enable = true;
		extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
		config.common.default = "kde";
	};







# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# Copy the NixOS configuration file and link it from the resulting system
# (/run/current-system/configuration.nix). This is useful in case you
# accidentally delete configuration.nix.
# system.copySystemConfiguration = true;

# This option defines the first version of NixOS you have installed on this particular machine,
# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
#
# Most users should NEVER change this value after the initial install, for any reason,
# even if you've upgraded your system to a new NixOS release.
#
# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
# to actually do that.
#
# This value being lower than the current NixOS release does NOT mean your system is
# out of date, out of support, or vulnerable.
#
# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
# and migrated your data accordingly.
#
# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "26.05"; # Did you read the comment?

}
