{
  pkgs,
  ...
}:

let
  secrets-manager = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/Fran314/secrets-manager-rs";
    rev = "870ce747ff377d27455a0044bdc5142b750af5d9";
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
