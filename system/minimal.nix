{ config, pkgs, ... }:

{
    imports = [
        ./modules/nvim.nix
    ];

    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Rome";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "it_IT.UTF-8";
        LC_IDENTIFICATION = "it_IT.UTF-8";
        LC_MEASUREMENT = "it_IT.UTF-8";
        LC_MONETARY = "it_IT.UTF-8";
        LC_NAME = "it_IT.UTF-8";
        LC_NUMERIC = "it_IT.UTF-8";
        LC_PAPER = "it_IT.UTF-8";
        LC_TELEPHONE = "it_IT.UTF-8";
        LC_TIME = "it_IT.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    # services.xserver.displayManager.gdm.wayland = false;
    services.xserver.desktopManager.gnome.enable = true;
    services.gnome.core-utilities.enable = false; # Remove additional packages from GNOME
    programs.dconf.enable = true;
    environment.gnome.excludePackages = [         # Remove even more packages from GNOME
        # pkgs.adwaita-icon-theme
        # pkgs.epiphany
        # pkgs.evince
        # pkgs.file-roller
        # pkgs.geary
        # pkgs.gnome-calendar
        # pkgs.gnome-connections
        # pkgs.gnome-console
        # pkgs.gnome-font-viewer
        # pkgs.gnome-system-monitor
        # pkgs.gnome-text-editor
        # pkgs.gnome-themes-extra
        pkgs.gnome-tour
        # pkgs.gnome-user-docs
        # pkgs.gnome.gnome-backgrounds
        # pkgs.gnome.gnome-characters
        # pkgs.gnome.gnome-clocks
        # pkgs.gnome.gnome-contacts
        # pkgs.gnome.gnome-logs
        # pkgs.gnome.gnome-maps
        # pkgs.gnome.gnome-music
        # pkgs.gnome.gnome-weather
        # pkgs.nautilus
        # pkgs.orca
        # pkgs.simple-scan
        # pkgs.sushi
        # pkgs.totem
        # pkgs.yelp
        # pkgs.baobab
        # pkgs.gnome-calculator
        # pkgs.loupe
        # pkgs.simple-scan
        # pkgs.snapshot
    ];

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "it";
        variant = "";
    };

    # Configure console keymap
    console.keyMap = "it2";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    hardware.bluetooth.enable = true;

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;
        
        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
    
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.baldo = {
        isNormalUser = true;
        description = "baldo";
        extraGroups = [ "networkmanager" "wheel" ];
    };

    # To enable system packages completion
    # See: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enableCompletion
    environment.pathsToLink = [ "/share/zsh" ];
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;

        shellAliases = {
            cp = "cp -i";
            mv = "mv -i";
            rmt="\\mv -ft $@ ~/.trash/";
            empty-trash="\\rm -rf ~/.trash && mkdir ~/.trash";
            lh="ls -lhA --group-directories-first";
            lt="ls -lhAtr";
        };

        promptInit = ''
            autoload -Uz vcs_info
            setopt prompt_subst
            precmd() { vcs_info }
            zstyle ':vcs_info:git*' actionformats '%f[%B%F{2}%b%f%%b|%B%F{1}%a%f%%b] '
            zstyle ':vcs_info:git*' formats       '%f[%B%F{2}%b%f%%b]'

            if [ $(id -u) -eq 0 ]
            then
                USERNAME_PROMPT='%B%F{red}%n'
            else
                USERNAME_PROMPT='%B%F{blue}%n'
            fi
            if [[ $HOST == "umbreon" ]]
            then
                HOST_ICON='%B%F{yellow}%f%b '
            elif [[ $HOST == "altaria" ]]
            then
                HOST_ICON='%B%F{yellow}󰅟%f%b '
            else
                HOST_ICON=""
            fi
            PROMPT='┌ '                        # Arrow start
            PROMPT+=$HOST_ICON                 # Host icon
            PROMPT+='%(?..%B%F{red}[%?]%f%b )' # Error code
            PROMPT+=$USERNAME_PROMPT           # Username
            PROMPT+='%f%b@%m %B%80<..<%~%<<%b' # Truncated path
            PROMPT+=' ''${vcs_info_msg_0_}'    # Git info
            PROMPT+=$'\n└> '                   # New line and end arrow
        '';
        # syntaxHighlighting.enable = true;
    };
    users.defaultUserShell = pkgs.zsh;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        wget
        git

        home-manager
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
