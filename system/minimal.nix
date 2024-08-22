{ config, pkgs, ... }:

{
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Rome";

    i18n.defaultLocale = "en_US.UTF-8";

    # i18n.extraLocaleSettings = {
    #     LC_ADDRESS = "it_IT.UTF-8";
    #     LC_IDENTIFICATION = "it_IT.UTF-8";
    #     LC_MEASUREMENT = "it_IT.UTF-8";
    #     LC_MONETARY = "it_IT.UTF-8";
    #     LC_NAME = "it_IT.UTF-8";
    #     LC_NUMERIC = "it_IT.UTF-8";
    #     LC_PAPER = "it_IT.UTF-8";
    #     LC_TELEPHONE = "it_IT.UTF-8";
    #     LC_TIME = "it_IT.UTF-8";
    # };

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
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
            setopt prompt_subst
            
            function precmd() {
                HOST_ICON=""
                if [[ $HOST == "umbreon" ]]; then
                    HOST_ICON=' %B%F{3}%f%b'
                elif [[ $HOST == "altaria" ]]; then
                    HOST_ICON=' %B%F{3}󰅟%f%b'
                fi
            
            
                ERROR_CODE_PROMPT='%(?.. %B%F{1}[%?]%b%f)'
            
            
                USERNAME_PROMPT=' %B%F{4}%n%b%f@%m'
                if [ $(id -u) -eq 0 ]; then
                    USERNAME_PROMPT=' %B%F{1}%n%b%f@%m'
                fi
            
            
                CWD_PROMPT=' %B%80<..<%~%<<%b'
            
            
                GIT_PROMPT=""
                if git rev-parse --is-inside-work-tree > /dev/null 2>&1
                then
                    GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
                    GIT_STATUS=$(git status --short | cut -c 1-2)
                    GIT_UPSTREAM=$(git rev-parse --abbrev-ref $GIT_BRANCH@{upstream} 2> /dev/null)
            
                    STATUS_PROMPT=""
                    if [[ $GIT_STATUS != "" ]]; then
                        INDEX=$(echo "$GIT_STATUS" | cut -c 1)
                        TREE=$(echo "$GIT_STATUS" | cut -c 2)
            
                        INDEX_A=$(echo $INDEX | tr -cd 'A' | wc -c)
                        INDEX_M=$(echo $INDEX | tr -cd 'MTRCU' | wc -c)
                        INDEX_D=$(echo $INDEX | tr -cd 'D' | wc -c)
            
                        TREE_A=$(echo $TREE | tr -cd 'A?' | wc -c)
                        TREE_M=$(echo $TREE | tr -cd 'MTRCU' | wc -c)
                        TREE_D=$(echo $TREE | tr -cd 'D' | wc -c)
            
                        INDEX_PROMPT=""
                        TREE_PROMPT=""
            
                        if [[ $INDEX_A != "0" ]];     then; INDEX_PROMPT+="%F{2}+$INDEX_A"; fi
                        if [[ $INDEX_M != "0" ]];     then; INDEX_PROMPT+="%F{3}~$INDEX_M"; fi
                        if [[ $INDEX_D != "0" ]];     then; INDEX_PROMPT+="%F{1}-$INDEX_D"; fi
                        if [[ $INDEX_PROMPT == "" ]]; then; INDEX_PROMPT="%F{0}-";          fi
            
                        if [[ $TREE_A != "0" ]];     then; TREE_PROMPT+="%F{2}+$TREE_A"; fi
                        if [[ $TREE_M != "0" ]];     then; TREE_PROMPT+="%F{3}~$TREE_M"; fi
                        if [[ $TREE_D != "0" ]];     then; TREE_PROMPT+="%F{1}-$TREE_D"; fi
                        if [[ $TREE_PROMPT == "" ]]; then; TREE_PROMPT="%F{0}-";         fi
            
                        STATUS_PROMPT=" ($INDEX_PROMPT%f|$TREE_PROMPT%f)"
                    fi
            
                    UPSTREAM_PROMPT=""
                    if [[ $GIT_UPSTREAM != "" ]]; then
                        GIT_AHEAD=$(git log $GIT_BRANCH..$GIT_UPSTREAM --oneline --no-decorate | wc -l)
                        GIT_BEHIND=$(git log $GIT_UPSTREAM..$GIT_BRANCH --oneline --no-decorate | wc -l)
            
                        if [[ $GIT_AHEAD != "0" ]]; then
                            UPSTREAM_PROMPT+="%F{4}↑"
                            if [[ $GIT_AHEAD != "1" ]]; then
                                UPSTREAM_PROMPT+=$GIT_AHEAD
                            fi
                        fi
            
                        if [[ $GIT_BEHIND != "0" ]]; then
                            UPSTREAM_PROMPT+="%F{3}↓"
                            if [[ $GIT_BEHIND != "1" ]]; then
                                UPSTREAM_PROMPT+=$GIT_BEHIND
                            fi
                        fi
            
                        if [[ $UPSTREAM_PROMPT != "" ]]; then
                            UPSTREAM_PROMPT="|$UPSTREAM_PROMPT%f"
                        fi
                    fi
            
                    GIT_PROMPT=" [%B%F{2}$GIT_BRANCH%b%f$UPSTREAM_PROMPT]"
                    GIT_PROMPT+=$STATUS_PROMPT
                fi
            
            
                PROMPT='┌'
                PROMPT+=$HOST_ICON
                PROMPT+=$ERROR_CODE_PROMPT
                PROMPT+=$USERNAME_PROMPT
                PROMPT+=$CWD_PROMPT
                PROMPT+=$GIT_PROMPT
                PROMPT+=$'\n'
                PROMPT+='└> '
            }
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

        vim
        neovim
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
