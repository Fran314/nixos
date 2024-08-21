{ config, pkgs,  ... }:

{
    imports = [
        ./modules/zsh.nix
        ./modules/git.nix
        ./modules/nvim/nvim.nix
    ];
    home.username = "baldo";
    home.homeDirectory = "/home/baldo";

    home.packages = with pkgs; [
        tree
        rsync
        ripgrep
        fzf
        zip
        unzip
        xclip
        # rar
        # unrar
        bottom
        fastfetch

        ### Neovim plugins build dependencies
        gnumake
        cmake
        gcc

        ### Neovim LSP
        rust-analyzer

        ### Developement
        nodejs
    ];

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.11"; # Please read the comment before changing.

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
