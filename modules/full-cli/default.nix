{ pkgs, inputs, ... }:

{
  imports = [
    ../secrets-manager
    ../music-normalizer
  ];

  nixpkgs.config.allowUnfree = true;

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    inputs.nixvim.packages.${stdenv.hostPlatform.system}.default
    age

    python3

    imagemagick
    mediainfo
    exiftool
    pdftk

    nix-search-cli
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
