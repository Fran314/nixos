{
  lib,
  config,
  pkgs,
  machine,
  ...
}:

with lib;

let
  cfg = config.my.options.wm.xmonad.eww;
in
{
  imports = [
    ./scripts
  ];
  options.my.options.wm.xmonad.eww = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      eww
      wmctrl
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.recursive-mono
    ];

    home-manager.users.baldo =
      { config, pkgs, ... }:
      {
        home.file = {
          ".config/eww" = {
            source = ./config/shared;
            recursive = true;
          };
          ".config/eww/eww.yuck" = {
            source = ./config/${machine.name}/eww.yuck;
          };
          ".config/eww/eww.scss" = {
            source = ./config/${machine.name}/eww.scss;
          };
        };
      };
  };
}
