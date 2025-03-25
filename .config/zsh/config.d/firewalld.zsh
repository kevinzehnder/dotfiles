#!/usr/bin/env zsh
# firewall - Interactive firewalld management tool using fzf

function firewall() {

	# Check if we have fzf
	if ! command -v fzf &> /dev/null; then
		echo "fzf not found. Install it first:"
		echo "sudo dnf install -y fzf"
		return 1
	fi

	# Ensure we have sudo access
	check_sudo_nopass || sudo -v
	if [[ $? -ne 0 ]]; then
		echo "Need sudo privileges. Exiting."
		return 1
	fi

	# Check if firewalld is running
	if ! sudo systemctl is-active --quiet firewalld; then
		echo "Firewalld is not running. Starting it..."
		sudo systemctl start firewalld
	fi

	# Colors
	local RED='\033[0;31m'
	local GREEN='\033[0;32m'
	local YELLOW='\033[0;33m'
	local BLUE='\033[0;34m'
	local NC='\033[0m' # No Color

	# Main menu
	function main_menu() {
		local options=(
			"Status: Show firewalld status"
			"Zones: Manage firewall zones"
			"Services: Quick add/remove services"
			"Ports: Quick add/remove ports"
			"Rich Rules: Manage rich rules"
			"Apply: Save and reload config"
			"Listening: Show currently listening ports"
			"Exit: Quit this tool"
		)

		select=$(printf '%s\n' "${options[@]}" | fzf --height=15 --border --prompt="FirewallD Manager > " --header="Select an option")

		case $select in
			"Status: Show firewalld status")
				show_status
				;;
			"Zones: Manage firewall zones")
				manage_zones
				;;
			"Services: Quick add/remove services")
				manage_services
				;;
			"Ports: Quick add/remove ports")
				manage_ports
				;;
			"Rich Rules: Manage rich rules")
				manage_rich_rules
				;;
			"Apply: Save and reload config")
				reload_firewall
				main_menu
				;;
			"Listening: Show currently listening ports")
				show_listening
				;;
			"Exit: Quit this tool")
				return 0
				;;
			*)
				main_menu
				;;
		esac
	}

	# Status view
	function show_status() {
		clear
		echo -e "🔥 ${BLUE}FIREWALLD STATUS${NC}"
		if systemctl is-active --quiet firewalld; then
			echo -e "• Status: ${GREEN}ACTIVE ✓${NC}"
		else
			echo -e "• Status: ${RED}INACTIVE ✗${NC}"
		fi

		if systemctl is-enabled --quiet firewalld; then
			echo -e "• Boot:   ${GREEN}ENABLED ✓${NC}"
		else
			echo -e "• Boot:   ${RED}DISABLED ✗${NC}"
		fi

		echo -e "\n🎯 ${BLUE}ZONES${NC}"
		echo -e "• Default: $(sudo firewall-cmd --get-default-zone)"

		echo -e "\n🔌 ${BLUE}ACTIVE ZONES${NC}"
		active_zones=$(sudo firewall-cmd --get-active-zones)
		if [[ -z "$active_zones" ]]; then
			echo -e "• ${RED}No active zones${NC}"
		else
			echo "$active_zones" | sed 's/^/• /'
		fi

		main_menu
	}

	function show_zone_info() {
		local zone=$1
		clear
		echo -e "🔥 ${BLUE}ZONE: $zone${NC}"

		echo -e "\n📋 ${BLUE}CONFIGURATION${NC}"
		sudo firewall-cmd --zone=$zone --list-all | sed 's/^/  /'

		echo -e "\n🔄 ${YELLOW}RUNTIME VS PERMANENT${NC}"
		runtime=$(sudo firewall-cmd --zone=$zone --list-all)
		permanent=$(sudo firewall-cmd --zone=$zone --list-all --permanent)

		if [[ "$runtime" != "$permanent" ]]; then
			echo -e "  ${RED}⚠️  DIFFERENCES DETECTED! ⚠️${NC}"
			echo -e "  Run '${GREEN}sudo firewall-cmd --runtime-to-permanent${NC}' to save changes"

			# Optional: Show actual differences
			echo -e "\n📊 ${YELLOW}DIFF DETAILS${NC}"
			diff <(echo "$runtime") <(echo "$permanent") | grep "^[<>]" \
				| sed 's/^</  [Runtime] /g' | sed 's/^>/  [Permanent] /g'
		else
			echo -e "  ${GREEN}✓ No differences - configurations in sync${NC}"
		fi

		zone_menu "$zone"
	}

	# Zone management
	function manage_zones() {
		select=$(get_zones | fzf --height=15 --border --prompt="Select Zone > " --header="Manage Zones")

		if [[ -n "$select" ]]; then
			zone_menu "$select"
		else
			main_menu
		fi
	}

	function zone_menu() {
		local zone=$1
		local options=(
			"Info: Show zone details"
			"Set Default: Make this zone default"
			"Services: Manage services for zone"
			"Ports: Manage ports for zone"
			"Rich Rules: Manage rich rules for zone"
			"Interfaces: Assign interfaces to zone"
			"Back: Return to main menu"
		)

		select=$(printf '%s\n' "${options[@]}" | fzf --height=15 --border --prompt="Zone: $zone > " --header="Zone Management")

		case $select in
			"Info: Show zone details")
				show_zone_info "$zone"
				;;
			"Set Default: Make this zone default")
				sudo firewall-cmd --set-default-zone="$zone"
				echo "Zone $zone is now default"
				sleep 1
				zone_menu "$zone"
				;;
			"Services: Manage services for zone")
				manage_zone_services "$zone"
				;;
			"Ports: Manage ports for zone")
				manage_zone_ports "$zone"
				;;
			"Rich Rules: Manage rich rules for zone")
				manage_zone_rich_rules "$zone"
				;;
			"Interfaces: Assign interfaces to zone")
				manage_zone_interfaces "$zone"
				;;
			"Back: Return to main menu")
				main_menu
				;;
			*)
				zone_menu "$zone"
				;;
		esac
	}

	# Helper functions
	function get_zones() {
		sudo firewall-cmd --get-zones | tr ' ' '\n'
	}

	function get_services() {
		sudo firewall-cmd --get-services | tr ' ' '\n' | sort
	}

	function get_active_zones() {
		sudo firewall-cmd --get-active-zones | grep -v "^[[:space:]]" | tr ' ' '\n'
	}

	function get_zone_services() {
		local zone=$1
		sudo firewall-cmd --zone=$zone --list-services | tr ' ' '\n' | sort
	}

	get_zone_ports() {
		local zone=$1
		sudo firewall-cmd --zone=$zone --list-ports | tr ' ' '\n' | sort
	}

	function get_zone_rich_rules() {
		local zone=$1
		sudo firewall-cmd --zone=$zone --list-rich-rules | tr '\n' '^' | sed 's/\^/\n/g'
	}

	function reload_firewall() {
		echo -e "${YELLOW}Reloading firewall...${NC}"
		sudo firewall-cmd --reload
		echo -e "${GREEN}Firewall reloaded.${NC}"
		sleep 1
	}

	# Service management
	function manage_services() {
		local zone=$(get_active_zones | fzf --height=10 --border --prompt="Select Zone > " --header="Select Zone for Service")

		if [[ -n "$zone" ]]; then
			manage_zone_services "$zone"
		else
			main_menu
		fi
	}

	function manage_zone_services() {
		local zone=$1
		clear
		echo -e "${BLUE}=== Services for Zone: $zone ===${NC}"
		echo -e "${GREEN}Enabled Services:${NC}"
		get_zone_services "$zone" | column
		echo

		local options=(
			"Add: Add services to zone"
			"Remove: Remove services from zone"
			"Back: Return to zone menu"
		)

		select=$(printf '%s\n' "${options[@]}" | fzf --height=10 --border --prompt="Services > " --header="Service Management")

		case $select in
			"Add: Add services to zone")
				add_service "$zone"
				;;
			"Remove: Remove services from zone")
				remove_service "$zone"
				;;
			"Back: Return to zone menu")
				zone_menu "$zone"
				;;
			*)
				manage_zone_services "$zone"
				;;
		esac
	}

	function add_service() {
		local zone=$1
		local current_services=$(get_zone_services "$zone")
		local all_services=$(get_services)

		# Filter out already enabled services
		local available_services=$(comm -23 <(echo "$all_services") <(echo "$current_services"))

		# Multi-select with fzf
		local selected_services=$(echo "$available_services" | fzf --height=20 --border --multi --prompt="Select services to add > " --header="Press TAB to select multiple services")

		if [[ -n "$selected_services" ]]; then
			echo "$selected_services" | while read service; do
				echo -e "Adding service ${GREEN}$service${NC} to zone ${YELLOW}$zone${NC}"
				sudo firewall-cmd --zone="$zone" --add-service="$service" --permanent
			done
			reload_firewall
		fi

		manage_zone_services "$zone"
	}

	function remove_service() {
		local zone=$1
		local current_services=$(get_zone_services "$zone")

		# Multi-select with fzf
		local selected_services=$(echo "$current_services" | fzf --height=20 --border --multi --prompt="Select services to remove > " --header="Press TAB to select multiple services")

		if [[ -n "$selected_services" ]]; then
			echo "$selected_services" | while read service; do
				echo -e "Removing service ${RED}$service${NC} from zone ${YELLOW}$zone${NC}"
				sudo firewall-cmd --zone="$zone" --remove-service="$service" --permanent
			done
			reload_firewall
		fi

		manage_zone_services "$zone"
	}

	# Port management
	function manage_ports() {
		local zone=$(get_active_zones | fzf --height=10 --border --prompt="Select Zone > " --header="Select Zone for Ports")

		if [[ -n "$zone" ]]; then
			manage_zone_ports "$zone"
		else
			main_menu
		fi
	}

	function manage_zone_ports() {
		local zone=$1
		clear
		echo -e "${BLUE}=== Ports for Zone: $zone ===${NC}"
		echo -e "${GREEN}Opened Ports:${NC}"
		get_zone_ports "$zone" | column
		echo

		local options=(
			"Add: Open ports in zone"
			"Remove: Close ports in zone"
			"Custom: Add custom port/protocol"
			"Back: Return to zone menu"
		)

		select=$(printf '%s\n' "${options[@]}" | fzf --height=10 --border --prompt="Ports > " --header="Port Management")

		case $select in
			"Add: Open ports in zone")
				add_port "$zone"
				;;
			"Remove: Close ports in zone")
				remove_port "$zone"
				;;
			"Custom: Add custom port/protocol")
				add_custom_port "$zone"
				;;
			"Back: Return to zone menu")
				zone_menu "$zone"
				;;
			*)
				manage_zone_ports "$zone"
				;;
		esac
	}

	function add_port() {
		local zone=$1
		local common_ports=(
			"80/tcp (HTTP)"
			"443/tcp (HTTPS)"
			"22/tcp (SSH)"
			"21/tcp (FTP)"
			"25/tcp (SMTP)"
			"53/tcp (DNS-TCP)"
			"53/udp (DNS-UDP)"
			"123/udp (NTP)"
			"3306/tcp (MySQL)"
			"5432/tcp (PostgreSQL)"
			"8080/tcp (HTTP-Alt)"
			"8443/tcp (HTTPS-Alt)"
		)

		# Multi-select with fzf
		local selected_ports=$(printf '%s\n' "${common_ports[@]}" | fzf --height=20 --border --multi --prompt="Select ports to open > " --header="Press TAB to select multiple ports")

		if [[ -n "$selected_ports" ]]; then
			echo "$selected_ports" | while read port_desc; do
				local port=$(echo "$port_desc" | cut -d' ' -f1)
				echo -e "Opening port ${GREEN}$port${NC} in zone ${YELLOW}$zone${NC}"
				sudo firewall-cmd --zone="$zone" --add-port="$port" --permanent
			done
			reload_firewall
		fi

		manage_zone_ports "$zone"
	}

	function add_custom_port() {
		local zone=$1
		echo -n "Enter port/protocol (e.g., 8080/tcp): "
		read port_proto

		if [[ $port_proto =~ ^[0-9]+/(tcp|udp)$ ]]; then
			echo -e "Opening custom port ${GREEN}$port_proto${NC} in zone ${YELLOW}$zone${NC}"
			sudo firewall-cmd --zone="$zone" --add-port="$port_proto" --permanent
			reload_firewall
		else
			echo -e "${RED}Invalid format. Use format like 8080/tcp${NC}"
			sleep 2
		fi

		manage_zone_ports "$zone"
	}

	function remove_port() {
		local zone=$1
		local current_ports=$(get_zone_ports "$zone")

		# Multi-select with fzf
		local selected_ports=$(echo "$current_ports" | fzf --height=20 --border --multi --prompt="Select ports to close > " --header="Press TAB to select multiple ports")

		if [[ -n "$selected_ports" ]]; then
			echo "$selected_ports" | while read port; do
				echo -e "Closing port ${RED}$port${NC} in zone ${YELLOW}$zone${NC}"
				sudo firewall-cmd --zone="$zone" --remove-port="$port" --permanent
			done
			reload_firewall
		fi

		manage_zone_ports "$zone"
	}

	# Rich rules management functions
	function manage_rich_rules() {
		local zone=$(get_active_zones | fzf --height=10 --border --prompt="Select Zone > " --header="Select Zone for Rich Rules")

		if [[ -n "$zone" ]]; then
			manage_zone_rich_rules "$zone"
		else
			main_menu
		fi
	}

	function manage_zone_rich_rules() {
		local zone=$1
		clear
		echo -e "${BLUE}=== Rich Rules for Zone: $zone ===${NC}"
		rules=$(get_zone_rich_rules "$zone")
		if [[ -n "$rules" ]]; then
			echo -e "${GREEN}Current Rich Rules:${NC}"
			echo "$rules" | nl
			echo
		else
			echo -e "${YELLOW}No rich rules defined.${NC}"
			echo
		fi

		local options=(
			"Add: Add new rich rule"
			"Remove: Remove existing rich rule"
			"Examples: Show example rules"
			"Back: Return to zone menu"
		)

		select=$(printf '%s\n' "${options[@]}" | fzf --height=10 --border --prompt="Rich Rules > " --header="Rich Rules Management")

		case $select in
			"Add: Add new rich rule")
				add_rich_rule "$zone"
				;;
			"Remove: Remove existing rich rule")
				remove_rich_rule "$zone"
				;;
			"Examples: Show example rules")
				show_rule_examples "$zone"
				;;
			"Back: Return to zone menu")
				zone_menu "$zone"
				;;
			*)
				manage_zone_rich_rules "$zone"
				;;
		esac
	}

	function add_rich_rule() {
		local zone=$1
		clear
		echo -e "${BLUE}=== Add Rich Rule to Zone: $zone ===${NC}"
		echo -e "${YELLOW}Enter rich rule (or type 'examples' to see examples):${NC}"
		read -e rich_rule

		if [[ "$rich_rule" == "examples" ]]; then
			show_rule_examples "$zone"
			return
		fi

		if [[ -n "$rich_rule" ]]; then
			echo -e "Adding rich rule to zone ${YELLOW}$zone${NC}:"
			echo -e "${GREEN}$rich_rule${NC}"
			sudo firewall-cmd --zone="$zone" --add-rich-rule="$rich_rule" --permanent
			reload_firewall
		fi

		manage_zone_rich_rules "$zone"
	}

	function remove_rich_rule() {
		local zone=$1
		local rules=$(get_zone_rich_rules "$zone")

		if [[ -z "$rules" ]]; then
			echo -e "${YELLOW}No rich rules to remove.${NC}"
			sleep 1
			manage_zone_rich_rules "$zone"
			return
		fi

		# Select with fzf
		local selected_rule=$(echo "$rules" | fzf --height=20 --border --prompt="Select rule to remove > " --header="Rich Rule Selection")

		if [[ -n "$selected_rule" ]]; then
			echo -e "Removing rich rule from zone ${YELLOW}$zone${NC}:"
			echo -e "${RED}$selected_rule${NC}"
			sudo firewall-cmd --zone="$zone" --remove-rich-rule="$selected_rule" --permanent
			reload_firewall
		fi

		manage_zone_rich_rules "$zone"
	}

	function show_rule_examples() {
		local zone=$1
		clear
		echo -e "${BLUE}=== Rich Rule Examples ===${NC}"
		echo -e "1. ${GREEN}rule family=\"ipv4\" source address=\"192.168.1.0/24\" accept${NC}"
		echo "   Allow all traffic from 192.168.1.0/24 subnet"
		echo
		echo -e "2. ${GREEN}rule family=\"ipv4\" source address=\"192.168.1.5\" service name=\"http\" accept${NC}"
		echo "   Allow HTTP from specific IP"
		echo
		echo -e "3. ${GREEN}rule family=\"ipv4\" source address=\"10.0.0.0/8\" port port=\"8080\" protocol=\"tcp\" accept${NC}"
		echo "   Allow TCP port 8080 from 10.0.0.0/8 network"
		echo
		echo -e "4. ${GREEN}rule family=\"ipv4\" source address=\"1.2.3.4\" reject${NC}"
		echo "   Reject all traffic from 1.2.3.4"
		echo
		echo -e "5. ${GREEN}rule priority=\"0\" forward-port port=\"80\" protocol=\"tcp\" to-port=\"8080\"${NC}"
		echo "   Forward external port 80 to local port 8080"
		echo

		echo "Press any key to continue..."
		read -k 1
		manage_zone_rich_rules "$zone"
	}

	# Interface management
	function manage_zone_interfaces() {
		local zone=$1
		clear
		echo -e "${BLUE}=== Interfaces for Zone: $zone ===${NC}"

		# List current interfaces for zone
		echo -e "${GREEN}Current interfaces:${NC}"
		sudo firewall-cmd --zone="$zone" --list-interfaces
		echo

		# List all interfaces
		echo -e "${YELLOW}Available interfaces:${NC}"
		ip -o link show | awk -F': ' '{print $2}' | grep -v "lo" | sort
		echo

		local options=(
			"Add: Add interface to zone"
			"Remove: Remove interface from zone"
			"Back: Return to zone menu"
		)

		select=$(printf '%s\n' "${options[@]}" | fzf --height=10 --border --prompt="Interfaces > " --header="Interface Management")

		case $select in
			"Add: Add interface to zone")
				add_interface "$zone"
				;;
			"Remove: Remove interface from zone")
				remove_interface "$zone"
				;;
			"Back: Return to zone menu")
				zone_menu "$zone"
				;;
			*)
				manage_zone_interfaces "$zone"
				;;
		esac
	}

	function add_interface() {
		local zone=$1
		local interfaces=$(ip -o link show | awk -F': ' '{print $2}' | grep -v "lo" | sort)

		# Select with fzf
		local selected_interface=$(echo "$interfaces" | fzf --height=20 --border --prompt="Select interface to add > " --header="Interface Selection")

		if [[ -n "$selected_interface" ]]; then
			echo -e "Adding interface ${GREEN}$selected_interface${NC} to zone ${YELLOW}$zone${NC}"
			sudo firewall-cmd --zone="$zone" --add-interface="$selected_interface" --permanent
			reload_firewall
		fi

		manage_zone_interfaces "$zone"
	}

	function remove_interface() {
		local zone=$1
		local interfaces=$(sudo firewall-cmd --zone="$zone" --list-interfaces | tr ' ' '\n')

		if [[ -z "$interfaces" ]]; then
			echo -e "${YELLOW}No interfaces to remove.${NC}"
			sleep 1
			manage_zone_interfaces "$zone"
			return
		fi

		# Select with fzf
		local selected_interface=$(echo "$interfaces" | fzf --height=20 --border --prompt="Select interface to remove > " --header="Interface Selection")

		if [[ -n "$selected_interface" ]]; then
			echo -e "Removing interface ${RED}$selected_interface${NC} from zone ${YELLOW}$zone${NC}"
			sudo firewall-cmd --zone="$zone" --remove-interface="$selected_interface" --permanent
			reload_firewall
		fi

		manage_zone_interfaces "$zone"
	}

	# Show listening ports
	function show_listening() {
		clear
		echo -e "${BLUE}=== Listening Ports ===${NC}"
		echo -e "${YELLOW}Protocol | Port | Process${NC}"
		echo "--------------------------------"
		ss -tulpn | grep LISTEN | sort -k5 | awk '{printf "%-8s | %-5s | %s\n", $1, $5, $7}' | sed 's/.*:\([0-9]*\) .*/\1/g'
		echo

		# Check if all listening ports are allowed through firewall
		echo -e "${BLUE}=== Firewall Check ===${NC}"
		default_zone=$(sudo firewall-cmd --get-default-zone)
		allowed_ports=$(sudo firewall-cmd --zone=$default_zone --list-ports | tr ' ' '\n' | cut -d'/' -f1)
		allowed_services=$(sudo firewall-cmd --zone=$default_zone --list-services)

		for service in $allowed_services; do
			service_ports=$(sudo firewall-cmd --info-service=$service | grep port= | cut -d= -f2 | cut -d- -f1)
			if [[ -n "$service_ports" ]]; then
				allowed_ports="$allowed_ports $service_ports"
			fi
		done

		listening_ports=$(ss -tulpn | grep LISTEN | awk '{print $5}' | sed 's/.*:\([0-9]*\)/\1/g' | sort -u)

		for port in $listening_ports; do
			if echo "$allowed_ports" | grep -q -w "$port"; then
				echo -e "Port ${GREEN}$port${NC} is listening and ${GREEN}allowed${NC} in firewall"
			else
				echo -e "Port ${RED}$port${NC} is listening but ${RED}NOT allowed${NC} in firewall"
			fi
		done

		main_menu
	}
	main_menu
}
