function ssh_connection_preview() {
    local host=$1
    
    # Strip any weird shit from the host (CR, whitespace)
    host=$(echo "$host" | tr -d '\r' | xargs)
    
    # Get expanded config for host
    local details=$(ssh -G "$host" 2>/dev/null)
    
    if [[ $? -ne 0 ]]; then
        echo -e "\033[1;31m❌ Invalid SSH host\033[0m"
        return 1
    fi
    
    local user=$(echo "$details" | grep "^user " | head -1 | awk '{print $2}')
    local hostname=$(echo "$details" | grep "^hostname " | head -1 | awk '{print $2}')
    local port=$(echo "$details" | grep "^port " | head -1 | awk '{print $2}')
    local identityfile=$(echo "$details" | grep "^identityfile " | head -1 | awk '{print $2}')
    local proxycommand=$(echo "$details" | grep "^proxycommand " | head -1 | sed 's/^proxycommand //')
    
    # Expand ~ in identityfile path if needed
    if [[ "$identityfile" == "~"* ]]; then
        identityfile="${identityfile/#\~/$HOME}"
    fi
    
    # Print that fancy shit with emojis
    echo -e "\033[1;36m🚀 SSH CONNECTION DETAILS\033[0m"
    echo -e "\033[1;33m═══════════════════════════\033[0m"
    
    echo -e "\033[1;32m👤 Host:\033[0m $host"
    [[ -n "$user" ]] && echo -e "\033[1;32m👨‍💻 User:\033[0m $user"
    [[ -n "$hostname" ]] && echo -e "\033[1;32m🌐 Hostname:\033[0m $hostname"
    [[ "$port" != "22" ]] && echo -e "\033[1;32m🔌 Port:\033[0m $port"
    
    if [[ -n "$identityfile" ]]; then
        echo -e "\033[1;32m🔑 Identity:\033[0m $identityfile"
        
        # Debug this shit
        if [[ ! -f "$identityfile" ]]; then
            echo -e "\033[1;31m❌ Key not found at exact path\033[0m"
            
            # If path contains .pub, try without it
            if [[ "$identityfile" == *".pub" ]]; then
                identityfile="${identityfile%.pub}"
                [[ -f "$identityfile" ]] && echo -e "\033[1;32m✅ Found private key: $identityfile\033[0m"
            fi
        fi
        
        # If file exists, show fingerprint
        if [[ -f "$identityfile" ]]; then
            echo -e "\033[1;32m✅ Key exists\033[0m"
            local fingerprint=$(ssh-keygen -lf "$identityfile" 2>/dev/null | awk '{print $2}')
            [[ -n "$fingerprint" ]] && echo -e "\033[1;32m👉 Fingerprint:\033[0m $fingerprint" 
        fi
    fi
    
    [[ -n "$proxycommand" ]] && echo -e "\033[1;32m🔄 Proxy:\033[0m $proxycommand"
    
    # Check if we can ping the host
   if [[ -n "$hostname" ]]; then
	if ping -c1 -W1 "$hostname" >/dev/null 2>&1; then
		# Ping succeeded
		local latency=$(ping -c1 -W1 "$hostname" 2>/dev/null | tail -1 | awk '{print $4}' | cut -d'/' -f2)
		echo -e "\033[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		echo -e "\033[1;32m🔊 Status:\033[0m \033[1;32mOnline (${latency}ms)\033[0m"
	else
		# Ping failed
		echo -e "\033[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
		echo -e "\033[1;32m🔊 Status:\033[0m \033[1;31mOffline or unreachable\033[0m"
	fi
   fi
	
    # Show recent connections
    if grep -q "ssh $host" ~/.zsh_history 2>/dev/null; then
        echo -e "\033[1;33m━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo -e "\033[1;32m⏱️  Recent connections:\033[0m"
        grep -i "ssh $host" ~/.zsh_history 2>/dev/null | tail -3 | sed 's/^/  /'
    fi
}
