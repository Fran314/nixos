{ config, pkgs, ...}:

{
    home-manager.users.baldo = { lib, pkgs, pkgs-unstable, ... }:
    {
        programs.git = {
            enable = true;
            userName = "Fran314";
            userEmail = "francesco.ghog@gmail.com";
            extraConfig = {
                init.defaultBranch = "main";
            };
        };
    };
}
