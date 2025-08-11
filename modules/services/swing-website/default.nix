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
    cifs-utils # needed for the storage box

    nodejs
    cpulimit
    ffmpeg
  ];

  fileSystems."/mnt/storage-box" = {
    # This is necessary instead of simply using `secrets.samba.altaria."device"`
    # because that value has a new line and this breaks everything.
    # The `builtins.head` + `splitString` extracts the first line
    device = (builtins.head (lib.strings.splitString "\n" secrets.samba.altaria."device"));
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=/secrets/samba/altaria/credentials,uid=1000,gid=100" ];
  };
  systemd.tmpfiles.rules = [
    "d /mnt/storage-box 0755 baldo users - -"
  ];

  services.caddy = {
    virtualHosts."pisa.baldino.dev" = {
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
      # ExecStart = ''${pkgs.nodejs}/bin/npm run serve'';
      # Since it's still in developement, run dev instead of serve for
      # automatic reload. Once officially in production, use run serve
      ExecStart = ''${pkgs.nodejs}/bin/npm run dev'';
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
