{
  lib,
  pkgs,
  config,
  machine,
  my-utils,
  private-data,
  ...
}:

with lib;
let
  bluetooth-devices-source = private-data.outPath + "/secrets/bluetooth-devices";
in
mkIf config.my.options.wm.xmonad.enable {
  assertions = [
    {
      assertion = (builtins.pathExists bluetooth-devices-source);
      message = ''
        file "bluetooth-devices" imported from private-data repo is missing at location
        "${bluetooth-devices-source}"

        Check that the file exists in the private-data repo
      '';
    }
    {
      assertion = ((builtins.readFileType bluetooth-devices-source) == "regular");
      message = ''
        object "bluetooth-devices" imported from private-data repo at location
        "${bluetooth-devices-source}"
        is not a regular file.
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
        name = "screen-saver-toggle";
        runtimeInputs = with pkgs; [
          xorg.xset
        ];
        text = my-utils.readInterpolate ./screen-saver-toggle;
      })
      (pkgs.writeShellApplication {
        name = "bluetooth-manager";
        runtimeInputs = with pkgs; [
          bluez-experimental # bluetoothctl
        ];
        text = my-utils.readRemoveStopWith { inherit bluetooth-devices-source; } ./bluetooth-manager;
      })
      (pkgs.writeShellApplication {
        name = "firefox-toggle-full-screen";
        runtimeInputs = with pkgs; [
          xdotool
        ];
        text = my-utils.readInterpolate ./firefox-toggle-full-screen;
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
        text = my-utils.readRemoveStop ./set-brightness;
      })
      (pkgs.writeShellApplication {
        name = "monitor-manager";
        runtimeInputs = with pkgs; [
          xorg.xrandr
        ];
        text = my-utils.readRemoveStop ./monitor-manager;
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
      (pkgs.writeShellApplication {
        name = "toggle-hotspot";
        runtimeInputs = with pkgs; [
          networkmanager
          libnotify
        ];
        text = ''
          HOTSPOT_ID="Hotspot di Baldo"

          # if active, disconnect
          if nmcli connection show --active | grep -q "$HOTSPOT_ID"; then
              nmcli connection down id "$HOTSPOT_ID"
              # nmcli device connect wlan0
              exit 0
          fi

          # if not active, try to find and connect (5 attempts)
          for _ in {1..5}; do
              nmcli device wifi rescan
              sleep 2

              if nmcli device wifi list | grep -q "$HOTSPOT_ID"; then
                  nmcli connection up id "$HOTSPOT_ID"
                  exit 0
              fi
          done

          notify-send "Hotspot" "Could not find \"$HOTSPOT_ID\""
          exit 1
        '';
      })
    ])
  ];
}
