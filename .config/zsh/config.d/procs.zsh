function procsp() {
	sudo -v
    sudo procs --color always --load-config ~/.config/procs/procs_ports.toml "$@" | fzf --ansi
}

function procsl() {
    sudo -v
    sudo procs --use-config=large
}

function psk() {
   sudo -v
   sudo procs | fzf --ansi \
       --preview "sudo procs --no-header --pager=disable --tree {1}" \
       --preview-window=down \
       --bind='ctrl-r:reload(sudo procs)' \
       --header='[CTRL-R] reload [ENTER] kill' \
       --height=100% \
       --layout=reverse \
       | awk '{print $1}' | xargs -r sudo kill -9
}

function ports() {
   sudo -v
   sudo ss -Htupln | rg "LISTEN|ESTABLISHED" | tr ',' '\n' | rg "pid=([0-9]+)" -o -r '$1' | xargs -I {} echo -n "{} " | xargs echo "--or" | xargs sudo procs --no-header | fzf --ansi \
       --preview "sudo ss -tupln | rg {1}" \
       --preview-window=down \
       --height=100% \
       --layout=reverse \
       --header='Active Ports [LISTEN/ESTABLISHED]' \
}

function hogs() {
   sudo -v
   sudo procs --sortd cpu --no-header | head -n 10 | fzf --ansi \
       --preview "sudo procs --tree {1}" \
       --preview-window=down \
       --height=100% \
       --layout=reverse \
       --header='Top CPU Hoggers [ENTER to kill]' \
       --bind='ctrl-r:reload(sudo procs --sortd cpu --no-header | head -n 10)' \
       | awk '{print $1}' | xargs -r sudo kill -9
}

# Find files and fucking edit them
function fe() {
   local file=$(fzf --ansi \
       --bind "ctrl-h:execute-silent([ -z $HIDDEN ] && export HIDDEN=1 || unset HIDDEN)+reload:fd --type f --color=always $([ -n $HIDDEN ] && echo '--hidden')" \
       --preview 'bat --style=numbers --color=always {}' \
      --header "CTRL-H: enable hidden files | ENTER: open in $EDITOR" \
       < <(fd --type f --color=always) \
       | awk '{print $1}'
   )
   [[ -n $file ]] && ${EDITOR:-vim} "$file"
}

function fs() {
  RG_BASE="rg --column --line-number --no-heading --color=always --smart-case --ignore-file-case-insensitive"
  INITIAL_QUERY=""
  local match=$(fzf --ansi --disabled --query "$INITIAL_QUERY" \
      --bind "change:reload:$RG_BASE {q} 2>/dev/null || true" \
      --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+clear-query" \
      --bind "ctrl-h:execute-silent([ -z $HIDDEN ] && export HIDDEN=1 || unset HIDDEN)+reload:$RG_BASE $([ -n $HIDDEN ] && echo '--hidden') {q} 2>/dev/null" \
      --preview "bat --style=numbers --color=always {1} --highlight-line {2} 2>/dev/null" \
      --height=80% \
      --preview-window "down,60%" \
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
