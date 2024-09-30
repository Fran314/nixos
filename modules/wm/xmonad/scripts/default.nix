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
    my-shadowbox = pkgs.writers.writePython3Bin "my-shadowbox" {
        libraries = [
            pkgs.gtk3
            pkgs.gobject-introspection
            pkgs.python3Packages.pycairo
            pkgs.python3Packages.pygobject3
        ];
        flakeIgnore = [
            "E265"  # Ignore errors for having shebang
            "E402"  # Ignore erros for having import not at top (required for gi)
        ];
    } (builtins.readFile ./my-shadowbox);
in lib.mkIf config.my.options.wm.xmonad.enable {
    environment.systemPackages = [
        my-duplicate-alacritty
        my-set-brightness
        my-screenshot
        my-shadowbox
    ];
}
