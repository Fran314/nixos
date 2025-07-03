{ pkgs, machine, ... }:

{
  imports = [
    ../zsh
    ../tmux
    ../git
    ../fastfetch
  ];

  networking.hostName = machine.name;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8"; # alternativetely it_IT.UTF-8
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
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    vim

    bat
    bottom
    file
    lsd
    tree
    rsync
    ripgrep
    fzf
    zip
    unzip
    xclip
    jq
    atool # tools to universally zip/unzip/tar/untar
    dust # disk space analyzer
    fd # better find
    yazi # file manager
    ets # pipe utility to get timestamps
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
