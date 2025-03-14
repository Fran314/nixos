{ lib, config, pkgs, ... }:

let
	cfg = config.my.options.services;
in
with lib; {
	options.my.options.services = {
		vaultwarden = mkEnableOption "enable reverse proxy from vaultwarden.home to :8083";
	};
	
	config = mkIf cfg.vaultwarden {
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
	};
}
