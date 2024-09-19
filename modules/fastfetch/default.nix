{ config, pkgs,  ... }:

{
    home-manager.users.baldo = { lib, pkgs, pkgs-unstable, ... }:
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
