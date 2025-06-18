#
# Collection of all common aliases, consolidated from .zshrc
#

# File navigation and listing
alias l='eza'
alias ls="eza --color=auto --icons"
alias ll='ls -alhg'
alias la='ls -a'
alias llm='ll --sort=modified' # ll, sorted by modification date
alias llz='ll -Z'
alias tree='eza --tree' # Better tree view with eza

# Directory navigation
alias h='cd'
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..' # Added deeper navigation
alias back='cd $OLDPWD'
alias -- -='cd -' # Quick way to go back

# System commands
alias runlevel='sudo /sbin/init'
alias root='sudo su'
alias ip='ip -c'
alias ipa='ip -o address'
alias syu='sudo pacman -Syu'

# Editor and tools
alias svim='sudo -E nvim' # Use -E to preserve environment variables
alias vim='nvim'
alias cim='nvim'
alias v='nvim' # Shorter alias for nvim
alias neovide='nohup neovide.exe --wsl --neovim-bin $(which nvim) >/dev/null 2>&1 &'
alias zshrc='nvim ~/.zshrc'
alias zshconf="nvim ~/.config/zsh/config.d"
alias sshconf='nvim ~/.ssh/config'

alias jsonv="vim -c 'set syntax=json' -"

# Container tools
alias d='sudo docker'
alias dcomp='sudo docker compose'
alias n='sudo nerdctl'
alias ncomp='sudo nerdctl compose'
alias dockerkill='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
alias ld='lazydocker'

# Development tools
alias ap='ansible-playbook'
alias lg='lazygit'
alias t='task'
alias tf='terraform'
alias tm='tmux attach -t default || tmux new -s default'
alias gh='gh.exe' # use windows based gh, because it supports credential store
alias tldrf="tldr --list | fzf --ansi --preview 'script -qec \"tldr {1}\" /dev/null' --height=80% --preview-window=right,60% | xargs tldr"

# Dotfiles management
alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Kubernetes
alias k='kubectl'
alias kc='kubectl config use-context'
alias kar='kubectl-argo-rollouts'
alias kns='kubectl config set-context --current --namespace' # Added namespace switching
alias kgp='kubectl get pods'                                 # Common kubectl commands
alias kgd='kubectl get deployments'

# Terminal multiplexers
alias zj='zellij'

# Documentation and help
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain -P'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain -P'
alias batp='bat -Pp'

# Navi settings
alias navic='navi --cheatsh'
alias navit='navi --tldr'
