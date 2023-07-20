# p10k-instant-prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zi initialization
if [[ -r "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" ]]; then
  source "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" && zzinit
fi

zi light romkatv/powerlevel10k

zicompinit

zi wait lucid light-mode for \
    atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
    blockf atpull'zi creinstall -q .' zsh-users/zsh-completions

zi wait lucid light-mode as"program" from"gh-r" for \
    ver"nightly" bpick"*appimage*" mv"nvim* -> nvim" neovim/neovim \
    mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
    bpick"*linux_amd64*" junegunn/fzf \
    jesseduffield/lazygit \
    mv"tree* -> tree-sitter" pick"tree-sitter" tree-sitter/tree-sitter \
    mv"black_linux -> black" psf/black \
    mv"bin/exa* -> exa" ogham/exa \
    pick"bin/linux_amd64/kubelogin" Azure/kubelogin \
    pick"*Linux_amd64*" derailed/k9s \
    mv"fd* -> fdfind" pick"fdfind/fd" @sharkdp/fd \
    mv"bat* -> bat" pick"bat/bat" @sharkdp/bat \

zi wait lucid light-mode for \
    chriskempson/base16-shell \
    Aloxaf/fzf-tab \
    nocompile tinted-theming/base16-fzf \

    # z-shell/H-S-MW

zi wait lucid light-mode as"completion" for \
    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \
    https://github.com/docker/compose/tree/master/contrib/completion/zsh/_docker-compose \

source <(kubectl completion zsh)

# needs to be loaded last
zi wait lucid light-mode for \
    atinit"zicdreplay" z-shell/F-Sy-H


# zsh settings
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=500000
setopt share_history          # Share history between different instances of the shell.
setopt hist_expire_dups_first # Expire A duplicate event first when trimming history.
setopt hist_ignore_dups       # Do not record an event that was just recorded again.
setopt hist_ignore_all_dups   # Remove older duplicate entries from history.
setopt hist_ignore_space      # Do not record an Event Starting With A Space.
setopt hist_find_no_dups      # Do not display a previously found event.
setopt hist_save_no_dups      # Do not write a duplicate event to the history file.
setopt append_history         # Allow multiple sessions to append to one Zsh command history.
setopt extended_history       # Show timestamp in history.
setopt hist_reduce_blanks     # Remove superfluous blanks from history items.
setopt hist_verify            # Do not execute immediately upon history expansion.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.

setopt auto_cd              # Use cd by typing directory name if it's not a command.
setopt auto_list            # Automatically list choices on ambiguous completion.
setopt auto_pushd           # Make cd push the old directory onto the directory stack.
setopt bang_hist            # Treat the '!' character, especially during Expansion.
setopt interactive_comments # Comments even in interactive shells.
setopt multios              # Implicit tees or cats when multiple redirections are attempted.
setopt no_beep              # Don't beep on error.
setopt prompt_subst         # Substitution of parameters inside the prompt each time the prompt is drawn.
setopt pushd_ignore_dups    # Don't push multiple copies directory onto the directory stack.
setopt pushd_minus          # Swap the meaning of cd +1 and cd -1 to the opposite.

export EDITOR='nvim'
export COLORTERM="truecolor"


# fzf settings
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' show-group none

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

# completion settings
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

zstyle ':completion:*:git-checkout:*' sort false # disable sort when completing `git checkout`
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # set list-colors to enable filename colorizing

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


# golang settings
export PATH=$PATH:~/go/bin


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
bindkey '^ ' forward-word
bindkey "^K" up-line-or-history
bindkey "^J" down-line-or-history


# aliases
alias ls='ls -h --color=auto'

alias ll='ls -al'
alias ll='exa -al'

alias la='ls -a'
alias l='ls'
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
alias ip='ip -c'
alias ipa='ip -o address'

alias d='docker'
alias ap='ansible-playbook'
alias lg='lazygit'

alias syu='sudo pacman -Syu'
alias dockerkill='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'

alias light='base16_solarized-light && colorschemeswitcher 0'
alias dark='base16_tokyo-night && colorschemeswitcher 1'
alias gruv='base16_gruvbox-dark-medium && colorschemeswitcher 1'
alias gvim='gvim.exe'
alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias vim='nvim'
alias k='kubectl'
alias kc='kubectl config use-context'
alias air='~/go/bin/air'


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
    source ~/.zi/plugins/tinted-theming---base16-fzf/bash/base16-$BASE16_THEME.config;
  else
    rm -f ~/.lightmode;
    source ~/.zi/plugins/tinted-theming---base16-fzf/bash/base16-$BASE16_THEME.config;
  fi
}

darkmodechecker(){
  # Check if the AppsUseLightTheme registry key exists and its value is 1
  if /mnt/c/Windows/System32/reg.exe query 'HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' /v AppsUseLightTheme | grep -q '0x1'; then
    # If the registry key value is 1, execute "light"
    light
  else
    # If the registry key value is not 1, execute "dark"
    dark
  fi
}


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


[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# change FZF theme
# source ~/.zi/plugins/tinted-theming---base16-fzf/bash/base16-$BASE16_THEME.config;

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

