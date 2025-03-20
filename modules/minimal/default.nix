{ config, pkgs, ... }:

{
    imports = [
        ../zsh
        ../tmux
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

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "it";
		variant = "";
		options = "caps:escape";
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
		file
        tree
        rsync
        ripgrep
        fzf
        zip
        unzip
        xclip
        bottom
        jq

        imagemagick
        mediainfo
		exiftool
        pdftk

        home-manager
    ];
    
    home-manager.users.baldo = { config, pkgs, ... }:
    {
        home.username = "baldo";
        home.homeDirectory = "/home/baldo";

        nixpkgs.config.allowUnfree = true;

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
