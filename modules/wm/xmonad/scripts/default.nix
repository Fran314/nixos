{ lib, pkgs, config, ... }:

let
    my-duplicate-alacritty = pkgs.writeShellApplication {
        name = "my-duplicate-alacritty";
        runtimeInputs = with pkgs; [
            xdotool
            procps              # pgrep
        ];
        text = builtins.readFile ./my-duplicate-alacritty;
    };
    my-set-brightness = pkgs.writeShellApplication {
        name = "my-set-brightness";
        runtimeInputs = with pkgs; [
            xorg.xrandr
        ];
        text = builtins.readFile ./my-set-brightness;
    };
    my-screenshot = pkgs.writeShellApplication {
        name = "my-screenshot";
        runtimeInputs = with pkgs; [
            maim
            imagemagick         # convert
            xclip
            xdg-user-dirs
        ];
        text = builtins.readFile ./my-screenshot;
    };
    my-shadowbox = pkgs.callPackage ./my-shadowbox {};
    # my-shadowbox = pkgs.writers.writePython3Bin "my-shadowbox" {
    #     libraries = [
    #         pkgs.gtk3
    #         pkgs.gobject-introspection
    #         pkgs.python3Packages.pycairo
    #         pkgs.python3Packages.pygobject3
    #     ];
    #     flakeIgnore = [
    #         "E265"  # Ignore errors for having shebang
    #         "E402"  # Ignore erros for having import not at top (required for gi)
    #     ];
    # } (builtins.readFile ./my-shadowbox);
    my-screencast = pkgs.writeShellApplication {
        name = "my-screencast";
        runtimeInputs = with pkgs; [
            xdg-user-dirs
            procps              # pkill
            xorg.xprop
            libnotify
            slop
            xorg.xwininfo
            # (ffmpeg.override { withXcb = true; })
            ffmpeg-full

            my-shadowbox
        ];
        text = builtins.readFile ./my-screencast;
    };
    my-monitor-manager = pkgs.writeShellApplication {
        name = "my-monitor-manager";
        runtimeInputs = with pkgs; [
            xorg.xrandr
        ];
        text = builtins.readFile ./my-monitor-manager;
    };
    my-color-picker = pkgs.writeShellApplication {
        name = "my-color-picker";
        runtimeInputs = with pkgs; [
            maim
            slop
            imagemagick         # convert
            xclip
        ];
        text = builtins.readFile ./my-color-picker;
    };
    my-bluetooth-manager = pkgs.writeShellApplication {
        name = "my-bluetooth-manager";
        runtimeInputs = with pkgs; [
            bluez-experimental      # bluetoothctl
        ];
        text = builtins.readFile ./my-bluetooth-manager;
    };
    my-lockscreen = pkgs.writeShellApplication {
        name = "my-lockscreen";
        runtimeInputs = with pkgs; [
            lightdm     # dm-tool
        ];
        text = ''dm-tool lock'';
    };
    my-reconnect-wifi = pkgs.writeShellApplication {
        name = "my-reconnect-wifi";
        runtimeInputs = with pkgs; [
            networkmanager
        ];
        text = ''nmcli c up "$(nmcli -t -f device,active,uuid con | grep '^wlp4s0:yes' | cut -d: -f3)"'';
    };
in lib.mkIf config.my.options.wm.xmonad.enable {
    environment.systemPackages = [
        my-duplicate-alacritty
        my-set-brightness
        my-screenshot
        # my-shadowbox
        my-screencast
        my-monitor-manager
        my-color-picker
        my-bluetooth-manager
        my-lockscreen
        my-reconnect-wifi
    ];

    home-manager.users.baldo = { config, pkgs, ... }:
    {
        home.file = {
            ".config/slop" = {
                source = ./slop-config;
                recursive = true;
            };
        };
    };
}
