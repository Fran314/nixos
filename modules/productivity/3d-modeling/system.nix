{ config, pkgs, ...}:

{
    # Enable running AppImages with `appimage-run`
    # This is needed because the only way to run the 0.22dev is by using the
    # weekly appimage build available at https://github.com/FreeCAD/FreeCAD-Bundle/releases/tag/weekly-builds
    # This is extremely annoying but I don't really know any workaround as of now

    environment.systemPackages = with pkgs; [
        appimage-run
    ];
    programs.appimage.binfmt = true;
}
