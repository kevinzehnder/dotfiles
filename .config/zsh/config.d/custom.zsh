if [[ $(hostname) == "towerKZ" ]]; then
    zi wait lucid light-mode as"program" from"gh-r" for \
        mv"gojq* ->gojq" pick"gojq/gojq" itchyny/gojq \
        go-task/task \
        derailed/k9s \
        jesseduffield/lazydocker \
        zellij-org/zellij \
        twpayne/chezmoi \
        pick"btop/bin/btop" aristocratos/btop \
        pick"bin/linux_amd64/kubelogin" Azure/kubelogin \
        ver"kustomize/v5.3.0" kubernetes-sigs/kustomize \
        pick"ya*/yazi" sxyazi/yazi \
        pick"sd*/sd" chmln/sd \
        pick"jnv*/jnv" ynqa/jnv
fi
