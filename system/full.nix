{ config, pkgs, ... }:

{
    imports = [
        ./minimal.nix
    ];

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    # services.displayManager.sddm.wayland.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.gnome.core-utilities.enable = false; # Remove additional packages from GNOME
    programs.dconf.enable = true;
    environment.gnome.excludePackages = [         # Remove even more packages from GNOME
        # pkgs.adwaita-icon-theme
        # pkgs.epiphany
        # pkgs.evince
        # pkgs.file-roller
        # pkgs.geary
        # pkgs.gnome-calendar
        # pkgs.gnome-connections
        # pkgs.gnome-console
        # pkgs.gnome-font-viewer
        # pkgs.gnome-system-monitor
        # pkgs.gnome-text-editor
        # pkgs.gnome-themes-extra
        pkgs.gnome-tour
        # pkgs.gnome-user-docs
        # pkgs.gnome.gnome-backgrounds
        # pkgs.gnome.gnome-characters
        # pkgs.gnome.gnome-clocks
        # pkgs.gnome.gnome-contacts
        # pkgs.gnome.gnome-logs
        # pkgs.gnome.gnome-maps
        # pkgs.gnome.gnome-music
        # pkgs.gnome.gnome-weather
        # pkgs.nautilus
        # pkgs.orca
        # pkgs.simple-scan
        # pkgs.sushi
        # pkgs.totem
        # pkgs.yelp
        # pkgs.baobab
        # pkgs.gnome-calculator
        # pkgs.loupe
        # pkgs.simple-scan
        # pkgs.snapshot
    ];

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
