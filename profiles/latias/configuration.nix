{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../system/minimal.nix
    ];

    # CHECK THAT THESE ARE ACTUALLY THE CORRECT VALUES
    # Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;

    networking.hostName = "latias";
}
