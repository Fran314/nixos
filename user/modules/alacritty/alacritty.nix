{ config, pkgs, ...}:

{
    programs.alacritty = {
        enable = true;
        settings = {
            import = [ "~/.config/alacritty/catppuccin-macchiato.toml" ];
            colors.primary.background = "#282A28";
            font.size = 12;
            window = {
                opacity = 0.9;
                padding = {
                    x = 10;
                    y = 10;
                };
            };
        };

    };

    home.file = {
        ".config/alacritty" = {
            source = ./config;
            recursive = true;
        };
    };
}
