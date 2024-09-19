{ config, pkgs,  ... }:

{
    home-manager.users.baldo = { config, pkgs, ... }:
    {
        home.packages = with pkgs; [
            fastfetch
        ];
        home.file = {
            ".config/fastfetch/config.jsonc" = {
                source = ./config.jsonc;
                recursive = true;
            };
        };
    };
}
