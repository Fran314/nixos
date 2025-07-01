{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.my.options.ssh;
in
{
  options.my.options.ssh = {
    authorizedKeyFiles = mkOption {
      description = "files for authorized keys";
      type = types.listOf types.path;
    };

    fail2ban = mkEnableOption "";
  };

  config = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    users.users.baldo.openssh.authorizedKeys.keyFiles = cfg.authorizedKeyFiles;

    services.fail2ban.enable = cfg.fail2ban;
  };
}
