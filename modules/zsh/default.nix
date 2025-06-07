{
  config,
  pkgs,
  lib,
  my-utils,
  ...
}:

with lib;
{
  imports = [
    ./welcome
  ];

  options.my.options.zsh = {
    hostIcon = mkOption {
      type = types.str;
      default = "";
      description = "Icon to show at the beginning of the prompt";
    };
  };

  config =
    let
      cfg = config.my.options.zsh;
    in
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions = {
          enable = true;
        };

        enableLsColors = true;

        histFile = "$HOME/.zsh_history";
        histSize = 10000000;
        setOptions = [
          "HIST_IGNORE_ALL_DUPS"
          "INC_APPEND_HISTORY" # Write to the history file immediately, not when the shell exits.
          "HIST_SAVE_NO_DUPS" # Don't write duplicate entries in the history file.
          "HIST_REDUCE_BLANKS" # Remove superfluous blanks before recording entry.
          "HIST_VERIFY" # Don't execute immediately upon history expansion.

          "EMACS"
          # Emacs mode is default mode. This forces the mode to be the default
          # mode. This is necessary because for some absurd reason, if zsh finds
          # the string "vi" in the $EDITOR environment variable, it defaults to vi
          # vi mode. This makes no sense to me. I want my default editor to be
          # "nvim", but I do NOT WANT vi mode in the terminal. I hate that this is
          # the default behaviour of zsh.
        ];

        shellAliases = {
          cp = "cp -i";
          mv = "mv -i";
          rmt = "\\mv -ft $@ ~/.trash/";
          empty-trash = "\\rm -rf ~/.trash && mkdir ~/.trash";

          ls = "lsd";
          ll = "lsd -l";
          lh = "lsd -lhA --group-directories-first";
          lt = "lsd -lhAtr";
          tree = "lsd --tree -I .git -I node_modules -I target";
          treeh = "lsd --tree -I .git -I node_modules -I target -l -git --date \"+%Y-%m-%d %H:%M:%S\"";

          dir-size-sort = "du -sh ./* ./.* 2>/dev/null | sort -h";
        };

        interactiveShellInit = ''
          export PATH="$PATH:$HOME/.local/bin"
          export TERM=xterm-256color

          # To allow to tab-complete .. to ../
          zstyle ':completion:*' special-dirs true

          # To allow ctrl+arrow to work
          bindkey "^[[1;5C" forward-word
          bindkey "^[[1;5D" backward-word
        '';
        promptInit = my-utils.readInterpolateWith { host-icon = cfg.hostIcon; } ./prompt-init.sh;
        # syntaxHighlighting.enable = true;
      };

      # Ensure that git is installed for zsh's custom prompt to
      # work correctly
      environment.systemPackages = with pkgs; [
        git
      ];

      # To enable system packages completion
      # See: https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enableCompletion
      environment.pathsToLink = [ "/share/zsh" ];

      users.defaultUserShell = pkgs.zsh;

      home-manager.users.baldo =
        { pkgs, ... }:
        {
          programs.zsh = {
            enable = true;

            history = {
              # But Fran314, aren't these options already set in the
              # system-wide settings for zsh? Well yes, but home-manager has
              # these options with default values and if they're left
              # undeclared the default value (which is false for ignoreAllDups
              # and saveNoDups) will override the system-wide value.
              #
              # This is also true for the size value. As for the path, both the
              # system-wide and the user values are actually the default value
              # but I left it here just to be sure
              ignoreAllDups = true;
              saveNoDups = true;
              path = "$HOME/.zsh_history";
              size = 10000000;
            };

            shellAliases = {
              # Nix Stuff
              nix-update = "sudo nixos-rebuild switch --flake ~/.dotfiles/nixos";
              nix-boot = "sudo nixos-rebuild boot --flake ~/.dotfiles/nixos";
              nix-test = "sudo nixos-rebuild test --flake ~/.dotfiles/nixos";
              nix-gc = "sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";

              # General purpose
              fuck = "sudo $(fc -Lln -1)";
              open = "xdg-open";
              pgrep = "pgrep -a";
              fim = "nvim $(fzf)";
              rsync = "rsync -hv --info=progress2";
              cdtemp = "cd $(mktemp -d)";
              cdlt = "cd $(ls -td -- */ | head -n 1)";

              # Git
              glog = "git log --all --decorate --oneline --graph -15";
              gsus = "git status --porcelain";
              giff = "git diff";

              # yt-dlp
              yt = "noglob yt-dlp";
              ytmp3 = "noglob yt-dlp -f \"bestaudio\" -x --audio-format mp3";
              yt100m = "noglob yt-dlp --format \"[filesize<100M]\"";
              yt200m = "noglob yt-dlp --format \"[filesize<200M]\"";
              yt500m = "noglob yt-dlp --format \"[filesize<500M]\"";

              # Rust stuff
              cclippy = "cargo clippy --workspace --all-targets --all-features";
              # rscov="cargo tarpaulin --skip-clean --ignore-tests --target-dir ./target/test-coverage --out lcov --output-dir ./target/test-coverage";

              # # Pipe copy stuff
              # cbtxt="xclip -selection clipboard";
              # cbimg="xclip -selection clipboard -t image/png";
            };
          };
        };
    };
}
