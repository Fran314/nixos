{ config, lib, pkgs, ... }:

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
        totem               # video player, I keep it for now but later I want to put VLC instead
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

    home-manager.users.baldo = { lib, pkgs, pkgs-unstable, ... }:
    {
        imports = [
            ./pop-shell.nix
        ];

        # Fixes a bug for Wayland where the cursor doesn't render correctly
        # (wrong size or doesn't render at all) for some GTK applications such as
        # Alacritty
        home.pointerCursor = {
            gtk.enable = true;
            name = "Adwaita";
            package = pkgs.gnome.adwaita-icon-theme;
            size = 22;
        };

        home.packages = (with pkgs; [
            gnome-extension-manager
            gnome.gnome-tweaks
            gnomeExtensions.just-perfection
            gnomeExtensions.appindicator
            gnomeExtensions.blur-my-shell

            gnomeExtensions.caffeine
            gnomeExtensions.boost-volume

            gnomeExtensions.vitals
            gnomeExtensions.runcat
            gnomeExtensions.no-overview
            gnomeExtensions.notification-timeout
        ])
        ++
        (with pkgs-unstable; [
             gnomeExtensions.rounded-window-corners-reborn
        ]);

        dconf.settings = with lib.hm.gvariant; {
            "org/gnome/desktop/background" = {
                color-shading-type = "solid";
                picture-options = "zoom";
                picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/morphogenesis-l.svg";
                picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/morphogenesis-d.svg";
                primary-color = "#e18477";
                secondary-color = "#000000";
            };

            "org/gnome/desktop/input-sources" = {
                sources = [ (mkTuple [ "xkb" "it" ]) ];
                xkb-options = [ "terminate:ctrl_alt_bksp" "caps:escape" ];
            };

            "org/gnome/desktop/interface" = {
                clock-format = "24h";
                clock-show-seconds = true;
                color-scheme = "prefer-dark";
                cursor-theme = "Adwaita";
                enable-animations = true;
                enable-hot-corners = false;
                show-battery-percentage = true;
            };

            "org/gnome/desktop/wm/preferences" = {
                auto-raise = false;
                focus-mode = "sloppy";
            };

            "org/gnome/settings-daemon/plugins/media-keys" = {
                custom-keybindings = [
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
                ];
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
                binding = "<Super>z";
                command = "alacritty";
                name = "Launch Terminal";
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
              binding = "<Super>t";
              command = "telegram-desktop";
              name = "Launch Telegram";
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
                binding = "<Super>F2";
                command = "firefox";
                name = "Launch Firefox";
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
                binding = "<Ctrl><Alt>l";
                command = "dm-tool lock";
                name = "Lock Screen";
            };

            "org/gnome/shell" = {
                disable-user-extensions = false;
                enabled-extensions = [ "Vitals@CoreCoding.com" "rounded-window-corners@fxgn" "appindicatorsupport@rgcjonas.gmail.com" "caffeine@patapon.info" "runcat@kolesnikov.se" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "blur-my-shell@aunetx" "just-perfection-desktop@just-perfection" "boostvolume@shaquib.dev" "no-overview@fthx" "notification-timeout@chlumskyvaclav.gmail.com" ];
            };

            "org/gnome/shell/extensions/just-perfection" = {
                enabled = true;
                top-panel-position = 1;
            };

            "org/gnome/shell/extensions/runcat" = {
                enabled = true;
                idle-threshold = 5;
            };

            "org/gnome/shell/extensions/vitals" = {
                enabled = true;
                hide-icons = true;
                hot-sensors = [ "_temperature_k10temp_tctl_" "_processor_usage_" "_storage_free_" ];
                show-fan = false;
                show-memory = false;
                show-network = false;
                show-system = false;
                show-voltage = false;
            };
        };
    };
}
