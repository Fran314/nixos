{
  lib,
  pkgs,
  inputs,
  machine,
  secrets,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    nodejs
  ];

  services.caddy = {
    virtualHosts."music.baldino.dev" = {
      extraConfig = ''
        basic_auth {
          ${secrets.caddy.altaria."music-catalogue.basic-auth"}
        }
        reverse_proxy http://localhost:8294
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  systemd.services.music-catalogue = {
    enable = true;
    description = "Music catalogue";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      nodejs
    ];
    serviceConfig = {
      Type = "simple";
      User = "baldo";
      Group = "users";
      WorkingDirectory = "/var/www/html/music.baldino.dev/";
      ExecStart = ''${pkgs.nodejs}/bin/node index.js'';
    };
    environment = {
      NODE_ENV = "production";

      PORT = "8294";
      MUSIC_DIR = "/home/baldo/music-catalogue";
    };
  };
}
