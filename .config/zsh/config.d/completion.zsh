#
# ZSH completion system configuration
#

# Basic completion settings
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Disable sort when completing git checkout
zstyle ':completion:*:git-checkout:*' sort false

# Completion groups and formatting
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Case insensitive matching and fuzzy matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Ignore specified patterns in completions
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Performance settings
zstyle ':completion:*' use-cache true
zstyle ':completion:*' rehash true

# FZF-tab settings
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' show-group none
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# Custom completions
function load_custom_completions() {
    local completion_dir="$HOME/.config/zsh/completions"
    setopt local_options nullglob
    local compfiles=("$completion_dir"/_*)
    if [[ -d $completion_dir ]] && [[ -n $compfiles ]]; then
        for file in "${compfiles[@]}"; do
            zi ice as"completion" lucid
            zi snippet "$file"
        done
    else
        echo "No completion files found in $completion_dir"
    fi
    unsetopt nullglob
}

# Load kubectl completion if available
[ -x "$(command -v kubectl)" ] && source <(kubectl completion zsh)