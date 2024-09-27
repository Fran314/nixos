{ lib, config, pkgs, ... }:

with lib; {
    options.my.options.wm.xmonad.dunst = {
        enable = mkEnableOption "";
    };

    config = mkIf config.my.options.wm.xmonad.dunst.enable {
        environment.systemPackages = with pkgs; [
            dunst
        ];

        home-manager.users.baldo = { config, pkgs, ... }:
        {
            home.file = {
                ".config/dunst/dunstrc" = {
                    source = ./dunstrc;
                    recursive = true;
                };
            };
        };
    };
}
