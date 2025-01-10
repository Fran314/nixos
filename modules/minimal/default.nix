{ config, pkgs, ... }:

{
    imports = [
        ../zsh
        ../git
        ../nvim
        ../fastfetch
    ];

    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Rome";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";             # alternativetely it_IT.UTF-8
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    # Configure console keymap
    console.keyMap = "it2";

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.baldo = {
        isNormalUser = true;
        description = "baldo";
        extraGroups = [ "networkmanager" "wheel" ];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        wget
        curl
        git
        vim
        neovim

        bat
        bottom
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
        jq
        tmux

        home-manager
    ];
    
    home-manager.users.baldo = { config, pkgs, ... }:
    {
        home.username = "baldo";
        home.homeDirectory = "/home/baldo";

        nixpkgs.config.allowUnfree = true;

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
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
