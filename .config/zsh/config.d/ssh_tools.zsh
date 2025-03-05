
function sshget() {
    local server=$1
    local remote_path=$2
    [[ -z "$server" ]] && echo "need a fucking server" && return 1
    
    # Check if fd exists on remote, otherwise use find
    local file_cmd="fd . ${remote_path:-~} -t f --color always"
    if ! ssh "$server" "command -v fd > /dev/null"; then
        file_cmd="find ${remote_path:-~} -type f | sort"
        echo "fd not found on $server, falling back to find. Install fd for better performance."
    fi
    
    local rl=$(ssh -tt "$server" "$file_cmd" 2>/dev/null | \
        fzf --multi \
            --ansi \
            --height=80% \
            --preview="ssh $server 'cat {}' 2>/dev/null" \
            --preview-window=hidden:right:50%)
    
    if [[ -n "$rl" ]]; then
        mkdir -p sshget
        echo "$rl" > /tmp/rsync_files_$$
        local rsync_cmd="rsync -avz --progress --files-from=/tmp/rsync_files_$$ $server:/ ./sshget/"
        echo "Running: $rsync_cmd"
        eval $rsync_cmd
        rm /tmp/rsync_files_$$
    fi
}


function fix_ssh_permissions() {
   # Fix parent dirs
   chmod 700 ~/.ssh 2>/dev/null
   find ~/.ssh -type d -exec chmod 700 {} \; 2>/dev/null
   
   # Config files including config.d shit
   find ~/.ssh -type f -name "config*" -exec chmod 600 {} \; 2>/dev/null
   find ~/.ssh/config.d -type f -exec chmod 600 {} \; 2>/dev/null
   
   # Keys
   find ~/.ssh -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \; 2>/dev/null
   find ~/.ssh -type f -name "identity" -exec chmod 600 {} \; 2>/dev/null
   
   # Public shit
   find ~/.ssh -type f -name "*.pub" -exec chmod 644 {} \; 2>/dev/null
   find ~/.ssh -type f -name "known_hosts*" -exec chmod 644 {} \; 2>/dev/null
   find ~/.ssh -type f -name "authorized_keys" -exec chmod 600 {} \; 2>/dev/null
   
   echo "SSH permissions fixed."
}
