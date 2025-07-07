{ pkgs, inputs, ... }:

{
  imports = [
    ../secrets-manager
  ];

  nixpkgs.config.allowUnfree = true;

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    inputs.nixvim.packages.${system}.default
    age

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
