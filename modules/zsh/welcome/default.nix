{ config, pkgs, lib, ... }:

with lib; {
    options.my.options.zsh.welcome = {
        enable = mkEnableOption "";
        variant = mkEnableOption "";
		image = mkOption {
			type = types.str;
			description = "Which image to use (from the ones given in the module)";
		};
        textColor = mkOption {
            type = with types; either
			(enum [ "black" "red" "green" "yellow" "blue" "purple" "cyan" "white" ])
			(submodule {
				options = {
					r = mkOption { type = ints.u8; };
					g = mkOption { type = ints.u8; };
					b = mkOption { type = ints.u8; };
				};
			 });
            description = "Color for the hostname in the welcome message";
        };

    };

    config = mkIf config.my.options.zsh.welcome.enable {
        home-manager.users.baldo = { pkgs,  ... }:
        let
			cfg = config.my.options.zsh.welcome;
            c = cfg.textColor;
            color = if c == "black" then "0"
                else if c == "red" then "1"
                else if c == "green" then "2"
                else if c == "yellow" then "3"
                else if c == "blue" then "4"
                else if c == "purple" then "5"
                else if c == "cyan" then "6"
                else if c == "white" then "7"
                else "8;2;${builtins.toString c.r};${builtins.toString c.g};${builtins.toString c.b}";

            image = builtins.readFile (./. + "/${cfg.image}");
            variant = if cfg.variant
                then builtins.readFile (./. + "/${cfg.image}-variant")
                else "$IMAGE";

            displayScript = builtins.readFile ./display-welcome.sh;
            init = builtins.replaceStrings
                ["<<WELCOME-IMAGE>>" "<<VARIANT-IMAGE>>" "<<HOST-COLOR>>"]
                [image variant color]
                displayScript;
        in {
            programs.zsh = {
                initExtra =  init;
            };
        };
    };
}

