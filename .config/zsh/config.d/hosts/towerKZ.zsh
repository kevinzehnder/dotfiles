# Plugins
# zi wait lucid light-mode as"program" from"gh-r" for \
# 	mv"gojq* ->gojq" pick"gojq/gojq" itchyny/gojq \
# 	jesseduffield/lazydocker

# Neovim
# if command -v fuse-overlayfs > /dev/null 2>&1 || test -e /dev/fuse; then
# 	zinit wait lucid as"program" from"gh-r" for \
# 		ver"v0.10.3" bpick"*appimage*" mv"nvim* -> nvim" neovim/neovim
# else
# 	zinit ice from"gh-r" ver"nightly" bpick"nvim-linux-x86_64.tar.gz" \
# 		pick"nvim-linux-x86_64/bin/nvim" \
# 		nocompile \
# 		as"program" \
# 		atclone"chmod +x nvim-linux-x86_64/bin/nvim; sudo cp -vf nvim-linux-x86_64/bin/nvim /usr/local/bin/; sudo mkdir -p /usr/local/share; sudo cp -r nvim-linux-x86_64/share/nvim /usr/local/share/" \
# 		atpull"%atclone"
# 	zinit load neovim/neovim
# fi


# installable with pacman
	# twpayne/chezmoi \
	# derailed/k9s \
	# zellij-org/zellij \
	# pick"bin/linux_amd64/kubelogin" Azure/kubelogin \
	# ver"kustomize/v5.3.0" kubernetes-sigs/kustomize \
	# pick"ya*/yazi" sxyazi/yazi \
	# pick"bws" ver"bws-v1.0.0" bitwarden/sdk-sm \
	# pick"sd*/sd" chmln/sd \
	# pick"jnv*/jnv" ynqa/jnv
