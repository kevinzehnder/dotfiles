function fs() {
	local search_dir="${1:-.}" # Use first argument or current directory
	local RG_BASE="rg --column --line-number --no-heading --color=always --smart-case --ignore-file-case-insensitive"
	local INITIAL_QUERY=""
	local HIDDEN_FLAG=""
	# Create a temporary file to track hidden state
	local hidden_state_file=$(mktemp)
	echo "0" > "$hidden_state_file"
	local match=$(
		FZF_DEFAULT_COMMAND="$RG_BASE '$INITIAL_QUERY' '$search_dir' 2>/dev/null || true" \
			fzf --ansi --disabled --query "$INITIAL_QUERY" \
			--bind "change:reload:$RG_BASE \$([ \$(cat $hidden_state_file) -eq 1 ] && echo '--hidden') {q} '$search_dir' 2>/dev/null || true" \
			--bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(2. fzf> )+enable-search+clear-query" \
			--bind "ctrl-h:execute-silent([ \$(cat $hidden_state_file) -eq 0 ] && echo 1 > $hidden_state_file || echo 0 > $hidden_state_file)+reload:$RG_BASE \$([ \$(cat $hidden_state_file) -eq 1 ] && echo '--hidden') {q} '$search_dir' 2>/dev/null || true" \
			--preview "BAT_STYLE=numbers bat --color=always --highlight-line {2} {1} 2>/dev/null" \
			--preview-window=right:60%:wrap:+{2}-/2 \
			--height=80% \
			--prompt "1. ripgrep ($search_dir)> " \
			--delimiter : \
			--header "CTRL-F: switch to fzf filtering | CTRL-H: toggle hidden files | ENTER: open in $EDITOR"
	)
	# Clean up the temporary file
	rm -f "$hidden_state_file"
	local file=$(echo "$match" | cut -d':' -f1)
	if [[ -n $file ]]; then
		${EDITOR:-vim} "$file" "+$(echo "$match" | cut -d':' -f2)"
	fi
}

# Find files and edit them
function fe() {
	local toggle_file="/tmp/fe_hidden_toggle_$"
	trap "rm -f $toggle_file" EXIT

	local files=($(fzf -m --ansi \
		--bind "ctrl-h:execute-silent([ -f $toggle_file ] && rm $toggle_file || touch $toggle_file)+reload:fd --type f --color=always \$([ -f $toggle_file ] && echo '--hidden') {q}" \
		--preview 'bat --style=numbers --color=always {}' \
		--header "CTRL-H: toggle hidden files | ENTER: open in $EDITOR" \
		< <(fd --type f --color=always)))

	rm -f "$toggle_file"
	[[ ${#files[@]} -gt 0 ]] && ${EDITOR:-vim} "${files[@]}"
}
