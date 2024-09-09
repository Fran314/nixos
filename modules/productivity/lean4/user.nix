{ config, pkgs, ...}:

{
    home.packages = with pkgs; [
        lean4
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
                version = "0.0.23";
                sha256 = "sha256-DlP3O2mMAIXV7XwcZFHpa4Vp/9cxxtu9O+gQUW8MddA=";
            }
        ];
    };
}
