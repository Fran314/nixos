{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../system/minimal.nix
    ];

    # Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;

    # ONLY FOR TESTING
    security.sudo.wheelNeedsPassword = false;
}
