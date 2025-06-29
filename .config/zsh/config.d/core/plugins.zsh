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
		mv"dust* -> dust" pick"dust/dust" bootandy/dust \
		pick"duf" muesli/duf \
		mv"delta* -> delta" pick"delta/delta" dandavison/delta \
		go-task/task \
		pick"btop/bin/btop" aristocratos/btop \
		eza-community/eza \
		mv"fd* -> fdfind" pick"fdfind/fd" atclone"sudo cp fdfind/fd /usr/bin/fd" @sharkdp/fd \
		mv"bat* -> bat" pick"bat/bat" @sharkdp/bat \
		denisidoro/navi \
		pick"xh-*/xh" ducaale/xh \
		jesseduffield/lazygit \
		bensadeh/tailspin \
		pick"bin/cb" Slackadays/Clipboard \
		zellij-org/zellij \
		mv"choose* -> choose" pick"choose" theryangeary/choose \
		mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
		mv"bin/dog -> dog" pick"dog" ogham/dog \
		pick"tldr" tldr-pages/tlrc \
		bpick"*linux_amd64*" junegunn/fzf \
		pick"bws" ver"bws-v1.0.0" bitwarden/sdk-sm \
		bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin" atuinsh/atuin

	# Neovim
	if command -v fuse-overlayfs > /dev/null 2>&1 || test -e /dev/fuse; then
		zinit wait lucid as"program" from"gh-r" for \
			ver"v0.10.3" bpick"*appimage*" mv"nvim* -> nvim" neovim/neovim
	else
		zinit ice from"gh-r" ver"nightly" bpick"nvim-linux-x86_64.tar.gz" \
			pick"nvim-linux-x86_64/bin/nvim" \
			nocompile \
			as"program" \
			atclone"chmod +x nvim-linux-x86_64/bin/nvim; sudo cp -vf nvim-linux-x86_64/bin/nvim /usr/local/bin/; sudo mkdir -p /usr/local/share; sudo cp -r nvim-linux-x86_64/share/nvim /usr/local/share/" \
			atpull"%atclone"
		zinit load neovim/neovim
	fi

fi

# needs to be loaded last
zinit for \
	atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
	blockf \
	zsh-users/zsh-autosuggestions
