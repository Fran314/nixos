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
    slskd = mkEnableOption "enable reverse proxy from slskd.home to :5030";
  };

  config = mkIf cfg.slskd {
    services.caddy = {
      virtualHosts."slskd.home" = {
        serverAliases = [ "slskd.lan" ];
        extraConfig = ''
          reverse_proxy http://localhost:5030
          tls internal
        '';
      };
    };
    networking.firewall = {
      allowedTCPPorts = [
        5030
      ];
    };
  };
}
