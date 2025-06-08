{ config, pkgs, ... }:

{
  # Steam stuff
  programs.steam = {
    enable = true;
    # # Attempt at making steam not running in background when closed. Sadly it seems that this flag has been removed
    # package = pkgs.steam.override {
    #     extraEnv = {
    #         STEAM_FRAME_FORCE_CLOSE=true;
    #     };
    # };

    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    prismlauncher # Minecraft

    mangohud
  ];

  home-manager.users.baldo =
    { config, pkgs, ... }:
    {
      home.file = {
        ".config/MangoHud/MangoHud.conf" = {
          source = ./MangoHud.conf;
        };
      };
    };
}
