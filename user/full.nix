{ config, lib, pkgs, pkgs-unstable, ... }:

{
    imports = [
        ./minimal.nix
        ./modules/xdg.nix
        ./modules/gnome.nix
        ./modules/alacritty/alacritty.nix
    ];

    home.packages = with pkgs; [
        ### Daily usage
        alacritty
        firefox
        gnome.nautilus 
        gnome.gnome-font-viewer # temp

        (pkgs.nerdfonts.override {
            fonts = [
                # "FiraCode"
                # "ComicShannsMono"
                # "DroidSansMono"
                # "CascadiaMono"
                "Recursive"
                # "RobotoMono"
                # "SpaceMono"
                # "UbuntuMono"
            ];
        })
    ];

    fonts.fontconfig.enable = true;
}
