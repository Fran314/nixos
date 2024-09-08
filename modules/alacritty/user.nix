{ config, pkgs, ...}:

{
    programs.alacritty = {
        enable = true;
        settings = {
            # theme from https://github.com/alacritty/alacritty-theme
            import = [ "~/.config/alacritty/catppuccin-macchiato.toml" ];

            colors.primary.background = "#28282A";
            font = {
                normal = {
                    # family = "FiraCode Nerdfont Mono";
                    # family = "ComicShannsMono Nerdfont Mono";
                    # family = "DroidSansM Nerdfont Mono";
                    # family = "Caskaydia Mono Nerdfont Mono";
                    # family = "RecMonoLinear Nerdfont Mono";
                    # family = "RecMonoCasual Nerdfont Mono";
                    # family = "RecMonoSmCasual Nerdfont Mono";
                    family = "RecMonoDuotone Nerdfont Mono";
                    # family = "RobotoMono Nerdfont Mono";
                    # family = "SpaceMono Nerd Font Mono";
                    # family = "UbuntuMono Nerdfont Mono";
                    style = "Regular";
                };
                size = 12;
            };
            window = {
                decorations = "none";
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
