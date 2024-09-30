{ lib, config, pkgs, ... }:

let
    eww-hello = pkgs.writeShellApplication {
        name = "eww-hello";
        runtimeInputs = [ pkgs.sl pkgs.lolcat ];
        text = ''
            sl | lolcat
        '';

    };
in with lib; {
    options.my.options.wm.xmonad.eww = {
        enable = mkEnableOption "";
    };

    config = mkIf config.my.options.wm.xmonad.eww.enable {
        environment.systemPackages = with pkgs; [
            eww
            fira
            wmctrl
            eww-hello
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
