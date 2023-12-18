function procs_ports() {
    procs --color always --load-config ~/.config/procs/procs_ports.toml "$@" | fzf --ansi
}

function procs_resources() {
    procs --color always --load-config ~/.config/procs/procs_resources.toml "$@" | fzf --ansi
}
