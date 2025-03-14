# procs that also shows open ports
function portz() {
	check_sudo_nopass || sudo -v
    if ! ss_out=$(sudo ss -tulpn4 | rg "LISTEN|ESTABLISHED"); then
        echo "no active ports found"
        return 1
    fi
    
    echo "$ss_out" | fzf --ansi
}
function procsp() {
	check_sudo_nopass || sudo -v
    sudo procs --color always --load-config ~/.config/procs/procs_ports.toml "$@" | fzf --ansi
}

# procs large view
function procsl() {
	check_sudo_nopass || sudo -v
    sudo procs --use-config=large
}

# open ports
function ports() {
	check_sudo_nopass || sudo -v
    if ! ss_out=$(sudo ss -Htupln | rg "LISTEN|ESTABLISHED"); then
        echo "no active ports found"
        return 1
    fi
    
    echo "$ss_out" | \
        tr ',' '\n' | \
        rg "pid=([0-9]+)" | \
		choose 1 -f "=" | \
        xargs sudo procs --or {} --color always --sorta TcpPort | \
        fzf --ansi \
            --preview "sudo ss -tulpn | rg {1}" \
            --preview-window=down \
            --height=100% \
            --layout=reverse \
            --header='Active Ports [LISTEN/ESTABLISHED]'
}

# open ports using ps
function portz() {
	check_sudo_nopass || sudo -v
    if ! ss_out=$(sudo ss -tulpn4 | rg "LISTEN|ESTABLISHED"); then
        echo "no active ports found"
        return 1
    fi
    
    echo "$ss_out" | fzf --ansi
}

# interactive kill thru procs and FZF
function psk() {
check_sudo_nopass || sudo -v
   sudo procs --color always | fzf --ansi \
       --preview "sudo procs --no-header --pager=disable --tree {1}" \
       --preview-window=down \
       --bind='ctrl-r:reload(sudo procs)' \
       --header='[CTRL-R] reload [ENTER] kill' \
       --height=100% \
       --layout=reverse \
       | awk '{print $1}' | xargs -r sudo kill -9
}

# find cpu hogs
function cpuhogs() {
   check_sudo_nopass || sudo -v
   sudo procs --color always --sortd cpu --no-header | head -n 10 | fzf --ansi \
       --preview "sudo procs --tree {1}" \
       --preview-window=down \
       --height=100% \
       --layout=reverse \
       --header='Top CPU Hoggers [ENTER to kill]' \
       --bind='ctrl-r:reload(sudo procs --sortd cpu --no-header | head -n 10)' \
       | awk '{print $1}' | xargs -r sudo kill -9
}

# find memory hogs
function memhogs() {
	check_sudo_nopass || sudo -v
    sudo procs --color always --sortd mem --no-header | head -n 15 | fzf --ansi \
        --preview "sudo procs --tree {1} && echo '\n---Memory Maps---\n' && sudo pmap -x {1} | head -n 20" \
        --preview-window=down,wrap \
        --height=100% \
        --layout=reverse \
        --header='Memory Hogs [ENTER to kill] | Preview shows process tree and memory maps' \
        --bind='ctrl-r:reload(sudo procs --sortd mem --no-header | head -n 15)' \
        | awk '{print $1}' | xargs -r sudo kill -9
}

