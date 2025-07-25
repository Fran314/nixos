{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  secrets,
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

    ../../modules/virtualization
    ../../modules/productivity
    ../../modules/gaming
  ];

  networking.firewall.allowedTCPPorts = [
    2234
    8080
  ];

  my.options.wm.use = lib.mkDefault "xmonad";
  # specialisation.gnome.configuration = {
  # 	my.options.wm.use = "gnome";
  # };

  my.options = {
    zsh = {
      welcome = {
        enable = true;
        textColor = {
          r = 254;
          g = 130;
          b = 104;
        };
        variant = true;
      };
    };
    virtualization = {
      docker.enable = true;
      virtualbox.enable = true;
    };
    productivity = {
      video-editing.enable = true;
      three-d-modeling.enable = true;
      lean4.enable = true;
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

  # When dragging after tapping, it takes a while for it to "un-tap" (ie exit from dragging). This line disables this behaviour
  services.libinput.touchpad.tappingDragLock = false;

  # Necessary for running appimages
  programs.appimage.binfmt = true;

  networking.wg-quick.interfaces = {
    wg-home = {
      autostart = false;
      address = [
        "10.0.0.2/24"
        "fdc9:281f:04d7:9ee9::2/64"
      ];
      dns = [
        "10.0.0.1"
        "fdc9:281f:04d7:9ee9::1"
      ];
      privateKeyFile = "/secrets/wg/latias/wg-home.private";

      peers = [
        {
          publicKey = secrets.wg.umbreon."wg0.public";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "home.baldino.dev:51820";
          persistentKeepalive = 25;
        }
      ];
    };
    wg-vps = {
      autostart = false;
      address = [
        "10.0.0.2/24"
        "fdc9:281f:04d7:9ee9::2/64"
      ];
      dns = [
        "10.0.0.1"
        "fdc9:281f:04d7:9ee9::1"
      ];
      privateKeyFile = "/secrets/wg/latias/wg-vps.private";

      peers = [
        {
          publicKey = secrets.wg.altaria."wg0.public";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "baldino.dev:51820";
          persistentKeepalive = 25;
        }
      ];
    };
    wg-proton = {
      autostart = false;
      address = [
        "10.2.0.2/32"
      ];
      dns = [
        "10.2.0.1"
      ];
      privateKeyFile = "/secrets/wg/latias/wg-proton.private";

      peers = [
        {
          publicKey = secrets.wg.proton."wg0.public";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "149.88.27.219:51820";
        }
      ];
    };
  };

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
    picard # mp3 tagger
    nicotine-plus # soulseek client

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
    zathura

    flatpak
    appimage-run

    ### CLI utils
    tldr
    tgpt
    pkgs-unstable.yt-dlp # needs unstable because not-up-to-date versions
    #						  stop working fairly quickly
    rar
    unrar

    ### Developement
    # # use 'github:oxalica/rust-overlay' instead
    # rustc
    # cargo
    # clippy

    (python3.withPackages (
      ps: with ps; [
        matplotlib
        numpy
        scipy
        networkx # draw graphs and networks
      ]
    ))
    jupyter
    typst
    nodejs
    godot_4
    fritzing # utility to draw arduino circuit diagrams (hardly ever used, added only for opening old files from very old projects)

    ### Productivity
    (octaveFull.withPackages (
      ps: with ps; [
        # Search for `octavePackages` in NixOS packages to see all the possible options
        # Once in octave, load the package with `pkg load <name-of-the-package>`
        nurbs
        symbolic
      ]
    ))
  ];

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
  system.stateVersion = "24.05"; # Did you read the comment?
}
