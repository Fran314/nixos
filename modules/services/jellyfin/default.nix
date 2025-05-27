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
    jellyfin = mkEnableOption "enable reverse proxy from jellyfin.home to :8096";
  };

  config = mkIf cfg.jellyfin {
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
  };
}
