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
		baikal = mkEnableOption "enable reverse proxy from baikal.lan to :8082";
		vaultwarden = mkEnableOption "enable reverse proxy from vaultwarden.lan to :8083";
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
				virtualHosts."dockge.home" = {
					serverAliases = [ "dockge.lan" ];
					extraConfig = ''
						reverse_proxy http://localhost:5001
						tls internal
					''; 
				};
			};
			networking.firewall.allowedTCPPorts = [
				5001
			];
		})

		(mkIf cfg.pihole {
			services.caddy = {
				virtualHosts."pihole.home" = {
					serverAliases = [ "pihole.lan" ];
					extraConfig = ''
						redir / /admin
						reverse_proxy http://localhost:8081
						tls internal
					'';
				};
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
				virtualHosts."jellyfin.home" = {
					serverAliases = [ "jellyfin.lan" ];
					extraConfig = ''
						reverse_proxy http://localhost:8096
						tls internal
					'';
				};
			};
			networking.firewall.allowedTCPPorts = [
				8096
			];
		})

		(mkIf cfg.baikal {
			services.caddy = {
				virtualHosts."baikal.home" = {
					serverAliases = [ "baikal.lan" ];
					extraConfig = ''
						reverse_proxy http://localhost:8082
						tls internal
					'';
				};
			};
			networking.firewall.allowedTCPPorts = [
				8082
			];
		})

		(mkIf cfg.vaultwarden {
			services.caddy = {
				virtualHosts."vaultwarden.home" = {
					serverAliases = [ "vaultwarden.lan" ];
					extraConfig = ''
						reverse_proxy http://localhost:8083
						tls internal
					'';
				};
			};
			networking.firewall.allowedTCPPorts = [
				8083
			];
		})
	]);
}
