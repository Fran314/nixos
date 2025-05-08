{ lib, config, pkgs, ... }:

with lib; {
    imports = [
        ./scripts

        ./picom
        ./feh
		./random-background
        ./dunst
        ./eww
        ./rofi

        ./battery-monitor
    ];

    options.my.options.wm.xmonad = {
        enable = mkEnableOption "";
    };

    config = mkIf config.my.options.wm.xmonad.enable {
        services.xserver.windowManager.xmonad = {
            enable = true;
            enableContribAndExtras = true;
            config = builtins.readFile ./xmonad.hs;
        };
        services.displayManager.defaultSession = "none+xmonad";

        my.options.wm.xmonad.picom.enable = true;
        # my.options.wm.xmonad.feh.enable = true;
        my.options.wm.xmonad.random-background.enable = true;
        my.options.wm.xmonad.dunst.enable = true;
        my.options.wm.xmonad.eww.enable = true;
        my.options.wm.xmonad.rofi.enable = true;

        my.options.wm.xmonad.battery-monitor.enable = true;

        environment.systemPackages = with pkgs; [
            pamixer
            libnotify
            playerctl
            blueberry

            xcolor

            gnome-photos
        ];
    };
}
