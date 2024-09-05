{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../system/full.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "latias";
}
