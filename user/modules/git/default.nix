{ config, pkgs, ...}:

{
    programs.git = {
        enable = true;
        userName = "Fran314";
        userEmail = "francesco.ghog@gmail.com";
        extraConfig = {
            init.defaultBranch = "main";
        };
    };
}
