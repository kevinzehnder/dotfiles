function procsp() {
	sudo -v
    sudo procs --color always --load-config ~/.config/procs/procs_ports.toml "$@" | fzf --ansi
}

function procsl() {                                                                                                                                                                  ☸  fw-awf-prd-euw-003-aks
        sudo -v
        sudo procs --use-config=large
}

function psk() {
   sudo -v
   sudo procs | fzf --ansi \
       --preview "sudo procs --pager=disable --tree {1}" \
       --preview-window=down \
       --bind='ctrl-r:reload(sudo procs)' \
       --header='[CTRL-R] reload [ENTER] kill' \
       --height=100% \
       --layout=reverse \
       | awk '{print $1}' | xargs -r sudo kill -9
}
