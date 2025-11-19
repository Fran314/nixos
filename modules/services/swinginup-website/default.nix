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
    virtualHosts."swinginup.baldino.dev" = {
      serverAliases = [ "pisa.baldino.dev" ];
      extraConfig = ''
        handle_path /api/* {
          reverse_proxy http://localhost:6173
        }

        handle {
          root * /var/www/html/swinginup.baldino.dev/frontend
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

  systemd.services.swinginup-backend = {
    enable = true;
    description = "Backend for swinginup.baldino.dev";
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
      WorkingDirectory = "/var/www/html/swinginup.baldino.dev/backend/";
      ExecStart = ''${pkgs.nodejs}/bin/npm run serve'';
    };
    environment = {
      NODE_ENV = "production";

      PORT = "6173";
      DATA_PATH = "/mnt/storage-box/swinginup.baldino.dev/data";
      LOG_PATH = "/mnt/storage-box/swinginup.baldino.dev/logs";
      TEMP_PATH = "/tmp/swinginup.baldino.dev";

      CPU_LIMIT = "100";
    };
  };
}
