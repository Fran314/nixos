{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

with lib;

let
  cfg = config.my.options.productivity.video-editing;
in
{
  options.my.options.productivity.video-editing = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ffmpeg-full

      pkgs-unstable.shotcut
      # davinci-resolve
      # openshot-qt
      pkgs-unstable.kdePackages.kdenlive

      tenacity

      handbrake
    ];
  };
}
