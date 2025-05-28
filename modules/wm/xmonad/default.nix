{
  lib,
  config,
  pkgs,
  machine,
  ...
}:

with lib;
{
  imports = [
    ./scripts

    ./picom
    ./random-background
    ./dunst
    ./eww
    ./rofi

    ./battery-monitor
  ];

  options.my.options.wm.xmonad = {
    enable = mkEnableOption "";
  };

  config = mkIf config.my.options.wm.xmonad.enable {
    services.xserver.windowManager.xmonad = {
      enable = true;

      enableContribAndExtras = true;
      ghcArgs = [
        "-i ${./xmonad-modules/shared}"
        "-i ${./xmonad-modules/${machine.name}}"
        "-hidir /tmp"
        "-odir /tmp"
      ];
      config = builtins.readFile ./xmonad.hs;
    };

    # Technically not needed, but when switching to a specialization with only
    # Gnome and then back to a specialization with only Xmonad, for some reason
    # some files would still be set on Gnome and would fail to find a session
    # to log with. This manually sets the default session to prevent this
    services.displayManager.defaultSession = "none+xmonad";

    my.options.wm.xmonad.picom.enable = true;
    my.options.wm.xmonad.random-background.enable = true;
    my.options.wm.xmonad.dunst.enable = true;
    my.options.wm.xmonad.eww.enable = true;
    my.options.wm.xmonad.rofi.enable = true;

    my.options.wm.xmonad.battery-monitor.enable = machine.name == "latias";

    environment.systemPackages = with pkgs; [
      pamixer
      blueberry
      xcolor
    ];
  };
}
