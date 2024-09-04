{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../system/full.nix
    ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    # boot.loader.grub.enable = true;
    # boot.loader.grub.device = "/dev/sda";
    # boot.loader.grub.useOSProber = true;

    networking.hostName = "vm";

    # ONLY FOR TESTING
    security.sudo.wheelNeedsPassword = false;
}
