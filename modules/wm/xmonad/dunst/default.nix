{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
{
  options.my.options.wm.xmonad.dunst = {
    enable = mkEnableOption "";
  };

  config = mkIf config.my.options.wm.xmonad.dunst.enable {
    environment.systemPackages = with pkgs; [
      libnotify # to have `notify-send`
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.noto
    ];

    home-manager.users.baldo =
      { config, pkgs, ... }:
      {
        services.dunst = {
          enable = true;
          settings = {
            global = {
              width = "(0, 300)";
              height = 300;
              origin = "top-right";
              offset = "25x25";
              notification_limit = 5;
              icon_corner_radius = 4;
              frame_width = 3;
              frame_color = "#388E3C";
              font = "NotoSans Nerd Font 10";
              makrup = "full";
              format = "<b>%s</b>\n%b";
              show_indicators = false;
              corner_radius = 12;

              # Icons
              # enable_recursive_icon_lookup = true;
              # icon_theme = "Adwaita";
              min_icon_size = 32;
              max_icon_size = 128;
            };

            urgency_low = {
              background = "#282A28D9";
              foreground = "#888888";
              timeout = 10;
            };

            urgency_normal = {
              background = "#282A28D9";
              foreground = "#ffffff";
              timeout = 10;
            };

            urgency_critical = {
              background = "#900000D9";
              foreground = "#ffffff";
              frame_color = "#ff0000";
              timeout = 0;
            };

            # spotify_as_minecraft_advancement = {
            #   appname = "Spotify";
            #   background = "#292929";
            #   foreground = "#ffffff";
            #   frame_color = "#5b5b5b";
            #   # We use Nix multi-line strings ('') here so the heavy HTML/quotes don't break the syntax
            #   format = ''<tt><span font_family="Minecraft" line_height="1.5"><span foreground="yellow" text_transform="capitalize"><b>%s!     </b></span>\n<span text_transform="capitalize">%b     </span></span></tt>'';
            #   min_icon_size = 40;
            #   max_icon_size = 40;
            # };

            telegram = {
              appname = "Telegram Desktop";
              icon_position = "off";
              format = ''<b>%s</b>\n%b'';
              timeout = 20;
            };
          };
        };
      };
  };
}
