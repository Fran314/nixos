{ lib, config, pkgs, ... }:

with lib; {
    options.my.options.wm.xmonad.dunst = {
        enable = mkEnableOption "";
    };

    config = mkIf config.my.options.wm.xmonad.dunst.enable {
        environment.systemPackages = with pkgs; [
			libnotify	# to have `notify-send`
        ];

		fonts.packages = with pkgs; [
			nerd-fonts.noto
		];

        home-manager.users.baldo = { config, pkgs, ... }:
        {
			services.dunst = {
				enable = true;
				configFile = ./dunstrc;
			};
        };
    };
}
