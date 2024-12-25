{ lib, config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/minimal
        ../../modules/wm
        ../../modules/xdg
        ../../modules/alacritty
        ../../modules/productivity/3d-modeling
        ../../modules/productivity/lean4
    ];

    networking.hostName = "latias";

    networking.firewall.allowedTCPPorts = [ 8080 ];

    networking.nameservers = [ "1.1.1.1" ];

    my.options.wm.use = lib.mkDefault "xmonad";
    specialisation = {
        gnome.configuration = {
            my.options.wm.use = "gnome";
        };
    };
    my.options.xdg.symlink-data = true;

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

    # Automount usb and SD card
    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    # MTP for android file transfer
    services.udev.packages = [ pkgs.libmtp.out pkgs.android-udev-rules ];

    # When dragging after tapping, it takes a while for it to "un-tap" (ie exit from dragging). This line disables this behaviour
    services.libinput.touchpad.tappingDragLock = false;

    # Steam stuff
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };


    environment.systemPackages = with pkgs; [
        # for pactl
        pulseaudioFull
        pavucontrol

        ### Daily usage
        firefox
        gnome.nautilus 
        telegram-desktop
        gnome.eog               # image viewer

        ### Occasional usage
        spotify
        vlc
        inkscape
        krita
        aseprite
        geogebra6
        darktable
        prismlauncher   # Minecraft

        ### CLI utils
        tldr
        imagemagick
        yt-dlp

        ### Developement
        cargo
        clippy
        (python3.withPackages (ps: with ps; [
            matplotlib
        ]))
        nodejs
        godot_4

        ### Productivity
        (octaveFull.withPackages (ps: with ps; [
            # Search for `octavePackages` in NixOS packages to see all the possible options
            # Once in octave, load the package with `pkg load <name-of-the-package>`
            nurbs
        ]))
    ];

    ##################
    #   BOOTLOADER   #
    ##################
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
}
