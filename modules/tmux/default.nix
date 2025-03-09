{ config, pkgs, lib, ... }:

with lib; {
    options.my.options.tmux = {
        tmux-main-session = mkEnableOption "";
    };

    config = let
        tmux-main-session = pkgs.writeShellApplication {
            name = "tmux-main-session";
            runtimeInputs = with pkgs; [
                bash
            ];
            text = builtins.readFile ./tmux-main-session;
        };
    in {
        environment.systemPackages = [
            (mkIf config.my.options.tmux.tmux-main-session tmux-main-session)
        ];

        programs.tmux = {
            enable = true;

            # Plugins inside here are run automatically with run-shell
            # https://github.com/NixOS/nixpkgs/blob/33b9d57c656e65a9c88c5f34e4eb00b83e2b0ca9/nixos/modules/programs/tmux.nix#L57
            plugins = with pkgs.tmuxPlugins; [
                catppuccin
                sensible
            ];

            extraConfig = ''
                # https://reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
                set -g default-terminal "xterm-256color"
                set -ga terminal-overrides ",*256col*:Tc"
                set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
                set-environment -g COLORTERM "truecolor"

                set-option -g mouse on

                set -g status-position top

                set -g @catppuccin_flavour 'latte'
            '';
        };
    };
}
