{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.my.options.virtualization.docker;
in
{
  options.my.options.virtualization.docker = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    # Rootless mode
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
