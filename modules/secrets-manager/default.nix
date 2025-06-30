{
  pkgs,
  ...
}:

let
  secrets-manager = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/Fran314/secrets-manager-rs";
    rev = "b1076e863f974eb8a3fd2ae4e1bcc133fd63646d";
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
