# ARM 64-bit specific tools
if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
	zi wait lucid as"program" from"gh-r" for \
		bpick"*aarch64*" mv"dust* -> dust" pick"dust/dust" bootandy/dust \
		bpick"*aarch64*" pick"duf" muesli/duf \
		bpick"*aarch64*" mv"delta* -> delta" pick"delta/delta" dandavison/delta \
		bpick"*aarch64*" eza-community/eza \
		bpick"*aarch64*" mv"fd* -> fdfind" pick"fdfind/fd" atclone"sudo cp fdfind/fd /usr/bin/fd" @sharkdp/fd \
		bpick"*aarch64*" mv"bat* -> bat" pick"bat/bat" @sharkdp/bat \
		bpick"*aarch64*" atclone"sudo install procs /usr/bin/procs" dalance/procs \
		bpick"*aarch64*" denisidoro/navi \
		bpick"*aarch64*" pick"xh-*/xh" ducaale/xh \
		bpick"*aarch64*" jesseduffield/lazygit \
		bpick"*aarch64*" bensadeh/tailspin \
		bpick"choose-aarch64-unknown-linux-gnu" binpicks"choose" mikefarah/choose \
		bpick"*aarch64*" mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
		bpick"*linux_arm64*" junegunn/fzf

# ARM 32-bit specific tools
elif [[ "$ARCH" == "armv7l" ]]; then
	zi wait lucid as"program" from"gh-r" for \
		bpick"*armv7*" mv"dust* -> dust" pick"dust/dust" bootandy/dust \
		bpick"*armv7*" pick"duf" muesli/duf \
		bpick"*armv7*" mv"delta* -> delta" pick"delta/delta" dandavison/delta \
		bpick"eza_arm-unknown-linux-gnueabihf.tar.gz" eza-community/eza \
		bpick"*armv7*" mv"fd* -> fdfind" pick"fdfind/fd" atclone"sudo cp fdfind/fd /usr/bin/fd" @sharkdp/fd \
		bpick"*armv7*" mv"bat* -> bat" pick"bat/bat" @sharkdp/bat \
		bpick"*armv7*" atclone"sudo install procs /usr/bin/procs" dalance/procs \
		bpick"*armv7*" denisidoro/navi \
		bpick"*armv7*" pick"xh-*/xh" ducaale/xh \
		bpick"*armv7*" jesseduffield/lazygit \
		mv"choose* -> choose" bpick"choose-aarch64-unknown-linux-gnu" theryangeary/choose \
		bpick"*armv7*" bensadeh/tailspin \
		bpick"*armv7*" mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
		bpick"*linux_armv7*" junegunn/fzf

	# Choose needs to be built from source on 32-bit ARM
	zi ice lucid wait as"program" \
		atclone"cargo build --release && cp target/release/choose $ZPFX/bin/" \
		atpull"%atclone"
	zi load theryangeary/choose

fi
