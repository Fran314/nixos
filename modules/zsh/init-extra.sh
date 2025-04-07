export PATH="$PATH:$HOME/.local/bin"
export TERM=xterm-256color

setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

# To allow to tab-complete .. to ../
zstyle ':completion:*' special-dirs true

# To allow ctrl+arrow to work
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
