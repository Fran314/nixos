{ lib, config, pkgs, ... }:

let
	cfg = config.my.options.docker;
in
with lib; {
	options.my.options.docker = {
		rootless = mkEnableOption "enable rootless mode for docker";
	};
	
	config = {
		virtualisation.docker.enable = true;
		users.users.baldo.extraGroups = mkIf (!cfg.rootless) [ "docker" ]; # Needed if you're not using docker in rootless mode

		# Rootless mode
		virtualisation.docker.rootless = mkIf cfg.rootless {
			enable = true;
			setSocketVariable = true;
		};
	};
}
