{ config, pkgs, ...}:

{
    programs.neovim = {
        enable = true;
        defaultEditor = true;

        viAlias = true;
        vimAlias = true;

        ## By adding this, the system wide configuration overrides the user
        ## configuration, which I do not want but I don't know how to fix this
        # configure = {
        #     packages.myVimPackage = with pkgs.vimPlugins; {
        #         start = [  ];
        #     };
        # };
    };
}
