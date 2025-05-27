{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.options.services;
in
with lib;
{
  options.my.options.services = {
    pihole = mkEnableOption "enable reverse proxy from pihole.home to :8081";
  };

  config = mkIf cfg.pihole {
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
    networking.firewall = {
      allowedTCPPorts = [
        53
        8081
      ];
      allowedUDPPorts = [
        53
        67
      ];
    };
  };
}
