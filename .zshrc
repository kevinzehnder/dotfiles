# detect architecture
ARCH=$(uname -m)

# starship
eval "$(starship init zsh)"

# zi
if [[ -r "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" ]]; then
	source "${XDG_CONFIG_HOME:-${HOME}/.config}/zi/init.zsh" && zzinit
fi

zi light chriskempson/base16-shell
zi ice nocompile
zi light tinted-theming/tinted-fzf

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

# x86_64 specific tools
if [[ "$ARCH" == "x86_64" ]]; then
	zi wait lucid as"program" from"gh-r" for \
		mv"dust* -> dust" pick"dust/dust" bootandy/dust \
		pick"duf" muesli/duf \
		mv"delta* -> delta" pick"delta/delta" dandavison/delta \
		go-task/task \
		pick"btop/bin/btop" aristocratos/btop \
		eza-community/eza \
		mv"fd* -> fdfind" pick"fdfind/fd" atclone"sudo cp fdfind/fd /usr/bin/fd" @sharkdp/fd \
		mv"bat* -> bat" pick"bat/bat" @sharkdp/bat \
		atclone"sudo install procs /usr/bin/procs && sudo install ~/.config/procs/procs.toml /etc/procs/procs.toml" dalance/procs \
		denisidoro/navi \
		pick"xh-*/xh" ducaale/xh \
		jesseduffield/lazygit \
		bensadeh/tailspin

	zi wait lucid as"program" from"gh-r" for \
		mv"choose* -> choose" pick"choose" theryangeary/choose \
		mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
		mv"bin/dog -> dog" pick"dog" ogham/dog \
		pick"tldr" tldr-pages/tlrc \
		bpick"*linux_amd64*" junegunn/fzf

	# neovim
	if command -v fuse-overlayfs > /dev/null 2>&1 || test -e /dev/fuse; then
		zi wait lucid as"program" from"gh-r" for \
			ver"v0.10.3" bpick"*appimage*" mv"nvim* -> nvim" neovim/neovim
	else
		zi ice from"gh-r" ver"nightly" bpick"nvim-linux-x86_64.tar.gz" \
			pick"nvim-linux-x86_64/bin/nvim" \
			atclone"chmod +x nvim-linux-x86_64/bin/nvim; sudo cp -vf nvim-linux-x86_64/bin/nvim /usr/local/bin/; sudo mkdir -p /usr/local/share; sudo cp -r nvim-linux-x86_64/share/nvim /usr/local/share/" \
			atpull"%atclone"
		zi load neovim/neovim
	fi
fi

# system completions
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
export VISUAL='nvim'
export COLORTERM="truecolor"
export NVIM_APPNAME="nvim"

# fzf settings
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' show-group none
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

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
--height 80% 
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
alias navic='navi --cheatsh'
alias navit='navi --tldr'

# completion settings
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

zstyle ':completion:*:git-checkout:*' sort false # disable sort when completing `git checkout`
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

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
alias neovide='nohup neovide.exe --wsl --neovim-bin $(which nvim) >/dev/null 2>&1 &'

alias ip='ip -c'
alias ipa='ip -o address'

alias d='docker'
alias n='sudo nerdctl'
alias nc='sudo nerdctl compose'
alias dockerkill='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
alias ld='lazydocker'

alias ap='ansible-playbook'
alias lg='lazygit'
alias tf='terraform'
alias tm='tmux attach -t default || tmux new -s default'
alias zshrc='vim ~/.zshrc'
alias sshconf='vim ~/.ssh/config'

alias tldrf="tldr --list | fzf --ansi --preview 'script -qec \"tldr {1}\" /dev/null' --height=80% --preview-window=right,60% | xargs tldr"

alias syu='sudo pacman -Syu'

alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias k='kubectl'
alias kc='kubectl config use-context'
alias kar='kubectl-argo-rollouts'

alias zj='zellij'

# use bat to colorize help output
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain -P'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain -P'
alias batp='bat -Pp'

# fzf keybindings
[ -f "$HOME/.config/fzf/key-bindings.zsh" ] && source "$HOME/.config/fzf/key-bindings.zsh"
[[ $- == *i* ]] && source "$HOME/.config/fzf/completion.zsh" 2> /dev/null

# direnv
zi ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
	atpull'%atclone' src"zhook.zsh"
zi light direnv/direnv

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# auto attach to tmux on local shells
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ]; then
	tmux attach -t default || tmux new -s default
fi

# load additional configs
if [ -d "$HOME/.config/zsh/config.d/" ]; then
	for conf in "$HOME/.config/zsh/config.d/"*.zsh; do
		source "${conf}"
	done
	unset conf
fi
