{ lib, config, pkgs, ... }:

with lib; {
    options.my.options.wm.xmonad.rofi = {
        enable = mkEnableOption "";
    };

    config = mkIf config.my.options.wm.xmonad.rofi.enable {
        environment.systemPackages = with pkgs; [
            rofi
        ];

        home-manager.users.baldo = { config, pkgs, ... }:
        {
            home.file = {
                ".config/rofi/config.rasi" = {
                    source = ./config.rasi;
                };
           };
        };
    };
}
