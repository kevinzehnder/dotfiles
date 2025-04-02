#
# ZSH plugin management with zi
#

# Base plugins
zi light chriskempson/base16-shell
zi ice nocompile
zi light tinted-theming/tinted-fzf

# Load syntax highlighting, completions, and autosuggestions with better performance
zi wait lucid for \
    atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    z-shell/F-Sy-H \
    blockf \
    zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    Aloxaf/fzf-tab

# Architecture-specific tools
ARCH=$(uname -m)
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

    # Neovim
    if command -v fuse-overlayfs > /dev/null 2>&1 || test -e /dev/fuse; then
        zi wait lucid as"program" from"gh-r" for \
            ver"v0.10.3" bpick"*appimage*" mv"nvim* -> nvim" neovim/neovim
    else
        zi ice from"gh-r" ver"nightly" bpick"nvim-linux-x86_64.tar.gz" \
            pick"nvim-linux-x86_64/bin/nvim" \
            nocompile \
            as"program" \
            atclone"chmod +x nvim-linux-x86_64/bin/nvim; sudo cp -vf nvim-linux-x86_64/bin/nvim /usr/local/bin/; sudo mkdir -p /usr/local/share; sudo cp -r nvim-linux-x86_64/share/nvim /usr/local/share/" \
            atpull"%atclone"
        zi load neovim/neovim
    fi
fi

# direnv
zi ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
    atpull'%atclone' src"zhook.zsh"
zi light direnv/direnv