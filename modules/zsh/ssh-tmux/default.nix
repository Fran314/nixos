{ config, pkgs, lib, ... }:

with lib; {
    options.my.options.zsh.ssh-tmux = {
        enable = mkEnableOption "";
    };

    config = mkIf config.my.options.zsh.ssh-tmux.enable {
        environment.systemPackages = with pkgs; [
            tmux
        ];
        home-manager.users.baldo = { pkgs,  ... }:
        {
            programs.zsh = {
                initExtra =  builtins.readFile ./init-extra.sh;
            };
        };
    };
}

