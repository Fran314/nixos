{ lib, config, pkgs, ... }:

with lib; {
    options.my.options.wm.xmonad.battery-monitor = {
        enable = mkEnableOption "";
    };

    config = mkIf config.my.options.wm.xmonad.battery-monitor.enable {
        services.xserver.displayManager.sessionCommands = ''
            systemctl --user restart battery-monitor.service
        '';

        home-manager.users.baldo = { config, pkgs, ... }:
        {
            systemd.user.services.battery-monitor = {
                Unit = {
                    Description = "Monitor the level of battery";
                };
                Install = {
                    WantedBy = [ "default.target" ];
                };
                Service = {
                    ExecStart = "${pkgs.writeShellApplication {
                        name = "battery-monitor";
                        runtimeInputs = with pkgs; [
                            acpi
                            libnotify
                            gnugrep
                            coreutils # sleep
                        ];
                        text = builtins.readFile ./battery-monitor;
                    }}/bin/battery-monitor";
                };
            };
        };
    };
}
