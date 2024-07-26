# starship
eval "$(starship init zsh)"

# p10k-instant-prompt
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# zi
if [[ -r "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" ]]; then
  source "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" && zzinit
fi

zi light chriskempson/base16-shell

zi ice nocompile
zi light tinted-theming/base16-fzf

# zi light romkatv/powerlevel10k


zi wait lucid for \
  atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    z-shell/F-Sy-H \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

[ -x "$(command -v kubectl)" ] && source <(kubectl completion zsh)

zi wait lucid for \
  Aloxaf/fzf-tab

# zi light jeffreytse/zsh-vi-mode

zi wait lucid as"program" from"gh-r" for \
    ver"stable" bpick"*appimage*" mv"nvim* -> nvim" neovim/neovim \
    mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
    bpick"*linux_amd64*" junegunn/fzf \
    jesseduffield/lazygit \
    mv"dust* -> dust" pick"dust/dust" bootandy/dust \
    pick"duf" muesli/duf \
    mv"delta* -> delta" pick"delta/delta" dandavison/delta \
    eza-community/eza \
    mv"fd* -> fdfind" pick"fdfind/fd" @sharkdp/fd \
    mv"bat* -> bat" pick"bat/bat" @sharkdp/bat \
    mv"bin/dog -> dog" pick"dog" ogham/dog \
    dalance/procs \
    httpie/cli \
    mv"choose* -> choose" pick"choose" theryangeary/choose \
    denisidoro/navi \
    pick"tldr" tldr-pages/tlrc \
    zellij-org/zellij \

# additional configs
if [ -d "$HOME/.config/zsh/config.d/" ] ; then
  for conf in "$HOME/.config/zsh/config.d/"*.zsh ; do
      source "${conf}" 
  done
  unset conf
fi

zi wait pack for system-completions

# install custom completions
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


# zsh settings
export ZVM_INIT_MODE=sourcing # vi mode for zsh

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
export NVIM_APPNAME="astronvim_v4"


# fzf settings
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' show-group none

# export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
export FZF_DEFAULT_COMMAND='fd --type file --follow --exclude .git'
export FZF_PREVIEW_COMMAND='bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}'

export FZF_DEFAULT_OPTS="
--layout=reverse 
--bind='?:toggle-preview' 
--bind='ctrl-space:toggle' 
--info=inline 
--height=50% 
--multi 
--prompt='∼ ' 
--pointer='▶' 
--marker='✓' 
--bind 'ctrl-a:select-all' 
"

export FZF_ALT_C_COMMAND='fd --type directory'
export FZF_ALT_C_OPTS="
--height=75% 
--preview-window down:70% 
--preview-window border 
--preview='eza --color=always -T {}'
"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
--height 75% 
--preview-window down:70% 
--preview-window border 
--preview '($FZF_PREVIEW_COMMAND) 2> /dev/null' 
"

export FZF_COMMON_OPTIONS="
--bind='?:toggle-preview'
--bind='ctrl-space:toggle'
--bind='ctrl-u:preview-page-up'
--bind='ctrl-d:preview-page-down'
--preview-window 'right:60%:hidden:wrap'
--preview '([[ -d {} ]] && tree -C {}) || ([[ -f {} ]] && bat --style=full --color=always {}) || echo {}'"


# navi settings
export NAVI_FZF_OVERRIDES='--with-nth 3,2,1 --height 70%'


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
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin


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


## aliases
alias gh='gh.exe' # use windows based gh, because it supports credential store

alias l='eza'
alias ls="eza --color=auto --icons"
alias ll='ls -alh'
alias la='ls -a'
alias llm='ll --sort=modified' # ll, sorted by modification date
alias llz='ll -Z'

alias h='cd'
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../..'
alias back='cd $OLDPWD'

alias runlevel='sudo /sbin/init'

alias root='sudo su'

alias svim='sudo vim'
alias vim='nvim'
alias cim='vim'

alias ip='ip -c'
alias ipa='ip -o address'

alias d='docker'
alias dockerkill='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
alias ld='lazydocker'

alias ap='ansible-playbook'
alias lg='lazygit'

alias syu='sudo pacman -Syu'

alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias k='kubectl'
alias kc='kubectl config use-context'
alias air='~/go/bin/air'

alias tldrf='tldr --list | fzf --preview "tldr {1}" --preview-window=right,60% | xargs tldr'

alias https='http --default-scheme=https'
alias zj='zellij'

zjTokyo() {
    zellij $@ options --theme tokyo-night-dark
}

zjSolarized() {
    zellij $@ options --theme solarized-light
}

zjGruvbox() {
    zellij $@ options --theme gruvbox-dark
}


# use bat to colorize help output
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain -P'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain -P'
alias batp='bat -Pp'
jctl(){journalctl $@ | bat -l syslog -p --pager="less -FR +G"}


# Color Themes
alias light='colorschemeswitcher solarized'
alias dark='colorschemeswitcher dark'
alias gruv='colorschemeswitcher gruvbox'

colorschemeswitcher(){
  if [ "$1" = "solarized" ]; then
    touch ~/.lightmode;
    base16_solarized-light;
    [ -f ~/.zi/plugins/tinted-theming---base16-fzf/bash/base16-$BASE16_THEME.config ] && source ~/.zi/plugins/tinted-theming---base16-fzf/bash/base16-$BASE16_THEME.config;
    export BAT_THEME="Solarized (light)"
    alias zj='zjSolarized'
  elif [ "$1" = "gruvbox" ]; then
    rm -f ~/.lightmode;
    base16_gruvbox-dark-medium;
    [ -f ~/.zi/plugins/tinted-theming---base16-fzf/bash/base16-$BASE16_THEME.config ] && source ~/.zi/plugins/tinted-theming---base16-fzf/bash/base16-$BASE16_THEME.config;
    export BAT_THEME="gruvbox-dark"
    alias zj='zjGruvbox'
  else
    rm -f ~/.lightmode;
    [ -f ~/.config/base16/base16-tokyo-night.config ] && source ~/.config/base16/base16-tokyo-night.config;
    [ -f $HOME/.config/base16/base16-tokyo-night.sh ] && source $HOME/.config/base16/base16-tokyo-night.sh;
    export BAT_THEME="OneHalfDark"
    alias zj='zjTokyo'
  fi
}

darkmodechecker(){
  # Check if the AppsUseLightTheme registry key exists and its value is 1
  # if /mnt/c/Windows/System32/reg.exe query 'HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' /v AppsUseLightTheme | grep -q '0x1'; then
  if [ -f ~/.lightmode ]; then
    # If the registry key value is 1, execute "light"
    light
  else
    # If the registry key value is not 1, execute "dark"
    dark
  fi
}

# run DarkMode Check if we're not on an SSH connection
if [[ -z "$SSH_CONNECTION" ]]; then
  darkmodechecker
else 
  if [[ -f ~/.lightmode ]]; then
    light
  else
    dark
  fi
fi


# Configure ssh forwarding
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
# need `ps -ww` to get non-truncated command for matching
# use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
if [[ $ALREADY_RUNNING != "0" ]]; then
    if [[ -S $SSH_AUTH_SOCK ]]; then
        # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
        # echo "removing previous socket..."
        rm $SSH_AUTH_SOCK
    fi
    # echo "Starting SSH-Agent relay..."
    # setsid to force new session to keep running
    # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
    (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork,umask=077 EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi


# fzf keybindings
[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null


# direnv
zi ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
  atpull'%atclone' src"zhook.zsh"
zi light direnv/direnv

# powerlevel10k
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# load global devbox
# eval "$(devbox global shellenv --init-hook)"


