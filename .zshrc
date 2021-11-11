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
BASE16_SHELL="$ZINIT[PLUGINS_DIR]/fnune---base16-shell/.config/base16-shell/"
[ -n "$PS1" ] && \
	    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
	            eval "$("$BASE16_SHELL/profile_helper.sh")"

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# zinit
zinit light romkatv/powerlevel10k
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# bat
zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

# junegunn/fzf-bin
zinit ice from"gh-r" as"program"
zinit light junegunn/fzf-bin

# ripgrep
zinit ice as"program" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg"
zinit light BurntSushi/ripgrep

# base16-shell and colors
zinit ice from"gh" nocompile
zinit light fnune/base16-fzf
zinit light fnune/base16-shell

# docker and docker-compose completion
zinit ice as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker
zinit ice as"completion"
zinit snippet https://github.com/docker/compose/tree/master/contrib/completion/zsh/_docker-compose

# enable compinit
autoload -U compinit && compinit
autoload -Uz zmv

# zsh settings
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=500000
setopt appendhistory
setopt SHARE_HISTORY
set termguicolors
setopt auto_cd

# Backgrounding and Unbackgrounding {{{

# Use Ctrl-z swap in and out of vim (or any other process)
# https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
function ctrl-z-toggle () {
  if [[ $#BUFFER -eq 0 ]]; then
	BUFFER="setopt monitor && fg"
	zle accept-line
  else
	zle push-input
	zle clear-screen
  fi
}
zle -N ctrl-z-toggle
bindkey '^Z' ctrl-z-toggle

# END Backgrounding and Unbackgrounding }}}

# key bindings 
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

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

alias k='kubectl'
if [ $commands[kubectl] ]; then source <(kubectl completion zsh); fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null
source $ZINIT[PLUGINS_DIR]/fnune---base16-fzf/bash/base16-$BASE16_THEME.config
