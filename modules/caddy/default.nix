{ lib, config, pkgs, ... }:

let
	cfg = config.my.options.caddy;
in
with lib; {
	options.my.options.caddy = {
		enable = mkEnableOption "enable caddy";

		dockge = mkEnableOption "enable reverse proxy from dockge.lan to :5001";
		pihole = mkEnableOption "enable reverse proxy from pihole.lan to :8081";
		jellyfin = mkEnableOption "enable reverse proxy from jellyfin.lan to :8096";
	};

	
	config = mkIf cfg.enable (mkMerge [
		{
			services.caddy = {
				enable = true;
			};
			networking.firewall.allowedTCPPorts = [
				80
				443
			];
		}

		(mkIf cfg.dockge {
			services.caddy = {
				virtualHosts."http://dockge.lan".extraConfig = ''
					reverse_proxy http://localhost:5001
				'';
			};
			networking.firewall.allowedTCPPorts = [
				5001
			];
		})

		(mkIf cfg.pihole {
			services.caddy = {
				virtualHosts."http://pihole.lan".extraConfig = ''
					redir / /admin
					reverse_proxy http://localhost:8081
				'';
			};
			networking.firewall.allowedTCPPorts = [
				53
				8081
			];
			networking.firewall.allowedUDPPorts = [
				53
				67
			];
		})

		(mkIf cfg.jellyfin {
			services.caddy = {
				virtualHosts."http://jellyfin.lan".extraConfig = ''
					reverse_proxy http://localhost:8096
				'';
			};
			networking.firewall.allowedTCPPorts = [
				8096
			];
		})
	]);
}
