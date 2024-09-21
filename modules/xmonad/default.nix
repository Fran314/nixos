{ config, pkgs, ... }:

{
    services.xserver.windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = builtins.readFile ./xmonad.hs;
    };
    
    # services.xserver.displayManager.sessionCommands = ''
    #     ${pkgs.feh}/bin/feh --bg-scale <path/to/image>
    # '';
    # 
    # home-manager.users.baldo = { config, pkgs, ... }:
    # {
    #     home.packages = with pkgs; [
    #         feh
    #     ];
    #
    #     gtk.enable = true;
    #     gtk.theme.package = pkgs.nordic;
    #     gtk.theme.name = "Nordic";
    # };
}
