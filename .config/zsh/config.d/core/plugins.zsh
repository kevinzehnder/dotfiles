#
# ZSH plugin management with zi
#

# Base plugins that need to be loaded first
zinit for \
	chriskempson/base16-shell \
	nocompile tinted-theming/tinted-fzf

zinit wait lucid for \
	Aloxaf/fzf-tab \
	zdharma-continuum/fast-syntax-highlighting \
	zsh-users/zsh-completions

# Architecture-specific tools
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
	zinit wait lucid as"program" from"gh-r" for \
		go-task/task \
		pick"bin/cb" Slackadays/Clipboard \
		bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin" atuinsh/atuin

fi

# needs to be loaded last
zinit for \
	atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
	blockf \
	zsh-users/zsh-autosuggestions

# available in pacman/aur
# bpick"*linux_amd64*" junegunn/fzf \
# mv"dust* -> dust" pick"dust/dust" bootandy/dust \
# pick"duf" muesli/duf \
# pick"btop/bin/btop" aristocratos/btop \
# eza-community/eza \
# mv"bat* -> bat" pick"bat/bat" @sharkdp/bat \
# jesseduffield/lazygit \
# pick"xh-*/xh" ducaale/xh \
# mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
# mv"choose* -> choose" pick"choose" theryangeary/choose \
# mv"bin/dog -> dog" pick"dog" ogham/dog \
# bensadeh/tailspin \
# mv"fd* -> fdfind" pick"fdfind/fd" atclone"sudo cp fdfind/fd /usr/bin/fd" @sharkdp/fd \
# mv"delta* -> delta" pick"delta/delta" dandavison/delta \
# zellij-org/zellij \
# pick"tldr" tldr-pages/tlrc \
# denisidoro/navi \
