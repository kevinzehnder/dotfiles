# ARM 64-bit specific tools
if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
	zi wait lucid as"program" from"gh-r" for \
		bpick"*aarch64*" mv"dust* -> dust" pick"dust/dust" bootandy/dust \
		pick"duf" muesli/duf \
		bpick"*aarch64*" mv"delta* -> delta" pick"delta/delta" dandavison/delta \
		bpick"*aarch64*" eza-community/eza \
		bpick"*aarch64*" mv"fd* -> fdfind" pick"fdfind/fd" atclone"sudo cp fdfind/fd /usr/bin/fd" @sharkdp/fd \
		bpick"*aarch64*" mv"bat* -> bat" pick"bat/bat" @sharkdp/bat \
		bpick"*aarch64*" atclone"sudo install procs /usr/bin/procs" dalance/procs \
		bpick"*aarch64*" denisidoro/navi \
		bpick"*aarch64*" pick"xh-*/xh" ducaale/xh \
		jesseduffield/lazygit \
		bpick"*aarch64*" bensadeh/tailspin \
		mv"choose* -> choose" bpick"choose-aarch64-unknown-linux-gnu" theryangeary/choose \
		bpick"*aarch64*" mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
		bpick"*linux_arm64*" junegunn/fzf

# ARM 32-bit specific tools
elif [[ "$ARCH" == "armv7l" ]]; then
	zi wait lucid as"program" from"gh-r" for \
		bpick"fd-v*-arm-unknown-linux-gnueabihf.tar.gz" mv"fd* -> fdfind" pick"fdfind/fd" atclone"sudo cp fdfind/fd /usr/bin/fd" @sharkdp/fd \
		bpick"*-arm-unknown-linux-gnueabihf.tar.gz" mv"bat* -> bat" as"null" cp"bat/bat -> $ZPFX/bin/bat" @sharkdp/bat \
		bpick"*arm-unknown-linux-gnueabihf.tar.gz" mv"dust* -> dust" as"null" cp"dust/dust -> $ZPFX/bin/dust" bootandy/dust \
		bpick"eza_arm-unknown-linux-gnueabihf.tar.gz" eza-community/eza \
		bpick"*armv7-unknown-linux-musleabihf*" denisidoro/navi \
		bpick"*Linux_armv6*" jesseduffield/lazygit \
		bpick"*armv7-unknown-linux-musleabi*" mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
		bpick"*linux_armv7*" junegunn/fzf \
		pick"btop/bin/btop" bpick"*armv7*" aristocratos/btop

	unalias vim
fi
