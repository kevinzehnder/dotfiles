
# Find files and fucking edit them
function fe() {
   local files=($(fzf -m --ansi \
       --bind "ctrl-h:execute-silent([ -z $HIDDEN ] && export HIDDEN=1 || unset HIDDEN)+reload:fd --type f --color=always $([ -n $HIDDEN ] && echo '--hidden')" \
       --preview 'bat --style=numbers --color=always {}' \
      --header "CTRL-H: enable hidden files | ENTER: open in $EDITOR" \
       < <(fd --type f --color=always)))
   [[ ${#files[@]} -gt 0 ]] && ${EDITOR:-vim} "${files[@]}"
}

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

function units() {
    sudo -v
    systemctl list-units --type=service --all --no-pager \
        | awk '{print $1}' \
        | rg '\.service' \
        | fzf --ansi \
            --preview "script -qec 'systemctl status {1} --no-pager' /dev/null" \
            --preview-window=right:60%:wrap \
            --header 'System Units | CTRL-R: reload | CTRL-L: journal | CTRL-S: start/stop' \
            --bind "ctrl-r:reload(systemctl list-units --type=service --all --no-pager | awk '{print \$1}' | rg '\.service')" \
            --bind "ctrl-l:execute(journalctl -u {1} --no-pager  | bat --paging=always --color=always -l log --style=numbers --pager='less -FR +G')" \
            --bind "ctrl-s:execute(echo 'Action? [s]tart [k]ill [r]estart' && read -n 1 action && \
                case \$action in \
                    s) sudo systemctl start {1} ;; \
                    k) sudo systemctl stop {1} ;; \
                    r) sudo systemctl restart {1} ;; \
                esac)"
}
