{ config, lib, pkgs, pkgs-unstable, ... }:

{
    services.xserver.desktopManager.gnome.enable = true;
    programs.dconf.enable = true;   # Enables editing dconf via dconf.settings in home-manager

    #--- MINIMAL GNOME ---#
    # services.gnome.core-utilities.enable = false; # Remove additional packages from GNOME
    # environment.gnome.excludePackages = [         # Remove even more packages from GNOME
    #     # pkgs.adwaita-icon-theme
    #     # pkgs.epiphany
    #     # pkgs.evince
    #     # pkgs.file-roller
    #     # pkgs.geary
    #     # pkgs.gnome-calendar
    #     # pkgs.gnome-connections
    #     # pkgs.gnome-console
    #     # pkgs.gnome-font-viewer
    #     # pkgs.gnome-system-monitor
    #     # pkgs.gnome-text-editor
    #     # pkgs.gnome-themes-extra
    #     pkgs.gnome-tour
    #     # pkgs.gnome-user-docs
    #     # pkgs.gnome.gnome-backgrounds
    #     # pkgs.gnome.gnome-characters
    #     # pkgs.gnome.gnome-clocks
    #     # pkgs.gnome.gnome-contacts
    #     # pkgs.gnome.gnome-logs
    #     # pkgs.gnome.gnome-maps
    #     # pkgs.gnome.gnome-music
    #     # pkgs.gnome.gnome-weather
    #     # pkgs.nautilus
    #     # pkgs.orca
    #     # pkgs.simple-scan
    #     # pkgs.sushi
    #     # pkgs.totem
    #     # pkgs.yelp
    #     # pkgs.baobab
    #     # pkgs.gnome-calculator
    #     # pkgs.loupe
    #     # pkgs.simple-scan
    #     # pkgs.snapshot
    # ];
    #--- ---#

    #--- Reduced GNOME ---#
    environment.gnome.excludePackages = (with pkgs; [
        gnome-photos        # GNOME also comes with image viewer, which is better
        gnome-tour
        gnome-text-editor
        gnome-connections   # remote desktop utility
    ]) ++ (with pkgs.gnome; [
        # totem               # video player, I keep it for now but later I want to put VLC instead

        epiphany            # web browser
        geary               # email reader
        evince              # document viewer
        cheese              # webcam tool
        gnome-terminal
        gnome-music
        gnome-characters    # emoji and characters input
        gnome-calculator
        gnome-maps
        gnome-weather
        gnome-contacts
        simple-scan         # document scanner

        yelp                # help viewer
        tali                # poker game
        iagno               # go game
        hitori              # sudoku game
        atomix              # puzzle game
    ]);
    #--- ---#
}