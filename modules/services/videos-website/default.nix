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
    cpulimit
    ffmpeg
  ];

  services.caddy = {
    virtualHosts."videos.baldino.dev" = {
      extraConfig = ''
        handle_path /api/* {
          reverse_proxy http://localhost:6174
        }

        handle {
          root * /var/www/html/videos.baldino.dev/frontend
          try_files {path}.html {path} /index.html
          file_server
        }
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  systemd.services.videos-backend = {
    enable = true;
    description = "Backend for videos.baldino.dev";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      bash
      nodejs
      ffmpeg
      cpulimit
    ];
    serviceConfig = {
      Type = "simple";
      User = "baldo";
      Group = "users";
      WorkingDirectory = "/var/www/html/videos.baldino.dev/backend/";
      ExecStart = ''${pkgs.nodejs}/bin/npm run serve'';
    };
    environment = {
      NODE_ENV = "production";

      PORT = "6174";
      DATA_PATH = "/mnt/storage-box/videos.baldino.dev/data";
      LOG_PATH = "/mnt/storage-box/videos.baldino.dev/logs";
      TEMP_PATH = "/tmp/videos.baldino.dev";

      CPU_LIMIT = "66";
    };
  };
}
