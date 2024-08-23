{ config, pkgs, ... }:

{
    imports = [
        ./minimal.nix
        ./modules/xdg
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
        telegram-desktop

        ### Utility
        bitwarden-cli
    ];

    fonts.fontconfig.enable = true;
}
