
# Find files and edit them
function fe() {
   local files=($(fzf -m --ansi \
       --bind "ctrl-h:execute-silent([ -z $HIDDEN ] && export HIDDEN=1 || unset HIDDEN)+reload:fd --type f --color=always $([ -n $HIDDEN ] && echo '--hidden')" \
       --preview 'bat --style=numbers --color=always {}' \
      --header "CTRL-H: enable hidden files | ENTER: open in $EDITOR" \
       < <(fd --type f --color=always)))
   [[ ${#files[@]} -gt 0 ]] && ${EDITOR:-vim} "${files[@]}"
}

# Ripgrep thru files and edit them
function fs() {
  RG_BASE="rg --column --line-number --no-heading --color=always --smart-case --ignore-file-case-insensitive"
  INITIAL_QUERY=""
  local match=$(fzf --ansi --disabled --query "$INITIAL_QUERY" \
      --bind "change:reload:$RG_BASE {q} 2>/dev/null || true" \
      --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+clear-query" \
      --bind "ctrl-h:execute-silent([ -z $HIDDEN ] && export HIDDEN=1 || unset HIDDEN)+reload:$RG_BASE $([ -n $HIDDEN ] && echo '--hidden') {q} 2>/dev/null" \
      --preview "bat --style=numbers --color=always {1} --highlight-line {2} 2>/dev/null" \
	  --preview-window=right:60%:wrap:+{2}-/2 \
      --height=80% \
      --prompt "1. ripgrep> " \
      --delimiter : \
      --header "CTRL-F: switch to fzf filtering | CTRL-H: toggle hidden files | ENTER: open in $EDITOR" \
      < <(eval "$RG_BASE '$INITIAL_QUERY' 2>/dev/null")
  )
  local file=$(echo "$match" | cut -d':' -f1)
  if [[ -n $file ]]; then
      ${EDITOR:-vim} "$file" "+$(echo "$match" | cut -d':' -f2)"
  fi
}

# pretty journal
function jctl(){
	sudo journalctl -n 2000 -e $@ | bat -l syslog -p --pager="less -R +G"
}

function units() {
   zparseopts -D -E -a opts \
       e=enabled -enabled=enabled \
       a=active -active=active

   local cmd="systemctl list-units --type=service --all --no-pager"
   [[ -n "$enabled" ]] && cmd="systemctl list-unit-files --type=service --state=enabled --no-pager"
   [[ -n "$active" ]] && cmd="systemctl list-units --type=service --state=active --no-pager"

   sudo -v
   eval "$cmd" \
       | awk '{print $1}' \
       | rg '\.service' \
       | fzf --ansi \
           --preview "script -qec 'systemctl status {1} --no-pager' /dev/null" \
           --preview-window=right:60%:wrap \
           --header $'System Units | CTRL-R: reload\nCTRL-L: journal | CTRL-S: start | CTRL-D: stop | CTRL-T: restart' \
           --bind "ctrl-r:reload($cmd | awk '{print \$1}' | rg '\.service')" \
           --bind "ctrl-l:execute(sudo journalctl -n 2000 -u {1} --no-pager | bat -l syslog -p --pager='less -R +G')" \
           --bind "ctrl-s:execute(sudo systemctl start {1})" \
           --bind "ctrl-d:execute(sudo systemctl stop {1})" \
           --bind "ctrl-t:execute(sudo systemctl restart {1})"
}

function timers() {
   systemctl list-timers --all --no-pager \
       | tail -n +2 \
       | head -n -2 \
       | awk '{print $(NF-1)}' \
       | fzf --ansi \
           --preview "script -qec 'systemctl status {} --no-pager' /dev/null" \
           --preview-window=right:60%:wrap \
           --header $'System Timers | CTRL-R: reload\nCTRL-L: journal | CTRL-S: start | CTRL-D: stop | CTRL-T: restart' \
           --bind "ctrl-r:reload(systemctl list-timers --all --no-pager | tail -n +2 | head -n -5 | awk '{print \$(NF-1)}')" \
           --bind "ctrl-l:execute(sudo journalctl -n 2000 -u {} --no-pager | bat -l syslog -p --pager='less -R +G')" \
           --bind "ctrl-s:execute(sudo systemctl start {})" \
           --bind "ctrl-d:execute(sudo systemctl stop {})" \
           --bind "ctrl-t:execute(sudo systemctl restart {})"
}

function crons() {
    local cron_list=$(
        # System crontabs
        for f in /etc/cron.d/* /etc/crontab; do
            [[ -f "$f" ]] && grep -Ev '^#|^$|^SHELL|^PATH|^MAILTO|^HOME|^LOGNAME|^USER' "$f" | sed "s|^|$f: |"
        done
        # User crontabs - needs sudo
        for user in $(getent passwd | cut -d: -f1,6 | grep -v /nologin$ | cut -d: -f1); do
            sudo crontab -l -u "$user" 2>/dev/null | grep -Ev '^#|^$|^SHELL|^PATH|^MAILTO|^HOME|^LOGNAME|^USER' | sed "s/^/$user: /"
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
