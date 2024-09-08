{ config, pkgs-unstable, ...}:

{
    home.packages = with pkgs-unstable; [
        prusa-slicer
    ];

    # I would very much like to add freecad to home.packages, but at the time
    # of writing the only available version in nix packages (both stable and
    # unstable) is 0.21.*, while weekly builds for 0.22.0dev exist. For now
    # it's best to download the weekly dev build as AppImage and run it.
    # When the 1.0 will come (which should be the version that 0.22 will
    # become) and when it will be added to nix packages, I'll happily add
    # it here
    #
    # Basically, download the weekly release from
    # https://github.com/FreeCAD/FreeCAD-Bundle/releases/tag/weekly-builds
    # and save it as ~/applications/FreeCAD.AppImage

    xdg.desktopEntries = {
        freecad = {
            name = "FreeCAD";
            exec = "appimage-run ${config.home.homeDirectory}/applications/FreeCAD.AppImage";
            type = "Application";
            categories = [ "Development" ];
        };
    };
}
