{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "baldo";
  home.homeDirectory = "/home/baldo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
      alacritty
      firefox
  ];

  programs.git = {
    enable = true;
    userName = "Fran314";
    userEmail = "francesco.ghog@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/baldo/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };


  # FOR POP-SHELL CONFIGURATION, BUT IT NEEDS HOME-MANAGER
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
       	"pop-shell@system76.com" 
      ];
    };
    "org/gnome/shell/extensions/pop-shell" = {
      enabled = true;
      active-hint = true;
      active-hint-border-radius = lib.hm.gvariant.mkUint32 15;
      gap-inner = lib.hm.gvariant.mkUint32 6;
      gap-outer = lib.hm.gvariant.mkUint32 6;
      hint-color-rgba = "rgb(145,155,242)";
      show-title = false;
      smart-gaps = false;
      snap-to-grid = true;
      tile-by-default = true;
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
