ftest () {
  local tests=$(pytest --collect-only -q | rg '::' || echo "")
  [[ -z "$tests" ]] && echo "No fucking tests found" && return 1
  local selected=$(echo "$tests" | fzf -m --height 40% --reverse)  || return 0
  local cmd="python -m pytest $(echo "$selected" | sed "s/.*/'&'/" | tr '\n' ' ') -v"
  print -z "$cmd"  # replace current line in shell with command
}

