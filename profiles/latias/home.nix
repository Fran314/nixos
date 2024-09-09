{ config, pkgs, ... }:

{
    imports = [
        ../../modules/minimal/user.nix
        ../../modules/xdg/user.nix
        ../../modules/gnome/user.nix
        ../../modules/nvim/user-with-gnome.nix
        ../../modules/alacritty/user.nix
        ../../modules/productivity/3d-modeling/user.nix
        ../../modules/productivity/lean4/user.nix
    ];

    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
        ### Daily usage
        firefox
        gnome.nautilus 
        telegram-desktop

        ### Occasional usage
        spotify
        vlc
        inkscape
        krita

        ### Developement
        cargo
        clippy
        python3Full
        nodejs
        godot_4

        ### Productivity
        (octaveFull.withPackages (ps: with ps; [
            # Search for `octavePackages` in NixOS packages to see all the possible options
            # Once in octave, load the package with `pkg load <name-of-the-package>`
            nurbs
        ]))

        ### Utility
        bitwarden-cli
        yt-dlp
    ];
}
