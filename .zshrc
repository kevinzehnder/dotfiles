# detect architecture
ARCH=$(uname -m)

# Initialize starship prompt
eval "$(starship init zsh)"

# initialize zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ZSH vi mode
export ZVM_INIT_MODE=sourcing # vi mode for zsh

# Core configuration files (order matters)
source "$HOME/.config/zsh/config.d/core/plugins.zsh"     # Zi plugins
source "$HOME/.config/zsh/config.d/core/options.zsh"     # ZSH options
source "$HOME/.config/zsh/config.d/core/environment.zsh" # Environment variables
source "$HOME/.config/zsh/config.d/core/keybindings.zsh" # Key bindings
source "$HOME/.config/zsh/config.d/core/completion.zsh"  # Completion system
source "$HOME/.config/zsh/config.d/core/aliases.zsh"     # Aliases

# Load remaining config files
if [ -d "$HOME/.config/zsh/config.d/" ]; then
	for conf in "$HOME/.config/zsh/config.d/"*.zsh; do
		source "${conf}"
	done
	unset conf
fi

# Load host-specific configuration if it exists
HOSTNAME=$(hostname -s 2> /dev/null || uname -n)
HOST_CONFIG="$HOME/.config/zsh/config.d/hosts/${HOSTNAME}.zsh"
if [[ -f "$HOST_CONFIG" ]]; then
	source "$HOST_CONFIG"
fi

# Load Atuin last
zinit ice as"command" from"gh-r" bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin"
zinit light atuinsh/atuin
source "$HOME/.config/zsh/config.d/core/atuin_init.zsh"
