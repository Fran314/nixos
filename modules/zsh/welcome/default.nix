{ config, pkgs, lib, ... }:

with lib; {
    options.my.options.zsh.welcome = {
        enable = mkEnableOption "";
        variant = mkEnableOption "";
        textColor = mkOption {
            type = types.enum [ "black" "red" "green" "yellow" "blue" "purple" "cyan" "white" ];
            description = "Color for the hostname in the welcome message";
        };
    };

    config = mkIf config.my.options.zsh.welcome.enable {
        home-manager.users.baldo = { pkgs,  ... }:
        let
            c = config.my.options.zsh.welcome.textColor;
            color = if c == "black" then "0"
                else if c == "red" then "1"
                else if c == "green" then "2"
                else if c == "yellow" then "3"
                else if c == "blue" then "4"
                else if c == "purple" then "5"
                else if c == "cyan" then "6"
                else if c == "white" then "7"
                else "0";

            image = builtins.readFile (./. + "/${config.networking.hostName}");
            variant = if config.my.options.zsh.welcome.variant
                then builtins.readFile (./. + "/${config.networking.hostName}-variant")
                else "$IMAGE";

            displayScript = builtins.readFile ./display-welcome.sh;
            init = builtins.replaceStrings
                ["<<WELCOME-IMAGE>>" "<<VARIANT-IMAGE>>" "<<HOST-COLOR>>"]
                [image variant color]
                displayScript;
        in {
            programs.zsh = {
                initExtra =  init;
            };
        };
    };
}

