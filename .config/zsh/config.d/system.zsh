function crons() {
	local cron_list=$(
		# System crontabs
		for f in /etc/cron.d/* /etc/crontab; do
			[[ -f "$f" ]] && grep -Ev '^#|^$|^SHELL|^PATH|^MAILTO|^HOME|^LOGNAME|^USER' "$f" | sed "s|^|$f: |"
		done
		# User crontabs - needs sudo
		for user in $(getent passwd | cut -d: -f1,6 | grep -v /nologin$ | cut -d: -f1); do
			sudo crontab -l -u "$user" 2> /dev/null | grep -Ev '^#|^$|^SHELL|^PATH|^MAILTO|^HOME|^LOGNAME|^USER' | sed "s/^/$user: /"
		done
	)

	local preview_cmd='
        line={}
        source=$(echo "$line" | cut -d: -f1)
        schedule=$(echo "$line" | cut -d: -f2- | awk "{print \$1,\$2,\$3,\$4,\$5}")
        command=$(echo "$line" | cut -d: -f2- | cut -d" " -f6-)
        echo -e "\033[1;32mSource:\033[0m $source"
        echo -e "\033[1;33mSchedule:\033[0m $schedule"
        echo -e "\033[1;34mCommand:\033[0m $command"
    '

	local selected=$(echo "$cron_list" | fzf --ansi \
		--preview "$preview_cmd" \
		--preview-window=up:3)

	if [[ -n "$selected" ]]; then
		local source=$(echo "$selected" | cut -d: -f1)
		if [[ "$source" =~ ^/etc/ ]]; then
			sudo vim "$source"
		else
			local user=$(echo "$source" | tr -d ' ')
			sudo crontab -e -u "$user"
		fi
	fi
}

function timers() {
	if command -v tspin > /dev/null 2>&1; then
		local follow_logs='sudo journalctl -n 100 -f -u {1} | tspin'
		local logs='sudo journalctl -n 2000 -u {1} | tspin | less -r +G'
	else
		local follow_logs='sudo journalctl -n 100 -f -u {1}'
		local logs='sudo journalctl -n 2000 -e -u {1}'
		# local logs="sudo journalctl -n 2000 -u {1} --no-pager | bat -l syslog -p --pager='less -R +G'"
	fi

	check_sudo_nopass || sudo -v
	systemctl list-timers --all --no-pager \
		| tail -n +2 \
		| head -n -2 \
		| awk '{print $(NF-1)}' \
		| fzf --ansi \
			--preview "script -qec 'sudo systemctl status {} --no-pager' /dev/null" \
			--preview-window=right:60%:wrap \
			--header $'System Timers | CTRL-R: reload\nCTRL-L: journal | CTRL-E: edit\nCTRL-S: start | CTRL-D: stop | CTRL-T: restart' \
			--bind "ctrl-r:reload(systemctl list-timers --all --no-pager | tail -n +2 | head -n -5 | awk '{print \$(NF-1)}')" \
			--bind "ctrl-l:execute($logs)" \
			--bind "ctrl-e:execute(sudo systemctl edit {1})" \
			--bind "ctrl-s:execute(sudo systemctl start {})" \
			--bind "ctrl-d:execute(sudo systemctl stop {})" \
			--bind "ctrl-t:execute(sudo systemctl restart {})"
}

function jctl() {
	if command -v tspin > /dev/null 2>&1; then
		sudo journalctl -n 2000 $@ | tspin | less -r +G
	else
		sudo journalctl -n 2000 $@
	fi
}

# pretty journal
function jf() {
	if command -v tspin > /dev/null 2>&1; then
		sudo journalctl -n 50 -f $@ | tspin
	else
		sudo journalctl -n 50 -f $@
	fi
}

function units() {
	zparseopts -D -E -a opts \
		e=enabled -enabled=enabled \
		a=active -active=active

	local cmd="systemctl list-units --type=service --all --no-pager --plain"
	[[ -n "$enabled" ]] && cmd="systemctl list-unit-files --type=service --state=enabled --no-pager --plain"
	[[ -n "$active" ]] && cmd="systemctl list-units --type=service --state=active --no-pager --plain"

	if command -v tspin > /dev/null 2>&1; then
		local follow_logs='sudo journalctl -n 100 -f -u {1} | tspin'
		local follow_logs_pre='sudo journalctl -n 50 -f -u {1} | tspin'
		local logs='sudo journalctl -n 2000 -u {1} | tspin | less -r +G'
	else
		local follow_logs='sudo journalctl -n 100 -f -u {1}'
		local follow_logs_pre='sudo journalctl -n 50 -f -u {1}'
		local logs='sudo journalctl -n 2000 -e -u {1}'
		# local logs="sudo journalctl -n 2000 -u {1} --no-pager | bat -l syslog -p --pager='less -R +G'"
	fi
	local show_status="script -qec 'systemctl status {1} --no-pager' /dev/null"

	check_sudo_nopass || sudo -v
	eval "$cmd" \
		| awk '{print $1}' \
		| rg '\.service' \
		| fzf --ansi \
			--preview "$show_status" \
			--preview-window=right:60%:wrap:follow \
			--height=80% \
			--header $'System Units | CTRL-R: reload\nCTRL-L: journal | CTRL-F: follow logs | CTRL-E: edit\nCTRL-S: start | CTRL-D: stop | CTRL-T: restart' \
			--bind "ctrl-r:reload($cmd | awk '{print \$1}' | rg '\.service')" \
			--bind "ctrl-l:execute($logs)" \
			--bind "ctrl-f:execute($follow_logs)" \
			--bind "ctrl-e:execute(sudo systemctl edit {1} --full)" \
			--bind "ctrl-s:execute(sudo systemctl start {1})" \
			--bind "ctrl-d:execute(sudo systemctl stop {1})" \
			--bind "ctrl-t:execute(sudo systemctl restart {1})" \
			--bind "ctrl-p:preview($follow_logs_pre)"
}
