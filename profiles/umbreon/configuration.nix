{
  pkgs,
  secrets,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/basics
    ../../modules/full-cli
    ../../modules/services
    ../../modules/ssh
  ];

  my.options = {
    ssh = {
      authorizedKeys = [ secrets.ssh.latias."id_ed25519.pub" ];
      fail2ban = true;
    };

    zsh = {
      hostIcon = "";
      welcome = {
        enable = true;
        textColor = {
          r = 106;
          g = 189;
          b = 222;
        };
      };
    };

    tmux.tmux-main-session = true;

    services = {
      pihole = true;

      vaultwarden = true;
      radicale = true;
      forgejo = true;

      jellyfin = true;
      qbittorrent = true;
      handbrake = true;
    };
  };

  environment.systemPackages = with pkgs; [
    ### CLI utils
    tldr
    imagemagick
    mediainfo
    pdftk
  ];

  ##################
  #   BOOTLOADER   #
  ##################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/mnt/hdd1" = {
    device = "/dev/disk/by-uuid/53ee69cb-d21b-427d-ba79-8910c3a16885";
    fsType = "ext4";
  };

  # ZFS stuff
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false; # This is enabled by default for backwards compatibility purposes, but it is highly recommended to disable this option, as it bypasses some of the safeguards ZFS uses to protect your ZFS pools
  boot.zfs.devNodes = "/dev/disk/by-path";
  boot.zfs.extraPools = [ "hm01" ];
  networking.hostId = "6adbf918"; # The primary use case is to ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine

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
