{
  lib,
  pkgs,
  machine,
  secrets,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/basics
    ../../modules/ssh
    ../../modules/wireguard/server
  ];

  my.options = {
    ssh = {
      authorizedKeys = [ secrets.ssh.latias."id_ed25519.pub" ];
      fail2ban = true;
    };

    zsh = {
      hostIcon = "󰅟";
      welcome = {
        enable = true;
        textColor = {
          r = 104;
          g = 202;
          b = 246;
        };
        variant = true;
      };
    };

    tmux.tmux-main-session = true;

    wireguard.server = {
      privateKeyFile = "/secrets/wg/altaria/wg0.private";
      externalInterface = machine.external-interface;
      peers = [
        {
          publicKey = secrets.wg.latias."wg-vps.public";
          allowedIPs = [
            "10.0.0.2/32"
            "fdc9:281f:04d7:9ee9::2/128"
          ];
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    neovim

    cifs-utils
  ];

  fileSystems."/mnt/storage-box" = {
    # This is necessary instead of simply using `secrets.samba.altaria."device"`
    # because that value has a new line and this breaks everything.
    # The `builtins.head` + `splitString` extracts the first line
    device = (builtins.head (lib.strings.splitString "\n" secrets.samba.altaria."device"));
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in ["${automount_opts},credentials=/secrets/samba/altaria/credentials,uid=1000,gid=100"];
  };
  systemd.tmpfiles.rules = [
    "d /mnt/storage-box 0755 baldo users - -"
  ];

  services.caddy = {
    enable = true;
    virtualHosts."baldino.dev" = {
      extraConfig = ''
        root * /var/www/html
        file_server
      '';
    };
    virtualHosts."navidrome.baldino.dev" = {
      extraConfig = ''
        reverse_proxy http://localhost:4533
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.navidrome = {
    enable = true;
    user = "baldo";
    group = "users";
    settings = {
      MusicFolder = "/home/baldo/navidrome";
    };
  };
  # Needed to allow the MusicFolder to be inside `/home`, since the service
  # created by services.navidrome defaults to `ProtectHome = true`
  systemd.services.navidrome.serviceConfig.ProtectHome = lib.mkForce false;

  users.users = {
    root.hashedPassword = "!"; # Disable root login
  };

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

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
      home.stateVersion = "25.05"; # Please read the comment before changing.
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
      home.stateVersion = "25.05"; # Please read the comment before changing.
    };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
