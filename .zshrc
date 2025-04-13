# detect architecture
ARCH=$(uname -m)

# Initialize starship prompt
eval "$(starship init zsh)"

# Initialize zi plugin manager
if [[ -r "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" ]]; then
	source "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" && zzinit
fi

# ZSH vi mode
export ZVM_INIT_MODE=sourcing # vi mode for zsh

# Core configuration files (order matters)
source "$HOME/.config/zsh/config.d/plugins.zsh"     # Zi plugins
source "$HOME/.config/zsh/config.d/options.zsh"     # ZSH options
source "$HOME/.config/zsh/config.d/environment.zsh" # Environment variables
source "$HOME/.config/zsh/config.d/keybindings.zsh" # Key bindings
source "$HOME/.config/zsh/config.d/completion.zsh"  # Completion system
source "$HOME/.config/zsh/config.d/aliases.zsh"     # Aliases

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Auto attach to tmux on local shells
# if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ]; then
# 	tmux attach -t default || tmux new -s default
# fi

# Load remaining config files
if [ -d "$HOME/.config/zsh/config.d/" ]; then
	for conf in "$HOME/.config/zsh/config.d/"*.zsh; do
		# Skip already loaded core config files
		case "${conf}" in
			*plugins.zsh|*options.zsh|*environment.zsh|*keybindings.zsh|*completion.zsh|*aliases.zsh) continue ;;
			*) source "${conf}" ;;
		esac
	done
	unset conf
fi
