{ config, pkgs, ...}:

{
    home-manager.users.baldo = { config, pkgs, ... }:
    {
        home.packages = with pkgs; [
            xdg-user-dirs
        ];

        xdg.userDirs = {
            enable = true;
            desktop = "${config.home.homeDirectory}/desktop";
            documents = "${config.home.homeDirectory}/documents";
            download = "${config.home.homeDirectory}/download";
            music = "${config.home.homeDirectory}/music";
            pictures = "${config.home.homeDirectory}/pictures";
            publicShare = "${config.home.homeDirectory}/public";
            templates = "${config.home.homeDirectory}/templates";
            videos = "${config.home.homeDirectory}/videos";
        };
    };
}
