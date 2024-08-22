{ config, pkgs, ... }:

{
    imports = [
        ./minimal.nix
        ./modules/xdg.nix
        ./modules/gnome.nix
        ./modules/alacritty/alacritty.nix
    ];

    home.packages = with pkgs; [
        ### TEMP
        dconf2nix
        gnome.dconf-editor

        ### Font(s)
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

        ### Daily usage
        alacritty
        firefox
        gnome.nautilus 

        ### Utility
        bitwarden-cli
    ];

    fonts.fontconfig.enable = true;
}
