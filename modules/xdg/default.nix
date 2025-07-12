{
  lib,
  config,
  machine,
  pkgs,
  ...
}:

with lib;
{
  config = mkMerge [

    {
      home-manager.users.baldo =
        { config, pkgs, ... }:
        {
          home.packages = with pkgs; [
            xdg-user-dirs
          ];

          xdg.mimeApps = {
            enable = true;
            # associations.added = {
            #     "application/pdf" = ["firefox.desktop"];
            # };
            defaultApplications = {
              "application/pdf" = [ "firefox.desktop" ];
              "image/svg+xml" = [ "firefox.desktop" ];
              "image/jpeg" = [ "org.gnome.eog.desktop" ];
              "image/png" = [ "org.gnome.eog.desktop" ];
              "image/webp" = [ "org.gnome.eog.desktop" ];

              "audio/aac" = [ "vlc.desktop" ];
              "audio/mpeg" = [ "vlc.desktop" ];
              "audio/ogg" = [ "vlc.desktop" ];
              "audio/wav" = [ "vlc.desktop" ];
              "audio/webm" = [ "vlc.desktop" ];

              "video/mp4" = [ "vlc.desktop" ];
              "video/mpeg" = [ "vlc.desktop" ];
              "video/ogg" = [ "vlc.desktop" ];
              "video/webm" = [ "vlc.desktop" ];
              "video/x-matroska" = [ "vlc.desktop" ];
            };
          };

          xdg.userDirs = {
            enable = true;
            desktop = "${config.home.homeDirectory}/desktop";
            documents = "${config.home.homeDirectory}/documents";
            download = "${config.home.homeDirectory}/downloads";
            music = "${config.home.homeDirectory}/music";
            pictures = "${config.home.homeDirectory}/pictures";
            publicShare = "${config.home.homeDirectory}/public";
            templates = "${config.home.homeDirectory}/templates";
            videos = "${config.home.homeDirectory}/videos";
          };

          systemd.user.tmpfiles.rules = [
            "d ${config.home.homeDirectory}/desktop      - - - - -"
            "d ${config.home.homeDirectory}/documents    - - - - -"
            "d ${config.home.homeDirectory}/downloads    - - - - -"
            "d ${config.home.homeDirectory}/music        - - - - -"
            "d ${config.home.homeDirectory}/pictures     - - - - -"
            "d ${config.home.homeDirectory}/public       - - - - -"
            "d ${config.home.homeDirectory}/templates    - - - - -"
            "d ${config.home.homeDirectory}/universita   - - - - -"
            "d ${config.home.homeDirectory}/videos       - - - - -"
          ];
        };
    }

    (mkIf (machine.name == "latias") {
      fileSystems =
        let
          data-drive = d: {
            depends = [
              "/"
              "/data"
            ];
            device = "/data/${d}";
            fsType = "none";
            options = [
              "bind"
              "rw"
            ];
          };
        in
        {
          "/home/baldo/archivio" = data-drive "archivio";
          "/home/baldo/desktop" = data-drive "desktop";
          "/home/baldo/documents" = data-drive "documents";
          "/home/baldo/downloads" = data-drive "downloads";
          "/home/baldo/music" = data-drive "music";
          "/home/baldo/pictures" = data-drive "pictures";
          "/home/baldo/public" = data-drive "public";
          "/home/baldo/templates" = data-drive "templates";
          "/home/baldo/universita" = data-drive "archivio/universita";
          "/home/baldo/videos" = data-drive "videos";
        };

      home-manager.users.baldo =
        { config, pkgs, ... }:
        {
          systemd.user.tmpfiles.rules = [
            "d ${config.home.homeDirectory}/archivio     - - - - -"
          ];
        };
    })
  ];
}
