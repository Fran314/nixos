{ config, pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        history = {
            ignoreAllDups = true;
            path = "$HOME/.zsh_history";
            save = 10000000;
            size = 10000000;
        };
        initExtra = builtins.readFile ./init-extra.sh;
        shellAliases = {
            # Nix & Home-Manager
            nix-update="sudo nixos-rebuild switch --flake ~/.dotfiles";
            hm-update="home-manager switch --flake ~/.dotfiles#$HOST";

            # General purpose
            fuck="sudo $(fc -Lln -1)";
            open="xdg-open";
            treeh="tree -phDa -I .git -I node_modules -I target";
            pgrep="pgrep -a";
            fim="nvim $(fzf)";
            rsync="rsync -hv --info=progress2";

            # Git
            glog="git log --all --decorate --oneline --graph -15";

            # yt-dlp
            yt="noglob yt-dlp";
            ytmp3="noglob yt-dlp -f \"bestaudio\" -x --audio-format mp3";
            yt100m="noglob yt-dlp --format \"[filesize<100M]\"";
            yt200m="noglob yt-dlp --format \"[filesize<200M]\"";
            yt500m="noglob yt-dlp --format \"[filesize<500M]\"";

            # Rust stuff
            cclippy="cargo clippy --workspace --all-targets --all-features";
            # rscov="cargo tarpaulin --skip-clean --ignore-tests --target-dir ./target/test-coverage --out lcov --output-dir ./target/test-coverage";

            # # Pipe copy stuff
            # cbtxt="xclip -selection clipboard";
            # cbimg="xclip -selection clipboard -t image/png";
        };
    };
}
