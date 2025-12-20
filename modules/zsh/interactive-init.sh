cdmedia() {
	TARGET=${1:-$USER}
	# echo "$TARGET"
	if [[ ! -d /run/media/"$TARGET" ]]; then
		return
	fi

	DIR=$(find /run/media/"$TARGET" -maxdepth 1 -mindepth 1 | head -n 1)
	if [[ -d "$DIR" ]]; then
		# echo "$DIR"
		cd "$DIR" || exit
	fi
}

mkcd() {
	mkdir -p -- "$1" && cd -P -- "$1" || exit
}

# "Alias" to inject the environment shell into 'nix develop'
nix() {
	if [[ $1 == "develop" ]]; then
		shift
		command nix develop -c zsh "$@"
	else
		command nix "$@"
	fi
}

source "<nix-interpolate:fzf-history-search>/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh"

export PATH="$PATH:$HOME/.local/bin"
export TERM=xterm-256color

# To allow to tab-complete .. to ../
zstyle ':completion:*' special-dirs true

# To allow ctrl+arrow to work
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
