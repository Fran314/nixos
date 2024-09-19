{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/minimal
        ../../modules/gnome
        ../../modules/xmonad
        ../../modules/alacritty
        ../../modules/productivity/3d-modeling
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

    home-manager.users.baldo = { config, pkgs, ... }:
    {
        imports = [
            ../../modules/xdg/user.nix
            ../../modules/xdg/user-with-data.nix
            ../../modules/nvim/user-with-gnome.nix
            ../../modules/productivity/lean4/user.nix
        ];

        nixpkgs.config.allowUnfree = true;

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
