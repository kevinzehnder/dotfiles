function sshget() {
   local server=$1
   local remote_path=$2
   [[ -z "$server" ]] && echo "need a fucking server" && return 1
   
   local rl=$(ssh -tt "$server" "fd . ${remote_path:-~} -t f --color always" 2>/dev/null | \
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
