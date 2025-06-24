# Configure ssh forwarding
setup_ssh_agent() {
	export SSH_AUTH_SOCK=$HOME/.agent.sock

	# Check if socat is already running properly
	if ps -auxww | grep -q "[s]ocat.*$SSH_AUTH_SOCK" && [[ -S $SSH_AUTH_SOCK ]]; then
		# Already running, do nothing
		return 0
	fi

	# Kill any zombie processes
	pkill -f "socat UNIX-LISTEN:$SSH_AUTH_SOCK"

	# Clean up socket
	[[ -S $SSH_AUTH_SOCK ]] && rm $SSH_AUTH_SOCK

	# Start new socat process
	(
		setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork,umask=077 EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &
	) > /dev/null 2>&1

	# Verify it's running
	if ! ps -auxww | grep -q "[s]ocat.*$SSH_AUTH_SOCK"; then
		# echo "SSH agent setup failed. Retrying..."
		if [[ ${setup_ssh_agent_retry_count:-0} -lt 2 ]]; then
			export setup_ssh_agent_retry_count=$((${setup_ssh_agent_retry_count:-0} + 1))
			setup_ssh_agent
		else
			echo "SSH agent setup failed after multiple attempts."
			export setup_ssh_agent_retry_count=0
		fi
	else
		export setup_ssh_agent_retry_count=0
	fi
}

if command -v wsl2-ssh-agent &> /dev/null; then
    eval "$(wsl2-ssh-agent)"
fi
