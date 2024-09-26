{ lib, config, pkgs, ... }:

with lib; {
    options.my.options.wm.xmonad.picom = {
        enable = mkEnableOption "";
    };

    config = mkIf config.my.options.wm.xmonad.picom.enable {
        environment.systemPackages = with pkgs; [
            picom
        ];

        services.xserver.displayManager.sessionCommands = ''
            ${pkgs.picom}/bin/picom &
            '';

        home-manager.users.baldo = { config, pkgs, ... }:
        {
            home.file = {
                ".config/picom/picom.conf" = {
                    source = ./picom.conf;
                };
            };
        };
    };

}
