{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
{
  options.my.options.tmux = {
    tmux-main-session = mkEnableOption "";
  };

  config =
    let
      tmux-main-session = pkgs.writeShellApplication {
        name = "tmux-main-session";
        runtimeInputs = with pkgs; [
          bash
        ];
        text = builtins.readFile ./tmux-main-session;
      };
    in
    {
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

        # extraConfig = ''
        #   # https://reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
        #   set -g default-terminal "xterm-256color"
        #   set -ga terminal-overrides ",*256col*:Tc"
        #   set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        #   set-environment -g COLORTERM "truecolor"
        #
        #   set-option -g mouse on
        #
        #   set -g status-position top
        #
        #   set -g @catppuccin_flavour 'latte'
        # '';
        extraConfig = ''
          # Terminal capabilities
          set -g default-terminal "tmux-256color"
          set -ga terminal-overrides ",*256col*:Tc"
          set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
          set -as terminal-features 'alacritty:RGB,extkeys'
          set -as terminal-features 'xterm*:RGB,extkeys'
          set -g extended-keys always
          set-environment -g COLORTERM "truecolor"

          # General behavior
          set-option -g mouse on
          set -g status-position top
          set -sg escape-time 0      # no lag on Esc (important for nvim)
          set -g focus-events on     # let nvim see focus changes between panes

          # Prefix: Ctrl+Space
          unbind C-b
          set -g prefix C-Space
          bind C-Space send-prefix

          # Pane navigation (no prefix)
          bind -n M-h select-pane -L
          bind -n M-j select-pane -D
          bind -n M-k select-pane -U
          bind -n M-l select-pane -R

          # Window navigation (no prefix)
          bind -n M-H previous-window
          bind -n M-L next-window

          # Splits (open in current pane's directory)
          bind v split-window -h -c "#{pane_current_path}"
          bind s split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          # Window management
          # `c` for new window is the default — kept
          # `x` for kill pane is the default (with confirmation) — kept
          bind X confirm-before -p "kill window #W? (y/n)" kill-window

          # Theme
          set -g @catppuccin_flavour 'latte'
        '';
      };
    };
}
