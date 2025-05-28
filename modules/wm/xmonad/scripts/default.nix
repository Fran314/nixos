{
  lib,
  pkgs,
  config,
  machine,
  ...
}:

with lib;
let
  # Scripts that need variable interpolation must NOT be run before interpolation as
  # this would produce potentially harmful undefined behaviour.
  #
  # To prevent this, any script that needs interpolation to function starts with a
  # flag that prevents the script to be ran if set to 1.
  readRemoveStop =
    path:
    builtins.replaceStrings
      [ "STOP_EXECUTION_BEFORE_INTERPOLATION=1" ]
      [ "STOP_EXECUTION_BEFORE_INTERPOLATION=0" ]
      (pkgs.lib.readInterpolate path);
in
mkIf config.my.options.wm.xmonad.enable {
  environment.systemPackages = mkMerge [
    [
      (pkgs.writeShellApplication {
        name = "duplicate-alacritty";
        runtimeInputs = with pkgs; [
          xdotool
          procps # pgrep
        ];
        text = pkgs.lib.readInterpolate ./duplicate-alacritty;
      })
      (pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [
          maim
          imagemagick # convert
          xclip
          xdg-user-dirs
        ];
        text = pkgs.lib.readInterpolate ./screenshot;
      })
      (pkgs.writeShellApplication {
        name = "screencast";
        runtimeInputs = with pkgs; [
          xdg-user-dirs
          procps # pkill
          xorg.xprop
          pkgs.libnotify
          slop
          xorg.xwininfo
          # (ffmpeg.override { withXcb = true; })
          ffmpeg-full
          (pkgs.callPackage ./shadowbox { })
        ];
        text = pkgs.lib.readInterpolate ./screencast;
      })
      (pkgs.writeShellApplication {
        name = "smart-playerctl";
        runtimeInputs = with pkgs; [
          playerctl
        ];
        text = pkgs.lib.readInterpolate ./smart-playerctl;
      })
      (pkgs.writeShellApplication {
        name = "bluetooth-manager";
        runtimeInputs = with pkgs; [
          bluez-experimental # bluetoothctl
        ];
        text = pkgs.lib.readInterpolate ./bluetooth-manager;
      })
      (pkgs.writeShellApplication {
        name = "lockscreen";
        runtimeInputs = with pkgs; [
          lightdm
        ];
        text = ''dm-tool lock'';
      })
    ]

    (mkIf (machine.name == "latias") [
      (pkgs.writeShellApplication {
        name = "set-brightness";
        runtimeInputs = with pkgs; [
          xorg.xrandr
        ];
        text = readRemoveStop ./set-brightness;
      })
      (pkgs.writeShellApplication {
        name = "monitor-manager";
        runtimeInputs = with pkgs; [
          xorg.xrandr
        ];
        text = readRemoveStop ./monitor-manager;
      })
      (pkgs.writeShellApplication {
        name = "reconnect-wifi";
        runtimeInputs = with pkgs; [
          networkmanager
        ];
        text = ''
          nmcli c up "$(nmcli -t -f device,active,uuid con | grep '^wlp4s0:yes' | cut -d: -f3)"
        '';
      })
    ])
  ];
}
