function repeater() {
	if [ "$#" -lt 2 ]; then
		echo "Usage: repeater <seconds> <command>"
		return 1
	fi

	local interval=$1
	shift
	local command="$@"

	while true; do
		echo "--- $(date +"%H:%M:%S") ---"
		eval "$command"
		sleep $interval
	done
}

# Helper function for sudo without password
function check_sudo_nopass() {
	sudo -n true 2> /dev/null
	return $?
}

function needs_reboot() {
	if [[ -f /var/run/reboot-required ]] \
		|| { command -v needs-restarting &> /dev/null && needs-restarting -r 2> /dev/null | rg -q "Reboot is required"; }; then
		return 0
	fi
	return 1
}

function parse_ssh_config() {
	local config_dir="$HOME/.ssh/config.d"
	local main_config="$HOME/.ssh/config"
	local temp_file=$(mktemp)

	# Start with main config
	[[ -f "$main_config" ]] && cat "$main_config" > "$temp_file"

	# Add config.d files if they exist
	if [[ -d "$config_dir" ]]; then
		for conf_file in "$config_dir"/*; do
			[[ -f "$conf_file" ]] && cat "$conf_file" >> "$temp_file"
		done
	fi

	# Extract Host entries, ignore wildcards and patterns with *, ?, !
	grep -i "^Host " "$temp_file" \
		| grep -v "[*?!]" \
		| sed 's/^Host //' \
		| tr ' ' '\n' \
		| tr -d '\r' \
		|
		# Remove any CR characters
		sort -u \
		| while read -r host; do
			# Clean any remaining whitespace
			host=$(echo "$host" | xargs)
			[[ -z "$host" ]] && continue

			# For each host, use ssh -G to get the full expanded config
			local details=$(ssh -G "$host" 2> /dev/null)
			if [[ $? -eq 0 ]]; then
				echo "$host"
			fi
		done

	rm "$temp_file"
}

# Helper function to detect package manager
function get_package_manager() {
	if command -v apt &> /dev/null; then
		echo "apt"
	elif command -v pacman &> /dev/null; then
		echo "pacman"
	elif command -v dnf &> /dev/null; then
		echo "dnf"
	else
		echo "unknown"
	fi
}

# load global devbox
function devbox_global() {
	eval "$(devbox global shellenv --init-hook --omit-nix-env=false)"
}

# zellij
function za() {
	if command -v zellij &> /dev/null; then
		# Check if zellij is already running to avoid nested sessions
		if [ -z "$ZELLIJ" ]; then
			# Start a new Zellij session or attach to an existing one
			zellij attach --create mysession
		fi
	fi
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function install_yazi() {
	zi wait lucid light-mode as"program" from"gh-r" for \
		pick"ya*/yazi" sxyazi/yazi
fi
	
}
