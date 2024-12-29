# Install and enable the pop-shell extension for GNOME, and fix related issues
#
# This is written for GNOME 46 and might need to be adjusted for different versions
# 
# Issues:
#   Some GNOME keybindings are in conflict with the pop-shell keybindings,such
#   as <Super><Arrows> for changing focus. These GNOME keybindings are "hidden"
#   and cannot be disabled from the keyboard menu.
#   To solve this issue, pop-shell uses a configuration script that disables
#   some of the hidden GNOME keybindings and sets the default pop-shell
#   keybindings.
#   This issue is slightly documented here
#   https://www.reddit.com/r/pop_os/comments/k236zt/comment/gdrwj7v/
#   See the configuration script at the time of writing
#   https://github.com/pop-os/shell/blob/8e176f14029a2c3bb54c52e1e7a5c697b9eb2171/scripts/configure.sh
#
# Additionally, I like to move between workspaces with <Super>1..4, and GNOME
# has hidden keybinds for these key combination. This module also disables and
# overrides the <Super>1..4 keybindings, but in a separated block at the bottom
# so that you can easily omit it if this is your preference

{ config, lib, pkgs-gnome, ... }:

{
    home.packages = with pkgs-gnome; [
        gnomeExtensions.pop-shell
    ];

    dconf.settings = with lib.hm.gvariant; {
        "org/gnome/desktop/wm/keybindings" = {
            close = [ "<Super>q" "<Alt>F4" ];
            maximize = [];
            minimize = [ "<Super>comma" ];
            move-to-monitor-down = [];
            move-to-monitor-left = [];
            move-to-monitor-right = [];
            move-to-monitor-up = [];
            move-to-workspace-down = [];
            move-to-workspace-up = [];
            switch-to-workspace-down = [ "<Primary><Super>Down" "<Primary><Super>j" ];
            switch-to-workspace-left = [];
            switch-to-workspace-right = [];
            switch-to-workspace-up = [ "<Primary><Super>Up" "<Primary><Super>k" ];
            toggle-maximized = [ "<Super>m" ];
            unmaximize = [];
        };
        "org/gnome/shell/keybindings" = {
            open-application-menu = [];
            toggle-message-tray = [ "<Super>v" ];
            toggle-overview = [];
        };
        "org/gnome/mutter/keybindings" = {
            toggle-tiled-left = [];
            toggle-tiled-right = [];
        };
        "org/gnome/settings-daemon/plugins/media-keys" = {
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

        "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = [ "pop-shell@system76.com" ];
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
        
        # Override and add keybindings for navigating workspaces with <Super>1..4
        "org/gnome/desktop/wm/keybindings" = {
            move-to-workspace-1 = [ "<Shift><Super>1" ];
            move-to-workspace-2 = [ "<Shift><Super>2" ];
            move-to-workspace-3 = [ "<Shift><Super>3" ];
            move-to-workspace-4 = [ "<Shift><Super>4" ];
            switch-to-workspace-1 = [ "<Super>1" ];
            switch-to-workspace-2 = [ "<Super>2" ];
            switch-to-workspace-3 = [ "<Super>3" ];
            switch-to-workspace-4 = [ "<Super>4" ];
        };
        "org/gnome/shell/keybindings" = {
            switch-to-application-1 = [];
            switch-to-application-2 = [];
            switch-to-application-3 = [];
            switch-to-application-4 = [];
        };
    };
}
