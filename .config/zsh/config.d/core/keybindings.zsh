#
# ZSH keyboard bindings
#

# Navigation
bindkey "^[[1;5C" forward-word                   # Ctrl+Right
bindkey "^[[1;5D" backward-word                  # Ctrl+Left
bindkey "^E" end-of-line                         # Ctrl+E
bindkey "^A" beginning-of-line                   # Ctrl+A
bindkey '^ ' forward-word                        # Ctrl+Space
bindkey '^[[H' beginning-of-line                 # Home
bindkey '^[[F' end-of-line                       # End

# History navigation
bindkey "^K" up-line-or-history                  # Ctrl+K
bindkey "^J" down-line-or-history                # Ctrl+J
bindkey '^R' history-incremental-search-backward # Ctrl+R
bindkey '^[[A' up-line-or-search                 # Up arrow
bindkey '^[[B' down-line-or-search               # Down arrow

# Editing
bindkey '^[[3~' delete-char                      # Delete

# Load fzf keybindings if available
[ -f "$HOME/.config/fzf/key-bindings.zsh" ] && source "$HOME/.config/fzf/key-bindings.zsh"
[[ $- == *i* ]] && source "$HOME/.config/fzf/completion.zsh" 2> /dev/null