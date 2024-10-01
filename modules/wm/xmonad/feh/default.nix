{ lib, config, pkgs, ... }:

with lib; {
    options.my.options.wm.xmonad.feh = {
        enable = mkEnableOption "";
    };

    config = mkIf config.my.options.wm.xmonad.feh.enable {
        services.xserver.displayManager.sessionCommands = ''
            systemctl --user restart random-changing-background.service
        '';

        # environment.systemPackages = with pkgs; [
        #     feh
        # ];

        home-manager.users.baldo = { config, pkgs, ... }:
        {
            systemd.user.services.random-changing-background = {
                Unit = {
                    Description = "Set random background from folder every 10-15 minutes";
                };
                Install = {
                    WantedBy = [ "default.target" ];
                };
                Service = {
                    ExecStart = "${pkgs.writeShellApplication {
                        name = "random-changing-background";
                        runtimeInputs = with pkgs; [
                            feh
                            findutils       # find
                            coreutils
                        ];
                        text = builtins.readFile ./random-changing-background;
                    }}/bin/random-changing-background";
                };
            };
        };
    };
}
