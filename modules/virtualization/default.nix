{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./docker
    ./virtualbox
  ];
}
