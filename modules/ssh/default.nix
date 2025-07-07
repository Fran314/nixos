{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.my.options.ssh;
in
{
  options.my.options.ssh = {
    authorizedKeys = mkOption {
      description = "files for authorized keys";
      type = with types; listOf str;
      default = [ ];
    };

    fail2ban = mkEnableOption "";
  };

  config = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    networking.firewall.allowedTCPPorts = [ 22 ];

    users.users.baldo.openssh.authorizedKeys.keys = cfg.authorizedKeys;

    services.fail2ban.enable = cfg.fail2ban;
  };
}
