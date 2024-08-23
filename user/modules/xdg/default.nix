{ config, pkgs, ...}:

{
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
}
