{ lib, config, pkgs, ...}:

{
    home.packages = with pkgs; [
        xdg-user-dirs
    ];

    xdg.userDirs = {
        enable = true;
        desktop = "${config.home.homeDirectory}/desktop";
        music = "${config.home.homeDirectory}/music";
        videos = "${config.home.homeDirectory}/videos";
        pictures = "${config.home.homeDirectory}/pictures";
        download = "${config.home.homeDirectory}/download";
        documents = "${config.home.homeDirectory}/documents";
        publicShare = "${config.home.homeDirectory}/public";
        templates = "${config.home.homeDirectory}/templates";
    };

    systemd.user.tmpfiles.rules = [
        "L ${config.home.homeDirectory}/archivio - - - - /data/archivio"
        "L ${config.home.homeDirectory}/applications - - - - /data/applications"
        "L ${config.home.homeDirectory}/desktop - - - - /data/desktop"
        "L ${config.home.homeDirectory}/documents - - - - /data/documents"
        "L ${config.home.homeDirectory}/pictures - - - - /data/pictures"
        "L ${config.home.homeDirectory}/universita - - - - /data/universita"
        "L ${config.home.homeDirectory}/videos - - - - /data/videos"
    ];
}
