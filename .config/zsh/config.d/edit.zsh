# Ripgrep thru files and edit them
function fs() {
	RG_BASE="rg --column --line-number --no-heading --color=always --smart-case --ignore-file-case-insensitive"
	INITIAL_QUERY=""
	local match=$(
		fzf --ansi --disabled --query "$INITIAL_QUERY" \
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
