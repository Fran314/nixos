{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.my.options.productivity.three-d-modeling;
in
{
  options.my.options.productivity.three-d-modeling = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prusa-slicer
      freecad
    ];
  };
}
