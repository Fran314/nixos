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
  #
  # The readWithVariables function takes a set of variables and does the following:
  # - replaces the flag from 1 to 0 if needed, allowing the script to run
  # - replaces the local variables with their values
  # - replaces the machine variables with their values
  # Note that the correct function of these substitutions depends on attrNames and
  # attrValues returning the keys and values in the same order (which they do, and
  # the order is alphabetical in the key)
  formatNames = list: map (x: "<nix-interpolate:${x}>") list;
  from =
    localVariables:
    [ "STOP_EXECUTION_BEFORE_INTERPOLATION=1" ]
    ++ (formatNames (builtins.attrNames (machine // localVariables)));
  to =
    localVariables:
    [ "STOP_EXECUTION_BEFORE_INTERPOLATION=0" ] ++ (builtins.attrValues (machine // localVariables));
  readWithVariables =
    localVariables: path:
    builtins.replaceStrings (from localVariables) (to localVariables) (builtins.readFile path);
  read = path: readWithVariables { } path;

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
        text = read ./duplicate-alacritty;
      })
      (pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = with pkgs; [
          maim
          imagemagick # convert
          xclip
          xdg-user-dirs
        ];
        text = read ./screenshot;
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
        text = read ./screencast;
      })
      (pkgs.writeShellApplication {
        name = "smart-playerctl";
        runtimeInputs = with pkgs; [
          playerctl
        ];
        text = read ./smart-playerctl;
      })
      (pkgs.writeShellApplication {
        name = "bluetooth-manager";
        runtimeInputs = with pkgs; [
          bluez-experimental # bluetoothctl
        ];
        text = read ./bluetooth-manager;
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
        text = read ./set-brightness;
      })
      (pkgs.writeShellApplication {
        name = "monitor-manager";
        runtimeInputs = with pkgs; [
          xorg.xrandr
        ];
        text = read ./monitor-manager;
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
