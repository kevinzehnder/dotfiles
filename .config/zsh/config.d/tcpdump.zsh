function netsniff() {
    local action=$(cat <<EOF | fzf --ansi --header="Network Sniffing Tool" --prompt="Select action: "
Quick Presets
Custom Filter Builder
Packet Capture
EOF
)

    case "$action" in
        "Quick Presets")
            local preset=$(cat <<EOF | fzf --ansi --header="Quick Presets" --prompt="Select preset: "
HTTP (port 80)
HTTPS (port 443)
All HTTP (port 80,8080,8081,8000)
SSH (port 22)
DNS (port 53)
All TCP
All UDP
ICMP
Database Traffic (3306,5432,27017)
Web Services (80,443,8080,8443)
EOF
            )
            
            local filter=""
            case "$preset" in
                "HTTP (port 80)")
                    filter="port 80";;
                "HTTPS (port 443)")
                    filter="port 443";;
                "All HTTP (port 80,8080,8081,8000)")
                    filter="port 80 or port 8080 or port 8081 or port 8000";;
                "SSH (port 22)")
                    filter="port 22";;
                "DNS (port 53)")
                    filter="port 53";;
                "All TCP")
                    filter="tcp";;
                "All UDP")
                    filter="udp";;
                "ICMP")
                    filter="icmp";;
                "Database Traffic (3306,5432,27017)")
                    filter="port 3306 or port 5432 or port 27017";;
                "Web Services (80,443,8080,8443)")
                    filter="port 80 or port 443 or port 8080 or port 8443";;
                *)
                    echo "No preset selected."; return 1;;
            esac
            
            local interface=$(ip -br a | grep -v "lo" | awk '{print $1}' | 
                fzf --ansi --header="Available Interfaces" --prompt="Select interface: ")
            [[ -z "$interface" ]] && return 1
            
            print -z "sudo tcpdump -nnvttt -i $interface $filter"
            ;;
            
        "Custom Filter Builder")
            # Select interface
            local interface=$(ip -br a | grep -v "lo" | awk '{print $1}' | 
                fzf --ansi --header="Available Interfaces" --prompt="Select interface: ")
            [[ -z "$interface" ]] && return 1
            
            # Base command
            local cmd="sudo tcpdump -nnvttt -i $interface"
            
            # Port selection (optional)
            local port_type=$(echo -e "No port filter\nSpecific port\nPort range" | 
                fzf --ansi --header="Port Filter" --prompt="Select port option: ")
            
            case "$port_type" in
                "Specific port")
                    local common_ports="22 SSH\n53 DNS\n80 HTTP\n443 HTTPS\n25 SMTP\n587 SMTP\n110 POP3\n143 IMAP\n3306 MySQL\n5432 PostgreSQL\n27017 MongoDB\n6379 Redis\n1194 OpenVPN"
                    local port_selection=$(echo -e "$common_ports" | 
                        fzf --ansi --header="Common Ports" --prompt="Select port (or 'q' to enter custom): ")
                    
                    if [[ "$port_selection" == "q" ]]; then
                        echo -n "Enter port number: "
                        read custom_port
                        cmd="$cmd port $custom_port"
                    else
                        local port=$(echo "$port_selection" | awk '{print $1}')
                        cmd="$cmd port $port"
                    fi
                    ;;
                    
                "Port range")
                    echo -n "Enter start port: "
                    read start_port
                    echo -n "Enter end port: "
                    read end_port
                    cmd="$cmd portrange $start_port-$end_port"
                    ;;
            esac
            
            # Protocol selection (optional)
            local proto=$(echo -e "No protocol filter\ntcp\nudp\nicmp" | 
                fzf --ansi --header="Protocol Filter" --prompt="Select protocol: ")
            
            if [[ "$proto" != "No protocol filter" ]]; then
                if [[ "$cmd" == *"port"* ]]; then
                    cmd="$cmd and $proto"
                else
                    cmd="$cmd $proto"
                fi
            fi
            
            # Host filter (optional)
            local host_filter=$(echo -e "No host filter\nSource host\nDestination host\nEither source or destination\nBetween two hosts" | 
                fzf --ansi --header="Host Filter" --prompt="Select host option: ")
            
            case "$host_filter" in
                "Source host")
                    echo -n "Enter source IP: "
                    read src_ip
                    if [[ "$cmd" == *"port"* || "$cmd" == *"tcp"* || "$cmd" == *"udp"* || "$cmd" == *"icmp"* ]]; then
                        cmd="$cmd and src host $src_ip"
                    else
                        cmd="$cmd src host $src_ip"
                    fi
                    ;;
                "Destination host")
                    echo -n "Enter destination IP: "
                    read dst_ip
                    if [[ "$cmd" == *"port"* || "$cmd" == *"tcp"* || "$cmd" == *"udp"* || "$cmd" == *"icmp"* ]]; then
                        cmd="$cmd and dst host $dst_ip"
                    else
                        cmd="$cmd dst host $dst_ip"
                    fi
                    ;;
                "Either source or destination")
                    echo -n "Enter IP: "
                    read any_ip
                    if [[ "$cmd" == *"port"* || "$cmd" == *"tcp"* || "$cmd" == *"udp"* || "$cmd" == *"icmp"* ]]; then
                        cmd="$cmd and host $any_ip"
                    else
                        cmd="$cmd host $any_ip"
                    fi
                    ;;
                "Between two hosts")
                    echo -n "Enter first IP: "
                    read ip1
                    echo -n "Enter second IP: "
                    read ip2
                    if [[ "$cmd" == *"port"* || "$cmd" == *"tcp"* || "$cmd" == *"udp"* || "$cmd" == *"icmp"* ]]; then
                        cmd="$cmd and host $ip1 and host $ip2"
                    else
                        cmd="$cmd host $ip1 and host $ip2"
                    fi
                    ;;
            esac
            
            # Add optional flags
            local flags=$(cat <<EOF | fzf -m --ansi --header="Additional Options" --prompt="Select options (multi-select with Tab): "
-A (Print packet in ASCII)
-X (Print packet in hex and ASCII)
-c N (Capture only N packets)
-w file.pcap (Write to file)
-s0 (Capture full packets)
-e (Print link-level headers)
EOF
            )
            
            if [[ -n "$flags" ]]; then
                echo "$flags" | while read -r flag; do
                    case "$flag" in
                        "-w file.pcap"*)
                            echo -n "Enter filename: "
                            read filename
                            cmd="$cmd -w $filename"
                            ;;
                        "-c N"*)
                            echo -n "Enter number of packets: "
                            read num
                            cmd="$cmd -c $num"
                            ;;
                        *)
                            # Extract just the flag part
                            flag_only=$(echo "$flag" | awk '{print $1}')
                            cmd="$cmd $flag_only"
                            ;;
                    esac
                done
            fi
            
            print -z "$cmd"
            ;;
            
        "Packet Capture")
            # Run a common variant of tcpdump
            local interface=$(ip -br a | grep -v "lo" | awk '{print $1}' | 
                fzf --ansi --header="Available Interfaces" --prompt="Select interface: ")
            [[ -z "$interface" ]] && return 1
            
            echo -n "Enter filter expression (leave empty for all traffic): "
            read filter_expr
            
            if [[ -z "$filter_expr" ]]; then
                print -z "sudo tcpdump -i $interface -nnvttt"
            else
                print -z "sudo tcpdump -i $interface -nnvttt '$filter_expr'"
            fi
            ;;
            
        *)
            echo "No action selected."; return 1;;
    esac
}

function ports() {
    check_sudo_nopass || sudo -v
    if ! ss_out=$(sudo ss -Htupln | rg "LISTEN|ESTABLISHED"); then
        echo "no active ports found"
        return 1
    fi
    
    pids=$(echo "$ss_out" | rg "pid=([0-9]+)" -o -r '$1' | sort -u)
    
    if [ -z "$pids" ]; then
        echo "no process IDs found"
        return 1
    fi
    
    # Use ps instead of procs with --no-headers, but enhance display with port info
    pid_args=$(echo "$pids" | tr '\n' ',' | sed 's/,$//')
    
    # Create temp file for process+port data
    tmp_file=$(mktemp)
    
    # For each pid, get the process info and port, then combine them
    for pid in $(echo "$pids"); do
        proc_info=$(sudo ps --no-headers -p "$pid" -o pid,ppid,user,%cpu,%mem,command | tr -s ' ')
        port_info=$(sudo ss -tupln | rg "$pid" | rg -o ':[0-9]+' | head -1 | tr -d ':')
        echo "$proc_info | PORT:$port_info" >> "$tmp_file"
    done
    
    selection=$(cat "$tmp_file" |
        fzf --ansi \
            --preview "sudo ss -tupln | rg \$(echo {} | awk '{print \$1}')" \
            --preview-window=down \
            --height=100% \
            --layout=reverse \
            --header='Active Ports [LISTEN/ESTABLISHED] | ctrl-t: tcpdump' \
            --expect=ctrl-t)
    
    # Clean up temp file
    rm -f "$tmp_file"
    
    key=$(echo "$selection" | head -1)
    line=$(echo "$selection" | tail -1)
    
    if [ "$key" = "ctrl-t" ] && [ -n "$line" ]; then
        pid=$(echo "$line" | awk '{print $1}')
        # Port is already included in the selection line
        port=$(echo "$line" | grep -o 'PORT:[0-9]\+' | cut -d':' -f2)
        
        if [ -n "$port" ]; then
            # Create tcpdump menu similar to netsniff
            tcpdump_action=$(cat <<EOF | fzf --ansi --header="Tcpdump Options for Port $port" --prompt="Select action: "
Basic Capture
Verbose Capture
Capture with Hex
Save to File
Custom Filter
EOF
            )
            
            case "$tcpdump_action" in
                "Basic Capture")
                    print -z "sudo tcpdump -i any port $port -n"
                    ;;
                "Verbose Capture")
                    print -z "sudo tcpdump -i any port $port -nnvvS"
                    ;;
                "Capture with Hex")
                    print -z "sudo tcpdump -i any port $port -nnvXs 0"
                    ;;
                "Save to File")
                    echo -n "Enter filename (default: capture-$port.pcap): "
                    read filename
                    if [ -z "$filename" ]; then
                        filename="capture-$port.pcap"
                    fi
                    print -z "sudo tcpdump -i any port $port -w $filename"
                    ;;
                "Custom Filter")
                    echo -n "Enter additional filter (will be ANDed with port $port): "
                    read custom_filter
                    if [ -n "$custom_filter" ]; then
                        print -z "sudo tcpdump -i any port $port and ($custom_filter) -n"
                    else
                        print -z "sudo tcpdump -i any port $port -n"
                    fi
                    ;;
            esac
        else
            echo "No port found for PID $pid"
        fi
    fi
}
