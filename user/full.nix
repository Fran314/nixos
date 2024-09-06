{ config, pkgs, ... }:

{
    imports = [
        ./minimal.nix
        ./modules/xdg
        ./modules/gnome
        ./modules/alacritty
        ./modules/productivity/3d-modeling
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

        ### Occasional usage
        vlc
        inkscape
        krita

        ### Developement
        cargo
        clippy

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

    fonts.fontconfig.enable = true;

    systemd.user.tmpfiles.rules = [
        "L %h/archivio - - - - /data/archivio"
        "L %h/desktop - - - - /data/desktop"
        "L %h/documents - - - - /data/documents"
        "L %h/pictures - - - - /data/pictures"
        "L %h/universita - - - - /data/universita"
        "L %h/videos - - - - /data/videos"
    ];
}
