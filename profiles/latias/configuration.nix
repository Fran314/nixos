{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/minimal
        ../../modules/xdg
        ../../modules/xdg/with-data.nix
        ../../modules/gnome
        ../../modules/nvim/with-gnome.nix
        ../../modules/xmonad
        ../../modules/alacritty
        ../../modules/productivity/3d-modeling
        ../../modules/productivity/lean4
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "latias";

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # services.displayManager.sddm.wayland.enable = true;
    services.xserver.displayManager.lightdm.greeters.slick.enable = true;

    # Originally these were only for XMonad, but they seems to work nicely
    # with GNOME as well (they make idle go to sleep and lock instead of only making
    # the screen go black) so I'm leaving it here
    services.xserver.displayManager.sessionCommands = ''
        xset -dpms      # Disable Energy Star, as we are going to suspend anyway and it may hide "success" on that
        xset s blank    # `noblank` may be useful for debugging 
        xset s 300      # seconds
        ${pkgs.lightlocker}/bin/light-locker --idle-hint &
    '';
    systemd.targets.hybrid-sleep.enable = true;
    services.logind.extraConfig = ''
        IdleAction=hybrid-sleep
        IdleActionSec=20s
    '';


    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "it";
        variant = "";
        options = "caps:escape";
    };

    # Configure console keymap
    console.keyMap = "it2";

    services.libinput.touchpad.naturalScrolling = true;

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

    home-manager.users.baldo = { config, pkgs, ... }:
    {
        home.packages = with pkgs; [
            ### Daily usage
            firefox
            gnome.nautilus 
            telegram-desktop

            ### Occasional usage
            spotify
            vlc
            inkscape
            krita

            ### Developement
            cargo
            clippy
            python3Full
            nodejs
            godot_4

            ### Productivity
            (octaveFull.withPackages (ps: with ps; [
                # Search for `octavePackages` in NixOS packages to see all the possible options
                # Once in octave, load the package with `pkg load <name-of-the-package>`
                nurbs
            ]))

            ### Utility
            bitwarden-cli
            yt-dlp
        ];
    };
}
