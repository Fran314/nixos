{ lib, config, pkgs, ... }:

let
    xmonad-duplicate-alacritty = pkgs.writeShellApplication {
        name = "xmonad-duplicate-alacritty";
        runtimeInputs = [
            pkgs.xdotool
            pkgs.procps     # pgrep
        ];
        text = builtins.readFile ./scripts/duplicate-alacritty;
    };
    xmonad-set-brightness = pkgs.writeShellApplication {
        name = "xmonad-set-brightness";
        text = builtins.readFile ./scripts/set-brightness;
    };
in with lib; {
    imports = [
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

            xmonad-duplicate-alacritty
            xmonad-set-brightness
        ];
    };
}
