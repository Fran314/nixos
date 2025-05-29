{
  lib,
  pkgs,
  config,
  machine,
  my-utils,
  inputs,
  ...
}:

with lib;
let
  # Scripts that need variable interpolation must NOT be run before interpolation as
  # this would produce potentially harmful undefined behaviour.
  #
  # To prevent this, any script that needs interpolation to function starts with a
  # flag that prevents the script to be ran if set to 1.
  readRemoveStopWith =
    variables: path:
    builtins.replaceStrings
      [ "STOP_EXECUTION_BEFORE_INTERPOLATION=1" ]
      [ "STOP_EXECUTION_BEFORE_INTERPOLATION=0" ]
      (my-utils.readInterpolateWith variables path);
  readRemoveStop = path: readRemoveStopWith { } path;

  bluetooth-devices-source = inputs.private-data.outPath + "/secrets/bluetooth-devices";

in
mkIf config.my.options.wm.xmonad.enable {
  assertions = [
    {
      assertion =
        (builtins.pathExists bluetooth-devices-source)
        && ((builtins.readFileType bluetooth-devices-source) == "regular");
      message = ''
        file "bluetooth-devices" imported from private-data repo is missing at location
        "${bluetooth-devices-source}"

        Check that the file exists at path "./secrets/bluetooth-devices" in
        the private-data repo
      '';
    }

  ];

  environment.systemPackages = mkMerge [
    [
      (pkgs.writeShellApplication {
        name = "duplicate-alacritty";
        runtimeInputs = with pkgs; [
          xdotool
          procps # pgrep
        ];
        text = my-utils.readInterpolate ./duplicate-alacritty;
      })
      (pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [
          maim
          imagemagick # convert
          xclip
          xdg-user-dirs
        ];
        text = my-utils.readInterpolate ./screenshot;
      })
      (pkgs.writeShellApplication {
        name = "screencast";
        runtimeInputs = with pkgs; [
          xdg-user-dirs
          procps # pkill
          xorg.xprop
          libnotify
          slop
          xorg.xwininfo
          # (ffmpeg.override { withXcb = true; })
          ffmpeg-full
          (pkgs.callPackage ./shadowbox { })
        ];
        text = my-utils.readInterpolate ./screencast;
      })
      (pkgs.writeShellApplication {
        name = "smart-playerctl";
        runtimeInputs = with pkgs; [
          playerctl
        ];
        text = my-utils.readInterpolate ./smart-playerctl;
      })
      (pkgs.writeShellApplication {
        name = "bluetooth-manager";
        runtimeInputs = with pkgs; [
          bluez-experimental # bluetoothctl
        ];
        text = readRemoveStopWith { inherit bluetooth-devices-source; } ./bluetooth-manager;
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
          nmcli c up "$(nmcli -t -f device,active,uuid con | grep '^${machine.wifi-device}:yes' | cut -d: -f3)"
        '';
      })
    ])
  ];
}
