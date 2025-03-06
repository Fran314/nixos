{ lib, config, pkgs, ... }:

with lib; {
	options.my.docker = {
		rootless = mkEnableOption "enable rootless mode for docker";
	};
	
	config = {
		virtualisation.docker.enable = true;
		users.users.baldo.extraGroups = mkIf (!config.my.docker.rootless) [ "docker" ]; # Needed if you're not using docker in rootless mode

		# Rootless mode
		virtualisation.docker.rootless = mkIf config.my.docker.rootless {
			enable = true;
			setSocketVariable = true;
		};
	};
}
