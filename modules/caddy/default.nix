{ lib, config, pkgs, ... }:

{
	services.caddy = {
		enable = true;
		virtualHosts."http://jellyfin.lan".extraConfig = ''
			reverse_proxy http://localhost:8096
		'';
		virtualHosts."http://dockge.lan".extraConfig = ''
			reverse_proxy http://localhost:5001
		'';
		virtualHosts."http://pihole.lan".extraConfig = ''
			reverse_proxy http://localhost:8081
		'';
	};

    networking.firewall.allowedTCPPorts = [
		80
		443

		53		# pihole
		8081	# pihole

		5001	# Dockge
		8096	# Jellyfin
	];
	networking.firewall.allowedUDPPorts = [
		53		# pihole
		67		# pihole
	];
}
