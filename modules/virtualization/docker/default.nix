{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = {
    virtualisation.docker.enable = true;

    # Rootless mode
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
