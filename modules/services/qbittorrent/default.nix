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
    qbittorrent = mkEnableOption "enable reverse proxy from qbittorrent.home to :8080";
  };

  config = mkIf cfg.qbittorrent {
    services.caddy = {
      virtualHosts."qbittorrent.home" = {
        serverAliases = [ "qbittorrent.lan" ];
        extraConfig = ''
          reverse_proxy http://localhost:8080
          tls internal
        '';
      };
    };
    networking.firewall.allowedTCPPorts = [
      8080
    ];
  };
}
