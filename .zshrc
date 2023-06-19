# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -r "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" ]]; then
  source "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" && zzinit
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
else
   export EDITOR='nvim'
fi


# Base16 Shell
BASE16_SHELL="~/.zi/plugins/fnune---base16-shell/.config/base16-shell/"
[ -n "$PS1" ] && \
	    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
	            eval "$("$BASE16_SHELL/profile_helper.sh")"

zi ice wait lucid atload'!_zsh_autosuggest_start'
zi light zsh-users/zsh-autosuggestions

zi light zsh-users/zsh-completions
zi light z-shell/F-Sy-H
# zi load z-shell/H-S-MW

zi light romkatv/powerlevel10k

zi light Aloxaf/fzf-tab
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' show-group none

# neovim
zi ice as"program" from"gh-r" ver"nightly" bpick"*appimage*" mv"nvim* -> nvim"
zi light neovim/neovim

# lazygit
zi ice as"program" from"gh-r"
zi light jesseduffield/lazygit

# tree-sitter
zi ice as"program" from"gh-r" mv"tree* -> tree-sitter" pick"tree-sitter"
zi light tree-sitter/tree-sitter

# black formatter
zi ice as"program" from"gh-r" mv"black_linux -> black"
zi light psf/black

# ogham/exa, replacement for ls
zi ice wait"2" lucid from"gh-r" as"program" mv"bin/exa* -> exa"
zi light ogham/exa

# bat
zi ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zi light sharkdp/bat

# fd
zi ice as"command" from"gh-r" mv"fd* -> fdfind" pick"fdfind"
zi light sharkdp/fd

# junegunn/fzf-bin
zi ice from"gh-r" as"program" bpick"*linux_amd64*"
zi light junegunn/fzf

# ripgrep
zi ice as"program" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg"
zi light BurntSushi/ripgrep

# base16-shell and colors
zi ice from"gh" nocompile
zi light fnune/base16-fzf
zi light fnune/base16-shell

# docker and docker-compose completion
zi ice as"completion"
zi snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker
zi ice as"completion"
zi snippet https://github.com/docker/compose/tree/master/contrib/completion/zsh/_docker-compose

# kubelogin
zi ice as"program" from"gh-r" pick"bin/linux_amd64/kubelogin"
zi light Azure/kubelogin

# zsh settings
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=500000
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
set termguicolors
setopt auto_cd

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
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' use-cache true
zstyle ':completion:*' rehash true

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
bindkey "^E" end-of-line

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
alias lg='lazygit'
bindkey '^ ' forward-word

alias syu='sudo pacman -Syu'
alias dockerkill='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

alias light='base16_solarized-light && colorschemeswitcher 0'
alias dark='base16_tokyo-night && colorschemeswitcher 1'
alias gruv='base16_gruvbox-dark-medium && colorschemeswitcher 1'
alias gvim='gvim.exe'
alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim='nvim'

# additional configs
if [ -d "$HOME/.config/zsh/config.d/" ] ; then
  for conf in "$HOME/.config/zsh/config.d/"*.zsh ; do
      source "${conf}" 
  done
  unset conf
fi


colorschemeswitcher(){
  if [ $1 -eq 0 ]; then
    touch ~/.lightmode;
    source ~/.zi/plugins/fnune---base16-fzf/bash/base16-$BASE16_THEME.config;
  else
    rm -f ~/.lightmode;
    source ~/.zi/plugins/fnune---base16-fzf/bash/base16-$BASE16_THEME.config;
  fi
}


alias k='kubectl'
alias kc='kubectl config use-context'
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)


[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null
source ~/.zi/plugins/fnune---base16-fzf/bash/base16-$BASE16_THEME.config

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# golang
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin
alias air='~/go/bin/air'

# Configure ssh forwarding
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
# need `ps -ww` to get non-truncated command for matching
# use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
if [[ $ALREADY_RUNNING != "0" ]]; then
    if [[ -S $SSH_AUTH_SOCK ]]; then
        # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
        echo "removing previous socket..."
        rm $SSH_AUTH_SOCK
    fi
    # echo "Starting SSH-Agent relay..."
    # setsid to force new session to keep running
    # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi

# Check if the AppsUseLightTheme registry key exists and its value is 1
if /mnt/c/Windows/System32/reg.exe query 'HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' /v AppsUseLightTheme | grep -q '0x1'; then
  # If the registry key value is 1, print "light"
  light
else
  # If the registry key value is not 1, print "dark"
  dark
fi
