function containers() {
	# Check sudo
	check_sudo_nopass || sudo -v

	# Command options
	local cmd="sudo nerdctl ps"
	[[ "$1" == "-a" ]] && cmd="sudo nerdctl ps -a"

	# Set up log commands based on tspin availability
	if command -v tspin > /dev/null 2>&1; then
		local logs="ID=\$(echo {} | awk '{print \$1}'); sudo nerdctl logs --tail 2000 \$ID | tspin | less -r +G"
		local follow_logs="ID=\$(echo {} | awk '{print \$1}'); sudo nerdctl logs -f \$ID | tspin"
	else
		local logs="ID=\$(echo {} | awk '{print \$1}'); sudo nerdctl logs --tail 2000 \$ID | less -r +G"
		local follow_logs="ID=\$(echo {} | awk '{print \$1}'); sudo nerdctl logs -f \$ID"
	fi

	# Get the header and containers
	local header=$(eval "$cmd" | head -1)
	local containers=$(eval "$cmd" | tail -n +2)

	if [[ -z "$containers" ]]; then
		echo "No containers found"
		return
	fi

	# Run fzf with header line and preview at bottom
	echo "$header"
	echo "$containers" | fzf \
		--preview="ID=\$(echo {} | awk '{print \$1}'); echo -e '\033[1;32mContainer Info:\033[0m'; sudo nerdctl inspect \$ID | head -30; echo -e '\n\033[1;33mRecent Logs:\033[0m'; sudo nerdctl logs --tail 10 \$ID" \
		--preview-window=down:60%:wrap \
		--header $'Container Management | CTRL-R: reload\nCTRL-L: logs | CTRL-F: follow logs | CTRL-E: exec\nCTRL-S: start | CTRL-D: stop | CTRL-X: rm' \
		--bind "ctrl-l:execute($logs)" \
		--bind "ctrl-f:execute($follow_logs)" \
		--bind "ctrl-e:execute(ID=\$(echo {} | awk '{print \$1}'); sudo nerdctl exec -it \$ID sh)" \
		--bind "ctrl-s:execute(ID=\$(echo {} | awk '{print \$1}'); sudo nerdctl start \$ID)" \
		--bind "ctrl-p:execute(ID=\$(echo {} | awk '{print \$1}'); sudo nerdctl stop \$ID)" \
		--bind "ctrl-r:reload(eval \"$cmd\" | tail -n +2)" \
		--bind "ctrl-x:execute(ID=\$(echo {} | awk '{print \$1}'); sudo nerdctl rm \$ID)"
}

function images() {
	check_sudo_nopass || sudo -v

	local header=$(sudo nerdctl images | head -1)
	local image_list=$(sudo nerdctl images | tail -n +2)

	if [[ -z "$image_list" ]]; then
		echo "No images found"
		return
	fi

	# Pull new image command
	local pull_new='bash -c "read -p \"New image to pull: \" img; sudo nerdctl pull \$img; echo \"Press any key to continue\"; read"'

	echo "$header"
	echo "$image_list" | fzf \
		--preview="ID=\$(echo {} | awk '{print \$3}'); sudo nerdctl image inspect \$ID" \
		--preview-window=down:60%:wrap \
		--header $'Image Management | CTRL-R: reload\nCTRL-X: rm | CTRL-U: update image | CTRL-P: pull new' \
		--bind "ctrl-r:reload(sudo nerdctl images | tail -n +2)" \
		--bind "ctrl-x:execute(ID=\$(echo {} | awk '{print \$3}'); sudo nerdctl rmi \$ID; echo 'Press any key to continue'; read; echo 'Reloading...'; sleep 1)+reload(sudo nerdctl images | tail -n +2)" \
		--bind "ctrl-u:execute(REPO=\$(echo {} | awk '{print \$1}'); TAG=\$(echo {} | awk '{print \$2}'); sudo nerdctl pull \$REPO:\$TAG; read)+reload(sudo nerdctl images | tail -n +2)" \
		--bind "ctrl-p:execute($pull_new)+reload(sudo nerdctl images | tail -n +2)"
}
