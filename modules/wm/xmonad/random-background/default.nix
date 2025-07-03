{
  lib,
  config,
  pkgs,
  private-data,
  ...
}:

with lib;
let
  image-directory-source = private-data.outPath + "/background-images/ghibli-core/backgrounds";
in
{
  options.my.options.wm.xmonad.random-background = {
    enable = mkEnableOption "";
  };

  config = mkIf config.my.options.wm.xmonad.random-background.enable {
    assertions = [
      {
        assertion = (builtins.pathExists image-directory-source);
        message = ''
          file "image-directory-source" imported from private-data repo is missing at location
          "${image-directory-source}"

          Check that the file exists in the private-data repo
        '';
      }
      {
        assertion = ((builtins.readFileType image-directory-source) == "directory");
        message = ''
          object "image-directory-source" imported from private-data repo at location
          "${image-directory-source}"
          is not a directory.
        '';
      }
    ];
    home-manager.users.baldo =
      {
        config,
        inputs,
        pkgs,
        ...
      }:
      {
        services.random-background = {
          enable = true;
          # imageDirectory = "--recursive %h/documents/pictures/backgrounds";	# example with --recursive
          imageDirectory = image-directory-source;
          display = "fill";
          interval = "10m";
        };
      };
  };
}
