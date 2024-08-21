# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "latias"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-utilities.enable = false; # Remove additional packages from GNOME
  programs.dconf.enable = true;
  environment.gnome.excludePackages = [
  #   # pkgs.adwaita-icon-theme
  #   pkgs.epiphany
  #   pkgs.evince
  #   # pkgs.file-roller
  #   pkgs.geary
  #   pkgs.gnome-calendar
  #   pkgs.gnome-connections
  #   pkgs.gnome-console
  #   pkgs.gnome-font-viewer
  #   pkgs.gnome-system-monitor
  #   pkgs.gnome-text-editor
  #   pkgs.gnome-themes-extra
    pkgs.gnome-tour
  #   pkgs.gnome-user-docs
  #   pkgs.gnome.gnome-backgrounds
  #   pkgs.gnome.gnome-characters
  #   pkgs.gnome.gnome-clocks
  #   pkgs.gnome.gnome-contacts
  #   pkgs.gnome.gnome-logs
  #   pkgs.gnome.gnome-maps
  #   pkgs.gnome.gnome-music
  #   pkgs.gnome.gnome-weather
  #   pkgs.nautilus
  #   pkgs.orca
  #   pkgs.simple-scan
  #   pkgs.sushi
  #   pkgs.totem
  #   pkgs.yelp
  #   pkgs.baobab
  #   pkgs.gnome-calculator
  #   pkgs.loupe
  #   pkgs.simple-scan
  #   pkgs.snapshot
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "it";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.baldo = {
    isNormalUser = true;
    description = "baldo";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # ONLY FOR TESTING
  security.sudo.wheelNeedsPassword = false;

  # To enable system packages completion
  # See: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enableCompletion
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    
    shellAliases = {
      cp = "cp -i";
      mv = "mv -i";
      rmt="\\mv -ft $@ ~/.trash/";
      empty-trash="\\rm -rf ~/.trash && mkdir ~/.trash";
      lh="ls -lhA --group-directories-first";
      lt="ls -lhAtr";
    };

    promptInit = ''
      autoload -Uz vcs_info
      setopt prompt_subst
      precmd() { vcs_info }
      zstyle ':vcs_info:git*' actionformats '%f[%F{2}%b%f|%F{1}%a%f] '
      zstyle ':vcs_info:git*' formats       '%f[%F{2}%b%f]'
      
      if [ $(id -u) -eq 0 ]
      then
          USERNAME_PROMPT='%B%F{red}%n'
      else
          USERNAME_PROMPT='%B%F{blue}%n'
      fi
      PROMPT='┌ '                        # Arrow start
      PROMPT+='%(?..%B%F{red}[%?]%f%b )' # Error code
      PROMPT+=$USERNAME_PROMPT           # Username
      PROMPT+='%f%b@%m %B%80<..<%~%<<%b' # Truncated path
      PROMPT+=' ''${vcs_info_msg_0_}'    # Git info
      PROMPT+=$'\n└> '                   # New line and end arrow
    '';
    # syntaxHighlighting.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;

  # # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "baldo";
  #
  # # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git

    home-manager

    vim 
    neovim
  ];

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
