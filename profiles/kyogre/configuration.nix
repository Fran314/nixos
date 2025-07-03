{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/basics
    ../../modules/full-cli
    ../../modules/wm
    ../../modules/xdg
    ../../modules/alacritty
    ../../modules/utils

    ../../modules/productivity
    ../../modules/gaming
  ];

  networking.firewall.allowedTCPPorts = [ 8080 ];

  my.options.wm.use = lib.mkDefault "xmonad";
  # specialisation.gnome.configuration = {
  # 	my.options.wm.use = "gnome";
  # };

  my.options = {
    zsh = {
      hostIcon = "";
      welcome = {
        enable = true;
        textColor = {
          r = 0;
          g = 144;
          b = 219;
        };
        variant = true;
      };
    };
    productivity = {
      video-editing.enable = true;
      three-d-modeling.enable = true;
    };
    utils = {
      keep-images = true;
      batch-rename = true;
      img-resize = true;
      canon-import = true;
      android-backup = true;
      ctex = true;
      new-project = true;
      bookletify = true;
      poke2term = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Automount usb and SD card
  services.devmon.enable = true;
  services.gvfs.enable = true;

  # MTP for android file transfer
  services.udev.packages = [
    pkgs.libmtp.out
    pkgs.android-udev-rules
  ];

  # Necessary for running appimages
  programs.appimage.binfmt = true;

  environment.systemPackages = with pkgs; [
    # for pactl
    pulseaudioFull
    pavucontrol

    ### Daily usage
    firefox
    nautilus
    file-roller # archive browser (.zip, .tar, ...)
    telegram-desktop
    eog # image viewer

    ### Occasional usage
    spotify
    vlc
    inkscape
    krita
    aseprite
    geogebra6
    darktable
    libreoffice
    gparted

    flatpak
    appimage-run

    ### CLI utils
    tldr
    tgpt
    pkgs-unstable.yt-dlp
    rar
    unrar

    ### Developement
    cargo
    clippy
    (python3.withPackages (
      ps: with ps; [
        matplotlib
        numpy
        scipy
        networkx # draw graphs and networks
      ]
    ))
    jupyter
    nodejs
    godot_4
    fritzing # utility to draw arduino circuit diagrams (hardly ever used, added only for opening old files from very old projects)

    ### Productivity
    (octaveFull.withPackages (
      ps: with ps; [
        # Search for `octavePackages` in NixOS packages to see all the possible options
        # Once in octave, load the package with `pkg load <name-of-the-package>`
        nurbs
      ]
    ))
  ];

  services.openssh.enable = true;

  ##################
  #   BOOTLOADER   #
  ##################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  home-manager.users.baldo =
    { config, pkgs, ... }:
    {
      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "23.11"; # Please read the comment before changing.
    };
  home-manager.users.root =
    { config, pkgs, ... }:
    {
      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "23.11"; # Please read the comment before changing.
    };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
