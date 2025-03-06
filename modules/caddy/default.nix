{ lib, config, pkgs, ... }:

{
	services.caddy = {
		enable = true;
		virtualHosts."localhost".extraConfig = ''
			reverse_proxy http://localhost:8000
			tls internal
			'';
	};
}
