{ lib, config, pkgs, ... }:

{
	virtualisation.docker.enable = true;
    # # Needed if you're not using docker in rootless mode
    # # but not necessary since we're enabling rootless mode
    # users.users.baldo.extraGroups = [ "docker" ];
    virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
    };
}
