{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.my.options.services;
in
with lib;
{
  options.my.options.services.forgejo = mkEnableOption "";

  config = {
    services.caddy = {
      enable = true;
      virtualHosts."git.home" = {
        extraConfig = ''
          reverse_proxy http://localhost:3000
          tls internal
        '';
      };
    };

    users.users.git = {
      home = "/var/lib/git";
      isSystemUser = true;
      group = "git";
      useDefaultShell = true;
    };
    users.groups.git = { };

    services.forgejo = {
      enable = true;
      package = pkgs.forgejo; # As opposed to the default pkgs.forgejo-lts

      stateDir = "/var/lib/git";
      user = "git";
      group = "git";
      database.name = "git";
      database.user = "git";

      lfs.enable = true; # Enable support for Git Large File Storage

      settings = {
        server = {
          DOMAIN = "git.home";
          ROOT_URL = "https://git.home/"; # If not set, it defaults to appending :HTTP_PORT
          HTTP_PORT = 3000;
        };

        repository = {
          ENABLE_PUSH_CREATE_USER = true;
        };

        # You can temporarily allow registration to create an admin user.
        service.DISABLE_REGISTRATION = false;
      };
    };
  };
}
