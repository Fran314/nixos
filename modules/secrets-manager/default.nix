{
  pkgs,
  ...
}:

let
  secrets-manager = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/Fran314/secrets-manager-rs";
    rev = "bc1d359463a9f0b8f9ba328bd5c51fa39e10ef06";
  }) { };
in
{
  environment.systemPackages = [
    secrets-manager
  ];
}
