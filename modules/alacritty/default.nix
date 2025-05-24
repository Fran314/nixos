{ config, pkgs, ...}:

let
    font-size = if (config.my.options.wm.xmonad.enable or false) then 7 else 12;
    padding = if (config.my.options.wm.xmonad.enable or false) then 5 else 10;
in {

	fonts.packages = with pkgs; [
		nerd-fonts.recursive-mono
	];

    home-manager.users.baldo = { config, pkgs, ... }:
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
                    size = font-size;
                };
                window = {
                    decorations = "none";
                    opacity = 0.9;
                    padding = {
                        x = padding;
                        y = padding;
                    };
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
