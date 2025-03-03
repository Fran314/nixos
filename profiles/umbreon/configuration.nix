{ lib, config, pkgs, pkgs-unstable, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/minimal
    ];

    networking.hostName = "umbreon";

    # networking.firewall.allowedTCPPorts = [ 8080 ];

    networking.nameservers = [ "1.1.1.1" ];

    my.options.zsh.hostIcon = "";
    # my.options.zsh.hostIcon = "";
    # my.options.zsh.hostIcon = "󰅟";
    # my.options.zsh.welcome.enable = true;
    # my.options.zsh.welcome.textColor = "red";
    # my.options.zsh.welcome.variant = true;

    # my.options.generic.enable = true;

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
