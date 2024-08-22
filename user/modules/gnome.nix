{ config, lib, pkgs, pkgs-unstable, ... }:

{
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
        gnomeExtensions.pop-shell
        gnomeExtensions.just-perfection
        gnomeExtensions.appindicator
        gnomeExtensions.blur-my-shell

        gnomeExtensions.caffeine
        gnomeExtensions.boost-volume

        gnomeExtensions.vitals
        gnomeExtensions.runcat
    ])
    ++
    (with pkgs-unstable; [
         gnomeExtensions.rounded-window-corners-reborn
    ]);

    dconf.settings = with lib.hm.gvariant; {
        #--- Pop-shell related keyremaps ---#
        # To understand which keys are remapped and why
        # see https://github.com/pop-os/shell/blob/8e176f14029a2c3bb54c52e1e7a5c697b9eb2171/scripts/configure.sh
        "org/gnome/desktop/wm/keybindings" = {
            close = [ "<Super>q" "<Alt>F4" ];
            maximize = [];
            minimize = [ "<Super>comma" ];
            move-to-monitor-down = [];
            move-to-monitor-left = [];
            move-to-monitor-right = [];
            move-to-monitor-up = [];
            move-to-workspace-1 = [ "<Shift><Super>1" ];
            move-to-workspace-2 = [ "<Shift><Super>2" ];
            move-to-workspace-3 = [ "<Shift><Super>3" ];
            move-to-workspace-4 = [ "<Shift><Super>4" ];
            move-to-workspace-down = [];
            move-to-workspace-up = [];
            switch-to-workspace-1 = [ "<Super>1" ];
            switch-to-workspace-2 = [ "<Super>2" ];
            switch-to-workspace-3 = [ "<Super>3" ];
            switch-to-workspace-4 = [ "<Super>4" ];
            switch-to-workspace-down = [ "<Primary><Super>Down" "<Primary><Super>j" ];
            switch-to-workspace-left = [];
            switch-to-workspace-right = [];
            switch-to-workspace-up = [ "<Primary><Super>Up" "<Primary><Super>k" ];
            toggle-maximized = [ "<Super>m" ];
            unmaximize = [];
        };
        "org/gnome/shell/keybindings" = {
            open-application-menu = [];
            switch-to-application-1 = [];
            switch-to-application-2 = [];
            switch-to-application-3 = [];
            switch-to-application-4 = [];
            toggle-message-tray = [ "<Super>v" ];
            toggle-overview = [];
        };
        "org/gnome/mutter/keybindings" = {
            toggle-tiled-left = [];
            toggle-tiled-right = [];
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" ];
            email = [ "<Super>e" ];
            help = [];
            home = [ "<Super>f" ];
            rotate-video-lock-static = [];
            screensaver = [ "<Super>Escape" ];
            terminal = [ "<Super>t" ];
            www = [ "<Super>b" ];
        };
        "org/gnome/mutter/wayland/keybindings" = {
            restore-shortcuts = [];
        };
        "org/gnome/mutter" = {
            center-new-windows = true;
            edge-tiling = false;
            workspaces-only-on-primary = false;
        };
        #--- ---#

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

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>z";
            command = "alacritty";
            name = "Launch Terminal";
        };

        # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        #   binding = "<Super>t";
        #   command = "telegram-desktop";
        #   name = "Launch Telegram";
        # };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
            binding = "<Super>F2";
            command = "firefox";
            name = "Launch Firefox";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
            binding = "<Super>F1";
            command = "alacritty --class 'nvim-memo' --working-directory '/home/baldo/.local/share/nvim/memo' -e nvim -c 'SessionsLoad'";
            name = "Launch Memo";
        };

        "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [ "pop-shell@system76.com" "Vitals@CoreCoding.com" "rounded-window-corners@fxgn" "appindicatorsupport@rgcjonas.gmail.com" "caffeine@patapon.info" "runcat@kolesnikov.se" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "blur-my-shell@aunetx" "just-perfection-desktop@just-perfection" "boostvolume@shaquib.dev" ];
        };

        "org/gnome/shell/extensions/just-perfection" = {
            # accessibility-menu = true;
            # background-menu = true;
            # calendar = true;
            # clock-menu = true;
            # clock-menu-position-offset = 0;
            # controls-manager-spacing-size = 0;
            # dash = true;
            # dash-icon-size = 0;
            # double-super-to-appgrid = true;
            # enabled = true;
            # keyboard-layout = true;
            # max-displayed-search-results = 0;
            # osd = true;
            # panel = true;
            # panel-in-overview = true;
            # ripple-box = true;
            # search = true;
            # show-apps-button = true;
            # startup-status = 1;
            # theme = false;
            top-panel-position = 1;
            # window-demands-attention-focus = false;
            # window-menu-take-screenshot-button = true;
            # window-picker-icon = true;
            # window-preview-caption = true;
            # window-preview-close-button = true;
            # workspace = true;
            # workspace-background-corner-size = 0;
            # workspace-popup = true;
            # workspaces-in-app-grid = true;
        };

        "org/gnome/shell/extensions/pop-shell" = {
            active-hint = true;
            active-hint-border-radius = mkUint32 15;
            enabled = true;
            gap-inner = mkUint32 6;
            gap-outer = mkUint32 6;
            hint-color-rgba = "rgb(145,155,242)";
            show-skip-taskbar = true;
            show-title = false;
            smart-gaps = false;
            snap-to-grid = true;
            tile-by-default = true;
        };

        "org/gnome/shell/extensions/runcat" = {
            enabled = true;
            idle-threshold = 5;
        };

        "org/gnome/shell/extensions/vitals" = {
            alphabetize = true;
            enabled = true;
            fixed-widths = true;
            hide-icons = true;
            hot-sensors = [ "_temperature_k10temp_tctl_" "_processor_usage_" "_storage_free_" ];
            icon-style = 1;
            menu-centered = false;
            show-battery = false;
            show-fan = false;
            show-network = false;
            show-voltage = false;
            use-higher-precision = false;
        };
    };
}
