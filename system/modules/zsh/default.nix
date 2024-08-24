{ config, pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions = {
            enable = true;
            strategy = [ "history" "completion" ];
        };

        shellAliases = {
            cp = "cp -i";
            mv = "mv -i";
            rmt="\\mv -ft $@ ~/.trash/";
            empty-trash="\\rm -rf ~/.trash && mkdir ~/.trash";
            lh="ls -lhA --group-directories-first";
            lt="ls -lhAtr";
        };

        promptInit = builtins.readFile ./prompt-init.sh;
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
}
