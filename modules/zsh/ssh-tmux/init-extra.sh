# Only run in interactive terminals accessed by ssh. To avoid any possible
# recursion, ensure that this is not running inside tmux
if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then

    if ! tmux has-session -t ssh-tmux > /dev/null 2>&1; then
        # If session doesn't exist, create it
        tmux -u new-session -s ssh-tmux

    elif ! tmux list-clients -F '#S' | grep -q ssh-tmux; then
        # Session exists. If nothing is attached to it, attach to it
        tmux -u attach-session -s ssh-tmux
    fi
fi
