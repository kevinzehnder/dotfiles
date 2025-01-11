
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
       | head -n -5 \
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
   (for f in /etc/cron.d/* /etc/crontab; do
       [[ -f "$f" ]] && grep -Ev '^#|^$' "$f" | sed "s|^|$f: |"
   done
   for user in $(getent passwd | cut -d: -f1,6 | grep -v /nologin$ | cut -d: -f1); do
       crontab -l -u "$user" 2>/dev/null | grep -Ev '^#|^$' | sed "s/^/$user: /"
   done) | \
   fzf --ansi \
       --header $'System Crons | CTRL-R: reload\nFormat: [file/user]: [schedule] [command]' \
       --bind "ctrl-r:reload(for f in /etc/cron.d/* /etc/crontab; do [[ -f \$f ]] && grep -Ev '^#|^$' \$f | sed \"s|^|\$f: |\"; done; for user in \$(getent passwd | cut -d: -f1,6 | grep -v /nologin$ | cut -d: -f1); do crontab -l -u \$user 2>/dev/null | grep -Ev '^#|^$' | sed \"s/^/\$user: /\"; done)"
}

