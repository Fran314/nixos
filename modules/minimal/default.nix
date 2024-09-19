{ config, pkgs, ... }:

{
    imports = [
        ../zsh
        ../git
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

        home-manager
    ];
    
    # # I tried to add a service to make lock-on-sleep work on GNOME w/ lightdm
    # # but for some reason this doesn't work and I don't feel like investigating
    # # it right now
    # # For reference: https://www.perfacilis.com/blog/systeembeheer/linux/lock-screen-after-switching-from-gdm-to-lightdm.html
    # systemd.user.services.locker = {
    #     enable = true;
    #     description = "Turning light-locker on before sleep";
    #     before = [ "sleep.target" ];
    #     serviceConfig = {
    #         # User = "%I";
    #         Type = "forking";
    #         Environment = "XDG_SEAT_PATH=\"/org/freedesktop/DisplayManager/Seat0\"";
    #         ExecStart = "${pkgs.lightdm}/bin/dm-tool lock";
    #         ExecStartPost = "${pkgs.coreutils-full}/bin/sleep 1";
    #     };
    #     wantedBy = [ "sleep.target" ];
    # };

    home-manager.users.baldo = { lib, pkgs, pkgs-unstable, ... }:
    {
        imports = [
            # ../git/user.nix
            ../nvim/user.nix
            ../fastfetch/user.nix
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
            jq
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
