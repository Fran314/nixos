{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/minimal/system.nix
        ../../modules/gnome/system.nix
        ../../modules/productivity/3d-modeling/system.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "latias";

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # services.displayManager.sddm.wayland.enable = true;
    services.xserver.displayManager.lightdm.greeters.slick.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "it";
        variant = "";
    };

    # Configure console keymap
    console.keyMap = "it2";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    hardware.bluetooth.enable = true;

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
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
}
