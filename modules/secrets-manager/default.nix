{
  pkgs,
  ...
}:

let
  secrets-manager = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/Fran314/secrets-manager-rs";
    rev = "521423fa544a68d0341bd3479c3eeb4002a92193";
  }) { };
in
{
  environment.systemPackages = [
    secrets-manager
  ];

  home-manager.users.root =
    { config, pkgs, ... }:
    {
      home.file = {
        ".config/secrets-manager/secrets-manager.toml" = {
          source = ./secrets-manager.toml;
        };
      };
    };
}
