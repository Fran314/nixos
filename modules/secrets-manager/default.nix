{
  pkgs,
  ...
}:

let
  secrets-manager = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/Fran314/secrets-manager-rs";
    rev = "2af98b782c20b0902b7f7c250c3d986556c4dbaf";
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
