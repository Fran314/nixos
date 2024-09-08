{ lib, config, pkgs, ...}:

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

    # For reasons unclear to me, home manager will create these files only if
    # the content of these rules change, and not whenever they are missing.
    # To force the creation of these files (via command line) you can run
    # the following command `systemd-tmpfiles --user --create`
    systemd.user.tmpfiles.rules = [
        "L ${config.home.homeDirectory}/applications - - - - /data/applications"
        "L ${config.home.homeDirectory}/archivio     - - - - /data/archivio"
        "L ${config.home.homeDirectory}/desktop      - - - - /data/desktop"
        "L ${config.home.homeDirectory}/documents    - - - - /data/documents"
        "L ${config.home.homeDirectory}/download     - - - - /data/download"
        "L ${config.home.homeDirectory}/music        - - - - /data/music"
        "L ${config.home.homeDirectory}/pictures     - - - - /data/pictures"
        "L ${config.home.homeDirectory}/public       - - - - /data/public"
        "L ${config.home.homeDirectory}/templates    - - - - /data/templates"
        "L ${config.home.homeDirectory}/universita   - - - - /data/universita"
        "L ${config.home.homeDirectory}/videos       - - - - /data/videos"
    ];
}
