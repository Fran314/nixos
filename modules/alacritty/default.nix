{ config, pkgs, ... }:

{

  fonts.packages = with pkgs; [
    nerd-fonts.recursive-mono
  ];

  home-manager.users.baldo =
    { config, pkgs, ... }:
    {
      programs.alacritty = {
        enable = true;
        settings = {
          # theme from https://github.com/alacritty/alacritty-theme
          general.import = [ "~/.config/alacritty/catppuccin-macchiato.toml" ];

          colors.primary.background = "#28282A";
          font = {
            normal = {
              # family = "RecMonoDuotone Nerdfont Mono";
              family = "RecMonoDuotone Nerdfont"; # Actually, don't add 'Mono' at the end for bigger icons!
              style = "Regular";
            };

            # Yes, this is a weird value, but it's the one that looks nice.
            # 11.5 has the same number of rows in a fullscreen terminal, but
            # but the font is rendered with smaller (as in less tall) letters.
            # 11.9 or more is HUGE
            size = 11.7;
          };
          window = {
            decorations = "none";
            opacity = 0.9;
            padding = {
              x = 8;
              y = 8;
            };
          };
          env = {
            WINIT_X11_SCALE_FACTOR = "1"; # Necessary otherwise on latias w/ xmonad it would be
            #                               automatically set to 1.666... and make the font HUGE
          };
        };

      };

      home.packages = with pkgs; [
        alacritty
      ];

      fonts.fontconfig.enable = true; # unsure to if this goes here or not

      home.file = {
        ".config/alacritty" = {
          source = ./config;
          recursive = true;
        };
      };
    };
}
