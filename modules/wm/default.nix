{ lib, config, pkgs, ... }:

with lib; {
    imports = [
        ./gnome
        ./xmonad
    ];

    options.my.options = {
        wm = mkOption {
            type = types.enum [ "gnome" "xmonad" ];
            description = "Chose which wm to use";
        };
    };

    config = {
        # Enable the X11 windowing system.
        services.xserver.enable = true;

        # services.displayManager.sddm.wayland.enable = true;
        services.xserver.displayManager.lightdm.greeters.slick.enable = true;

        # Originally these were only for XMonad, but they seems to work nicely
        # with GNOME as well (they make idle go to sleep and lock instead of only making
        # the screen go black) so I'm leaving it here
        services.xserver.displayManager.sessionCommands = ''
            xset -dpms      # Disable Energy Star, as we are going to suspend anyway and it may hide "success" on that
            xset s blank    # `noblank` may be useful for debugging 
            xset s 300      # seconds
            ${pkgs.lightlocker}/bin/light-locker --idle-hint &
        '';
        systemd.targets.hybrid-sleep.enable = true;
        services.logind.extraConfig = ''
            IdleAction=hybrid-sleep
            IdleActionSec=20s
        '';

        # Configure keymap in X11
        services.xserver.xkb = {
            layout = "it";
            variant = "";
            options = "caps:escape";
        };

        services.libinput.touchpad.naturalScrolling = true;
    };
}
