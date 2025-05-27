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
    handbrake = mkEnableOption "enable reverse proxy from handbrake.home to :5800";
  };

  config = mkIf cfg.handbrake {
    services.caddy = {
      virtualHosts."handbrake.home" = {
        serverAliases = [ "handbrake.lan" ];
        extraConfig = ''
          reverse_proxy http://localhost:5800
          tls internal
        '';
      };
    };
    networking.firewall.allowedTCPPorts = [
      5800
    ];
  };
}
