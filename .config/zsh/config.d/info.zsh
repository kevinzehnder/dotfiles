function info() {
	local os=$(rg -N "PRETTY" /etc/os-release | awk -F '=' '{print $2}' | tr -d '"')
	local kernel=$(uname -r)
	local uptime=$(uptime -p)
	local load=$(head -1 /proc/loadavg | awk '{print $1, $2, $3}')
	local active_services=$(systemctl list-units --type=service --state=active | rg -N "loaded active" | wc -l)
	local listening=$(ss -tulpn | rg -N LISTEN | wc -l)
	local cron_count=0
	for f in /etc/cron.d/* /etc/crontab; do
		[[ -f "$f" ]] && ((cron_count += $(rg -N -v '^#|^$|^SHELL|^PATH|^MAILTO|^HOME|^LOGNAME|^USER' "$f" | wc -l)))
	done
	for user in $(getent passwd | rg -N -v /nologin$ | cut -d ':' -f 1); do
		((cron_count += $(sudo crontab -l -u "$user" 2> /dev/null | rg -N -v '^#|^$|^SHELL|^PATH|^MAILTO|^HOME|^LOGNAME|^USER' | wc -l)))
	done
	local timer_count=$(systemctl list-timers --all | rg -N "active" | wc -l)
	local cpu_model=$(cat /proc/cpuinfo | grep -i "model name\|hardware" | head -1 | sed 's/.*: //')
	local cpu_cores=$(grep -c "^processor" /proc/cpuinfo)
	local cpu_arch=$(uname -m)
	local hostname=$(hostname)
	printf '\n⚡ \033[1m%s\033[0m ⚡\n\n' "$hostname"
	echo "🖥️  OS:      $os"
	echo "🐧 Kernel:   $kernel"
	echo "⏰ Uptime:   $uptime"
	echo "📊 Load:     $load"
	echo "🚀 Services: $active_services running"
	echo "🔌 Ports:    $listening listening"
	echo "⚡ Timers:   $timer_count active"
	echo "🕒 Crons:    $cron_count jobs"
	echo -e "\n💻 CPU:"
	echo "    Model:     $cpu_model"
	echo "    Cores:     $cpu_cores"
	echo "    Arch:      $cpu_arch"
	echo -e "\n📈 Memory:"
	free -h | rg -N "Mem" | awk '{print $2, $3, $4}' | xargs printf "    Total: %s / Used: %s / Free: %s\n"
	echo -e "\n🌐 Network:"
	ip -br a | rg -N -v '^lo' | while read -r line; do
		local iface=$(echo $line | awk '{print $1}')
		local ip=$(echo $line | awk '{print $3}')
		echo "    $iface: $ip"
	done
	echo -e "\n👥 Users:"
	w -h | while read -r user tty from rest; do
		printf "    %s\t%s\t%s\n" "$user" "$tty" "$from"
	done
	echo -e "\n🔄 Reboot:"
	if needs_reboot; then
		echo "    ⚠️  Reboot needed"
	else
		echo "    No Reboot needed"
	fi
}
