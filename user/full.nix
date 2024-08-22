{ config, pkgs, ... }:

{
    imports = [
        ./minimal.nix
        ./modules/xdg.nix
        ./modules/gnome
        ./modules/alacritty
    ];

    home.packages = with pkgs; [
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
