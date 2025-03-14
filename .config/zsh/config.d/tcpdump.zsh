
function netsniff() {
    # Check if tspin is available
    local use_tspin=0
    if command -v tspin &> /dev/null; then
        use_tspin=1
    fi

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
            
            if [[ $use_tspin -eq 1 ]]; then
                print -z "sudo tcpdump -l -nnvttt -i $interface $filter | tspin"
            else
                print -z "sudo tcpdump -l -nnvttt -i $interface $filter"
            fi
            ;;
            
        "Custom Filter Builder")
            # Select interface
            local interface=$(ip -br a | grep -v "lo" | awk '{print $1}' | 
                fzf --ansi --header="Available Interfaces" --prompt="Select interface: ")
            [[ -z "$interface" ]] && return 1
            
            # Base command
            local cmd="sudo tcpdump -l -nnvttt -i $interface"
            
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
            
            if [[ $use_tspin -eq 1 && ! "$cmd" == *"-w"* ]]; then
                print -z "$cmd | tspin"
            else
                print -z "$cmd"
            fi
            ;;
            
        "Packet Capture")
            # Run a common variant of tcpdump
            local interface=$(ip -br a | grep -v "lo" | awk '{print $1}' | 
                fzf --ansi --header="Available Interfaces" --prompt="Select interface: ")
            [[ -z "$interface" ]] && return 1
            
            echo -n "Enter filter expression (leave empty for all traffic): "
            read filter_expr
            
            if [[ -z "$filter_expr" ]]; then
                if [[ $use_tspin -eq 1 ]]; then
                    print -z "sudo tcpdump -l -i $interface -nnvttt | tspin"
                else
                    print -z "sudo tcpdump -l -i $interface -nnvttt"
                fi
            else
                if [[ $use_tspin -eq 1 ]]; then
                    print -z "sudo tcpdump -l -i $interface -nnvttt '$filter_expr' | tspin"
                else
                    print -z "sudo tcpdump -l -i $interface -nnvttt '$filter_expr'"
                fi
            fi
            ;;
            
        *)
            echo "No action selected."; return 1;;
    esac
}

