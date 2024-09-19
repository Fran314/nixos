{ config, pkgs, ...}:

{
    home-manager.users.baldo = { config, pkgs, ... }:
    {
        home.packages = with pkgs; [
            # Elan is a lean version manager. Why elan instead of lean directly?
            # I'm not 100% sure but with elan I could get mathematics_in_lean to
            # work, while I coulnd't make it work using lean4 directly, so here we
            # are
            #
            # To make mathematics_in_lean work, first run
            # `elan default leanprover/lean4:stable`
            # to actually instal lean4, then inside the mathematics_in_lean repo
            # run
            # `lake exe cache get`
            # and it should work out of the box

            elan
            # lean4
        ];

        programs.vscode = {
            enable = true;
            extensions = with pkgs.vscode-extensions; [
                # dracula-theme.theme-dracula
                # vscodevim.vim
                # yzhang.markdown-all-in-one
            ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                {
                    name = "lean4";
                    publisher = "leanprover";
                    version = "0.0.177";
                    sha256 = "sha256-4roh1M5F4eIX0UNNDCfO47zgJAL+nRnHUAD///4hbok=";
                }
            ];
        };
    };
}
