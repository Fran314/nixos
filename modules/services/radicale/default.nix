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
    radicale = mkEnableOption "enable reverse proxy from radicale.home to :5232";
  };

  config = mkIf cfg.radicale {
    services.caddy = {
      virtualHosts."radicale.home" = {
        serverAliases = [ "radicale.lan" ];
        extraConfig = ''
          reverse_proxy http://localhost:5232
          tls internal
        '';
      };
    };
    networking.firewall.allowedTCPPorts = [
      5232
    ];
  };
}
