{ pkgs, inputs, ... }:

{
  imports = [
    ../secrets-manager
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.variables.EDITOR = "nano";

  environment.systemPackages = with pkgs; [
    inputs.nixvim.packages.${system}.default
    age

    imagemagick
    mediainfo
    exiftool
    pdftk

    nix-search-cli

    home-manager
  ];

  home-manager.users.baldo =
    { config, pkgs, ... }:
    {
      home.username = "baldo";
      home.homeDirectory = "/home/baldo";

      nixpkgs.config.allowUnfree = true;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  home-manager.users.root =
    { config, pkgs, ... }:
    {
      home.username = "root";
      home.homeDirectory = "/root";

      nixpkgs.config.allowUnfree = true;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
