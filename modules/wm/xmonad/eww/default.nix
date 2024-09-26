{ lib, config, pkgs, ... }:

with lib; {
    options.my.options.wm.xmonad.eww = {
        enable = mkEnableOption "";
    };

    config = mkIf config.my.options.wm.xmonad.eww.enable {
        environment.systemPackages = with pkgs; [
            eww
            fira
            wmctrl
        ];

        home-manager.users.baldo = { config, pkgs, ... }:
        {
            home.file = {
                ".config/eww" = {
                    source = ./config;
                    recursive = true;
                };
            };
        };
    };
}
