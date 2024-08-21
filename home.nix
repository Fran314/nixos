{ config, lib, pkgs, pkgs-unstable, ... }:

{
  home.username = "baldo";
  home.homeDirectory = "/home/baldo";

  home.packages = (with pkgs; [
    alacritty
    firefox

    gnumake
    cmake
    gcc
    ripgrep
    fzf
    tree
    zip
    unzip

    rust-analyzer

    nodejs

    gnome-extension-manager
    gnome.gnome-tweaks
    gnomeExtensions.pop-shell
    # gnomeExtensions.unite
    # gnomeExtensions.pixel-saver
    gnomeExtensions.just-perfection
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell

    gnomeExtensions.caffeine
    gnomeExtensions.boost-volume

    gnomeExtensions.vitals
    gnomeExtensions.runcat
  ])
  ++
  (with pkgs-unstable; [
    gnomeExtensions.rounded-window-corners-reborn
  ]);

  programs.git = {
    enable = true;
    userName = "Fran314";
    userEmail = "francesco.ghog@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  programs.zsh = {
    enable = true;
    history = {
      ignoreAllDups = true;
      path = "$HOME/.zsh_history";
      save = 10000000;
      size = 10000000;
    };
    initExtra = ''
      export PATH="$PATH:$HOME/.local/bin"
      export TERM=xterm-256color

      setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
      setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
      setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
      setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

      # To allow to tab-complete .. to ../
      zstyle ':completion:*' special-dirs true
    '';
    shellAliases = {
      fuck="sudo $(fc -Lln -1)";
      open="xdg-open";
      treeh="tree -phDa -I .git -I node_modules -I target";
      pgrep="pgrep -a";
      fim="nvim $(fzf)";
      rsync="rsync -hv --info=progress2";

      yt="noglob yt-dlp";
      ytmp3="noglob yt-dlp -f \"bestaudio\" -x --audio-format mp3";
      yt100m="noglob yt-dlp --format \"[filesize<100M]\"";
      yt200m="noglob yt-dlp --format \"[filesize<200M]\"";
      yt500m="noglob yt-dlp --format \"[filesize<500M]\"";

      # Rust stuff
      cclippy="cargo clippy --workspace --all-targets --all-features";
      rscov="cargo tarpaulin --skip-clean --ignore-tests --target-dir ./target/test-coverage --out lcov --output-dir ./target/test-coverage";

      # Pipe copy stuff
      cbtxt="xclip -selection clipboard";
      cbimg="xclip -selection clipboard -t image/png";
    };
  };
  programs.alacritty = {
    enable = true;
    settings = {
        import = [ "~/.config/alacritty/catppuccin-macchiato.toml" ];
        colors.primary.background = "#282A28";
        font.size = 12;
        window = {
            opacity = 0.9;
            padding = {
                x = 10;
                y = 10;
            };
        };
    };
    
  };

  home.file = {
    ".config/alacritty" = {
      source = config/alacritty;
      recursive = true;
    };
    ".config/nvim" = {
      source = config/nvim;
      recursive = true;
    };
  };

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/morphogenesis-l.svg";
      picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/morphogenesis-d.svg";
      primary-color = "#e18477";
      secondary-color = "#000000";
    };
    "org/gnome/desktop/interface" = {
      clock-format="24h";
      clock-show-seconds=true;
      color-scheme="prefer-dark";
      enable-animations=true;
      enable-hot-corners=false;
      show-battery-percentage=true;
    };
    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "it" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" "caps:escape" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        # "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        # "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>z";
        command = "alacritty";
        name = "Launch Terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>F2";
      command = "firefox";
      name = "Launch Firefox";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Super>F1";
      command = "alacritty --class 'nvim-memo' --working-directory '/home/baldo/.local/share/nvim/memo' -e nvim -c 'SessionsLoad'";
      name = "Launch Memo";
    };
    # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
    #   binding="<Control><Alt>l";
    #   command="dm-tool lock";
    #   name="Lockscreen";
    # };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "pop-shell@system76.com"
        "Vitals@CoreCoding.com"
        "rounded-window-corners@fxgn"
        "appindicatorsupport@rgcjonas.gmail.com"
        "caffeine@patapon.info"
        "runcat@kolesnikov.se"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
        "blur-my-shell@aunetx"
        "just-perfection-desktop@just-perfection"
        "boostvolume@shaquib.dev"
      ];
    };
    "org/gnome/shell/extensions/pop-shell" = {
      enabled = true;
      active-hint = true;
      active-hint-border-radius = mkUint32 15;
      gap-inner = mkUint32 6;
      gap-outer = mkUint32 6;
      hint-color-rgba = "rgb(145,155,242)";
      show-title = false;
      smart-gaps = false;
      snap-to-grid = true;
      tile-by-default = true;
    };
    # "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
    #   border-width = 0;
    #   global-rounded-corner-settings = "{'padding': <{'left': <uint32 1>, 'right': <uint32 1>, 'top': <uint32 1>, 'bottom': <uint32 1>}>, 'keep_rounded_corners': <{'maximized': <false>, 'fullscreen': <false>}>, 'border_radius': <uint32 12>, 'smoothing': <uint32 0>}";
    #   settings-version = mkUint32 5;
    # };
    "org/gnome/shell/extensions/just-perfection" = {
      enabled = true;
      accessibility-menu = true;
      background-menu = true;
      calendar = true;
      clock-menu = true;
      clock-menu-position-offset = 0;
      controls-manager-spacing-size = 0;
      dash = true;
      dash-icon-size = 0;
      double-super-to-appgrid = true;
      keyboard-layout = true;
      max-displayed-search-results = 0;
      osd = true;
      panel = true;
      panel-in-overview = true;
      ripple-box = true;
      search = true;
      show-apps-button = true;
      startup-status = 1;
      theme = false;
      top-panel-position = 1;
      window-demands-attention-focus = false;
      window-menu-take-screenshot-button = true;
      window-picker-icon = true;
      window-preview-caption = true;
      window-preview-close-button = true;
      workspace = true;
      workspace-background-corner-size = 0;
      workspace-popup = true;
      workspaces-in-app-grid = true;
    };
    "org/gnome/shell/extensions/vitals" = {
      enabled = true;
      alphabetize = true;
      fixed-widths = true;
      hide-icons = true;
      hot-sensors = ["_temperature_k10temp_tctl_" "_processor_usage_" "_storage_free_"];
      icon-style = 1;
      menu-centered = false;
      show-battery = false;
      show-fan = false;
      show-network = false;
      show-voltage = false;
      use-higher-precision = false;
    };
    "org/gnome/shell/extensions/runcat" = {
      enabled = true;
      idle-threshold = 5;
    };
    # "org/gnome/desktop/peripherals/touchpad" = {
    #   tap-to-click = true;
    #   tap-and-drag = false;
    # };
    # "org/gnome/desktop/peripherals/mouse" = {
    #   natural-scroll = true;
    #   accel-profile = "flat";
    #   speed = 0.5;
    # };
  };

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
