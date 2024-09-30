{ lib, config, pkgs, ... }:

with lib; {
    imports = [
        ./scripts

        ./picom
        ./dunst
        ./eww
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

        my.options.wm.xmonad.picom.enable = true;
        my.options.wm.xmonad.dunst.enable = true;
        my.options.wm.xmonad.eww.enable = true;

        services.xserver.displayManager.sessionCommands = ''
            ~/.fehbg &
        '';
        environment.systemPackages = with pkgs; [
            pamixer
            feh
        ];
    };
}
