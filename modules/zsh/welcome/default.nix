{ config, pkgs, lib, ... }:

with lib; {
    options.my.options.zsh = {
        welcome = mkEnableOption "";
    };

    config = mkIf config.my.options.zsh.welcome {
        home-manager.users.baldo = { pkgs,  ... }:
        let
            image = builtins.readFile (./. + "/${config.networking.hostName}");
            displayScript = builtins.readFile ./display-welcome.sh;
            init = builtins.replaceStrings ["<<WELCOME-IMAGE>>"] [image] displayScript;
        in {
            programs.zsh = {
                initExtra =  init;
            };
        };
    };
}

