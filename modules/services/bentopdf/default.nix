{
  lib,
  config,
  pkgs,
  ...
}:

{
  services.caddy = {
    virtualHosts."pdf.baldino.dev" = {
      extraConfig = ''
        reverse_proxy http://localhost:7524
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  virtualisation.oci-containers.containers = {
    bentopdf = {
      image = "bentopdf/bentopdf-simple:latest";
      ports = [ "7524:8080" ];
    };
  };
}
