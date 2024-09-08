{ config, pkgs, ...}:

{
    home.packages = with pkgs; [
        prusa-slicer

        # I would very much like to add freecad here, but at the time of
        # writing the only available version in nix packages (both stable and
        # unstable) is 0.21.*, while weekly builds for 0.22.0dev exist. For now
        # it's best to download the weekly dev build as AppImage and run it.
        # When the 1.0 will come (which should be the version that 0.22 will
        # become) and when it will be added to nix packages, I'll happily add
        # it here
    ];
}
