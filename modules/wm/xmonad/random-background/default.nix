{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
{
  options.my.options.wm.xmonad.random-background = {
    enable = mkEnableOption "";
  };

  config = mkIf config.my.options.wm.xmonad.random-background.enable {
    home-manager.users.baldo =
      {
        config,
        inputs,
        pkgs,
        ...
      }:
      let
        private-data = inputs.private-data.outPath;
      in
      {
        services.random-background = {
          enable = true;
          # imageDirectory = "--recursive %h/documents/pictures/backgrounds";	# example with --recursive
          imageDirectory = private-data + "/background-images/ghibli-core/backgrounds";
          display = "fill";
          interval = "10m";
        };
      };
  };
}
