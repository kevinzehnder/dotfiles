function s() {
	# Extract Host entries from SSH config
	local hosts=$(parse_ssh_config | cut -d'|' -f1)

	if [[ -z "$hosts" ]]; then
		echo "❌ No SSH hosts found. Check your ~/.ssh/config or ~/.ssh/config.d/*"
		return 1
	fi

	# Select a host with FZF
	local selected_host=$(echo "$hosts" \
		| fzf --reverse \
			--header="SSH Connections" \
			--preview-window=right:60%:wrap \
			--preview="source ~/.config/zsh/config.d/ssh_connection_preview.zsh && ssh_connection_preview {}" \
			--height=80%)

	# If nothing selected, just exit
	[[ -z "$selected_host" ]] && return

	# Connect to the selected host
	ssh "$selected_host"
}

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

	local rl=$(ssh -tt "$server" "$file_cmd" 2> /dev/null \
		| fzf --multi \
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

function show_ssh_keys() {
	echo "🔑 Displaying your public SSH keys..."

	# Find all public keys and process each one individually
	local keys=($(find ~/.ssh -type f -name "*.pub" 2> /dev/null))

	if [[ ${#keys[@]} -eq 0 ]]; then
		echo "❌ No public keys found. Generate one with ssh-keygen first."
		return 1
	fi

	# Show each key with header
	local count=0
	echo ""
	echo "=== KEYS FOUND ==="

	for key in "${keys[@]}"; do
		# Make sure the file exists (check again to be safe)
		if [[ ! -f "$key" ]]; then
			continue
		fi

		local keyname=$(basename "$key")
		local keytype=$(head -n 1 "$key" | awk '{print $1}')
		local fingerprint=$(ssh-keygen -lf "$key" 2> /dev/null | awk '{print $2}')

		# Only show if we can actually read it
		if [[ -n "$keytype" ]]; then
			echo ""
			echo -e "\e[1;36m$keyname\e[0m [$keytype] - $fingerprint"
			echo "-----------------------------------------"
			cat "$key"
			echo ""
			((count++))
		fi
	done

	echo "=== $count keys found ==="
	echo ""
	echo "✅ Copy the key you want and paste it into remote:~/.ssh/authorized_keys"
}

function fix_ssh_permissions() {
	echo "🔒 Starting SSH permissions fix"

	# Fix parent dirs
	echo "Setting .ssh dir to 700..."
	chmod 700 ~/.ssh 2> /dev/null
	echo "Setting all subdirs to 700..."
	find ~/.ssh -type d -exec chmod 700 {} \; 2> /dev/null

	# Config files including config.d shit
	echo "Setting config files to 600..."
	find ~/.ssh -type f -name "config*" -exec chmod 600 {} \; 2> /dev/null
	find ~/.ssh/config.d -type f -exec chmod 600 {} \; 2> /dev/null

	# Keys
	echo "Setting private keys to 600..."
	find ~/.ssh -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \; 2> /dev/null
	find ~/.ssh -type f -name "identity" -exec chmod 600 {} \; 2> /dev/null

	# Public shit
	echo "Setting public keys to 644..."
	find ~/.ssh -type f -name "*.pub" -exec chmod 644 {} \; 2> /dev/null
	echo "Setting known_hosts to 644..."
	find ~/.ssh -type f -name "known_hosts*" -exec chmod 644 {} \; 2> /dev/null
	echo "Setting authorized_keys to 600..."
	find ~/.ssh -type f -name "authorized_keys" -exec chmod 600 {} \; 2> /dev/null

	echo "✅ SSH permissions fixed."
}
