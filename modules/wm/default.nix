{
  lib,
  config,
  pkgs,
  machine,
  private-data,
  ...
}:

with lib;
let
  background-image-path =
    private-data.outPath + "/background-images/final-fantasy/vivi-ornitier/background-1080p.png";
in
{
  imports = [
    ./gnome
    ./xmonad
  ];

  options.my.options.wm = {
    use = mkOption {
      type = types.enum [
        "xmonad"
        "gnome"
      ];
      description = "Chose which wm to use";
    };
  };

  config = mkMerge [
    {
      assertions = [
        # {
        #   assertion =
        #     lib.lists.count (x: x) [
        #       config.my.options.wm.gnome.enable
        #       config.my.options.wm.xmonad.enable
        #     ] <= 1;
        #   message = "Can only enable one wm at a time. WM in this module are mutually exclusive";
        # }
        {
          assertion = (builtins.pathExists background-image-path);
          message = ''
            file "background-image-path" imported from private-data repo is missing at location
            "${background-image-path}"

            Check that the file exists in the private-data repo
          '';
        }
        {
          assertion = ((builtins.readFileType background-image-path) == "regular");
          message = ''
            object "background-image-path" imported from private-data repo at location
            "${background-image-path}"
            is not a regular file.
          '';
        }
      ];

      my.options.wm.xmonad.enable = config.my.options.wm.use == "xmonad";
      my.options.wm.gnome.enable = config.my.options.wm.use == "gnome";

      # Enable the X11 windowing system.
      services.xserver.enable = true;

      # services.displayManager.sddm.wayland.enable = true;
      services.xserver.displayManager.lightdm.greeters.slick.enable = true;
      services.xserver.displayManager.lightdm.background = background-image-path;

      services.xserver.autoRepeatDelay = 250;
      services.xserver.autoRepeatInterval = 30;

      programs.dconf.enable = true; # Enables editing dconf via dconf.settings in home-manager
      home-manager.users.baldo =
        { config, pkgs, ... }:
        {
          # Fixes a bug for Wayland where the cursor doesn't render correctly
          # (wrong size or doesn't render at all) for some GTK applications such as
          # Alacritty
          home.pointerCursor = {
            gtk.enable = true;
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
            size = 22;
          };

          gtk = {
            enable = true;
            theme = {
              package = pkgs.nordic;
              name = "Nordic";
            };
            # theme = {
            #     package = pkgs.pop-gtk-theme;
            #     name = "Pop";
            # };
          };
        };
    }

    (mkIf (machine.name == "latias") {
      # Originally these were only for XMonad, but they seems to work nicely
      # with GNOME as well (they make idle go to sleep and lock instead of only making
      # the screen go black) so I'm leaving it here
      services.xserver.displayManager.sessionCommands = ''
        xset -dpms      # Disable Energy Star, as we are going to suspend anyway and it may hide "success" on that
        # xset s blank    # `noblank` may be useful for debugging 
        # xset s 900      # seconds
        xset s off
        ${pkgs.lightlocker}/bin/light-locker --idle-hint &
      '';
      systemd.targets.hybrid-sleep.enable = true;
      services.logind.settings.Login = {
        IdleAction = "hybrid-sleep";
        IdleActionSec = "60s";
      };

      services.libinput.touchpad.naturalScrolling = true;
    })

    (mkIf (machine.name == "kyogre") {
      services.xserver.displayManager.setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output ${machine.primary-monitor-output} --mode 1920x1080
      '';
    })
  ];
}
