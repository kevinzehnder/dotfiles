
elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
	# ARM 64-bit specific
	zi wait lucid as"program" from"gh-r" for \
		mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
		bpick"*aarch64*" eza-community/eza \
		bpick"choose-aarch64-unknown-linux-gnu" binpicks"choose" mikefarah/choose \
		bpick"*linux_arm64*" junegunn/fzf

	zi ice as"program" id-as"neovim" \
		atclone"CMAKE_BUILD_TYPE=Release make -j4" \
		atpull"CMAKE_BUILD_TYPE=Release make -j4" \
		pick"bin/nvim"
	zi load neovim/neovim

elif [[ "$ARCH" == "armv7l" ]]; then
	# ARM 32-bit specific
	zi wait lucid as"program" from"gh-r" for \
		mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
		mv"choose* -> choose" bpick"choose-aarch64-unknown-linux-gnu" theryangeary/choose \
		bpick"eza_arm-unknown-linux-gnueabihf.tar.gz" eza-community/eza \
		bpick"*linux_armv7*" junegunn/fzf

else
	echo "Unknown architecture: $ARCH - some tools may not install correctly"
