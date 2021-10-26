# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
else
   export EDITOR='vim'
fi


# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
	    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
	            eval "$("$BASE16_SHELL/profile_helper.sh")"

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# zinit
zinit light romkatv/powerlevel10k
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting
zinit pack"binary" for fzf

# zsh settings
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# fzf
export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=50%
--multi
--prompt='∼ ' --pointer='▶' --marker='✓'
--bind 'ctrl-a:select-all'
"                                   

export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export COLORTERM="truecolor"

# Aliases
alias ls='ls -h --color=auto'
alias ll='ls -al'
alias la='ls -A'
alias l='ls -CF'
alias svim='sudo vim'
alias h='cd'
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../..'
alias cim='vim'
alias back='cd $OLDPWD'
alias root='sudo su'
alias runlevel='sudo /sbin/init'
alias dfh='df -h'
alias gvim='gvim -geom 84x26'
alias start='dbus-launch startx'
alias ip='ip -c'
alias ipa='ip -o address'

alias d='docker'
alias ap='ansible-playbook'
bindkey '^ ' forward-word

alias syu='sudo pacman -Syu'
alias dockerkill='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

alias light='base16_flattened-light'
alias dark='base16_flattened-dark'
alias gruv='base16_gruvbox-dark-medium'
alias gvim='gvim.exe'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# kubernetes
alias k='kubectl'
if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

# set colors for LS_COLORS
eval `dircolors ~/.dircolors`

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh
[[ $- == *i* ]] && source ~/.fzf.shell/completion.zsh 2> /dev/null
source ~/base16-fzf/bash/base16-$BASE16_THEME.config
