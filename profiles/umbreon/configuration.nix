{ lib, config, pkgs, pkgs-unstable, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/minimal
		../../modules/virtualization/docker
    ];

    networking.hostName = "umbreon";

    # networking.firewall.allowedTCPPorts = [ 8080 ];

    networking.nameservers = [ "1.1.1.1" ];

    my.options.zsh.hostIcon = "";
    my.options.zsh.welcome.enable = true;
    my.options.zsh.welcome.textColor = "blue";

	services.openssh.enable = true;

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

	# ZFS stuff
	boot.supportedFilesystems = [ "zfs" ];
	boot.zfs.forceImportRoot = false; # This is enabled by default for backwards compatibility purposes, but it is highly recommended to disable this option, as it bypasses some of the safeguards ZFS uses to protect your ZFS pools
	boot.zfs.devNodes = "/dev/disk/by-path";
	boot.zfs.extraPools = [ "hm01" ];
	networking.hostId = "6adbf918"; # The primary use case is to ensure when using ZFS that a pool isn’t imported accidentally on a wrong machine

    home-manager.users.baldo = { config, pkgs, ... }:
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
