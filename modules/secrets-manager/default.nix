{
  pkgs,
  ...
}:

let
  secrets-manager = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/Fran314/secrets-manager-rs";
    rev = "4089f4c6b4dd6d69b376e7842a476fa6fae441fd";
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
