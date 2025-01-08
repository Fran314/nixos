{ config, pkgs, lib, ... }:

with lib; {
    options.my.options.zsh.welcome = {
        enable = mkEnableOption "";
        textColor = mkOption {
            type = types.enum [ "black" "red" "green" "yellow" "blue" "purple" "cyan" "white" ];
            description = "Color for the hostname in the welcome message";
        };
    };

    config = mkIf config.my.options.zsh.welcome.enable {
        home-manager.users.baldo = { pkgs,  ... }:
        let
            color = {
                "black" = "0";
                "red" = "1";
                "green" = "2";
                "yellow" = "3";
                "blue" = "4";
                "purple" = "5";
                "cyan" = "6";
                "white" = "7";
            }."${config.my.options.zsh.welcome.textColor}";
            image = builtins.readFile (./. + "/${config.networking.hostName}");
            displayScript = builtins.readFile ./display-welcome.sh;
            init = builtins.replaceStrings ["<<WELCOME-IMAGE>>" "<<HOST-COLOR>>"] [image color] displayScript;
        in {
            programs.zsh = {
                initExtra =  init;
            };
        };
    };
}

