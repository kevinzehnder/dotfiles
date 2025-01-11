function procsp() {
	check_sudo_nopass || sudo -v
    sudo procs --color always --load-config ~/.config/procs/procs_ports.toml "$@" | fzf --ansi
}

function procsl() {
	check_sudo_nopass || sudo -v
    sudo procs --use-config=large
}

function psk() {
check_sudo_nopass || sudo -v
   sudo procs | fzf --ansi \
       --preview "sudo procs --no-header --pager=disable --tree {1}" \
       --preview-window=down \
       --bind='ctrl-r:reload(sudo procs)' \
       --header='[CTRL-R] reload [ENTER] kill' \
       --height=100% \
       --layout=reverse \
       | awk '{print $1}' | xargs -r sudo kill -9
}

function ports() {
	check_sudo_nopass || sudo -v
    if ! ss_out=$(sudo ss -Htupln | rg "LISTEN|ESTABLISHED"); then
        echo "no active ports found"
        return 1
    fi
    
    echo "$ss_out" | \
        tr ',' '\n' | \
        rg "pid=([0-9]+)" -o -r '$1' | \
        xargs -I {} echo -n "{} " | \
        xargs echo "--or" | \
        xargs sudo procs --no-header | \
        fzf --ansi \
            --preview "sudo ss -tupln | rg {1}" \
            --preview-window=down \
            --height=100% \
            --layout=reverse \
            --header='Active Ports [LISTEN/ESTABLISHED]'
}

function hogs() {
   check_sudo_nopass || sudo -v
   sudo procs --sortd cpu --no-header | head -n 10 | fzf --ansi \
       --preview "sudo procs --tree {1}" \
       --preview-window=down \
       --height=100% \
       --layout=reverse \
       --header='Top CPU Hoggers [ENTER to kill]' \
       --bind='ctrl-r:reload(sudo procs --sortd cpu --no-header | head -n 10)' \
       | awk '{print $1}' | xargs -r sudo kill -9
}

function memhogs() {
	check_sudo_nopass || sudo -v
    sudo procs --sortd mem --no-header | head -n 15 | fzf --ansi \
        --preview "sudo procs --tree {1} && echo '\n---Memory Maps---\n' && sudo pmap -x {1} | head -n 20" \
        --preview-window=down,wrap \
        --height=100% \
        --layout=reverse \
        --header='Memory Hogs [ENTER to kill] | Preview shows process tree and memory maps' \
        --bind='ctrl-r:reload(sudo procs --sortd mem --no-header | head -n 15)' \
        | awk '{print $1}' | xargs -r sudo kill -9
}

