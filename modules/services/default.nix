{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./forgejo
    ./handbrake
    ./jellyfin
    ./pihole
    ./qbittorrent
    ./radicale
    ./vaultwarden
  ];

  services.caddy.enable = true;
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # https://discourse.nixos.org/t/correct-way-to-run-a-simple-http-server-forwarding-port-80-to-a-higher-port/50900/4
  # https://ar.al/2022/08/30/dear-linux-privileged-ports-must-die/
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;

  virtualisation = {
    containers.enable = true;

    podman.enable = true;

    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
