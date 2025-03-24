aplay() {
	# Step 1: Select playbook from playbooks dir
	local playbook=$(fd -t f . playbooks/ \
		| rg "\.ya?ml$" \
		| rg -v "inventory|vars" \
		| fzf --preview 'bat --style=numbers --color=always --line-range :100 {}' \
			--preview-window='right:60%' \
			--header 'Select playbook (ESC to quit)' \
			--height='80%')
	[[ -z "$playbook" ]] && return

	# Step 2: Select inventory (optional)
	local inventory=$(fd -t f -d 1 . inventories/ \
		| fzf --preview 'bat --style=numbers --color=always --line-range :100 {}' \
			--preview-window='right:60%' \
			--header 'Select inventory file (ESC to skip)' \
			--height='80%')

	# Step 3: Select hosts if inventory was selected
	local hosts=""
	if [[ -n "$inventory" ]]; then
		hosts=$(ansible-inventory --list -i "$inventory" \
			| jq -r '
                . as $root |
                ($root | keys - ["_meta"]) as $groups |
                ($groups[] | "\u001b[32m@" + . + "\u001b[0m"),
                ($root._meta.hostvars | keys[] | "\u001b[36m" + . + "\u001b[0m")
            ' \
			| fzf -m --ansi \
				--header 'Select hosts/groups (TAB to multi-select, ESC to skip)' \
			| sed 's/\x1b\[[0-9;]*m//g' \
			|
			# Strip ANSI colors
			sed 's/^@//' \
			| sort -u)
	fi

	# Step 4: Select tags (optional)
	local tags=$(ansible-playbook "$playbook" --list-tags 2> /dev/null \
		| rg "TASK TAGS" \
		| sed 's/.*\[\(.*\)\].*/\1/' \
		| tr ',' '\n' \
		| sed 's/^[ ]*//' \
		| sort -u \
		| fzf -m --header 'Select tags (TAB to multi-select, ESC to skip)')

	# Build command
	local cmd="ansible-playbook"
	[[ -n "$inventory" ]] && cmd="$cmd -i $inventory"
	[[ -n "$hosts" ]] && cmd="$cmd --limit '$(echo $hosts | tr '\n' ',')'"
	[[ -n "$tags" ]] && cmd="$cmd --tags '$(echo $tags | tr '\n' ',')'"

	print -z "$cmd $playbook"
}

function arole() {
	# Step 1: Select role from roles dir
	local role
	role=$(fd -t d -d 1 . roles/ \
		| sed 's/roles\///' \
		| fzf --preview 'bat --style=numbers --color=always --line-range :100 roles/{}/README.md 2>/dev/null || echo "No README.md found"' \
			--preview-window='right:60%' \
			--header 'Select role (ESC to quit)' \
			--height='80%')
	[[ -z "$role" ]] && return

	# Step 2: Select inventory (optional)
	local inventory
	inventory=$(fd -t f . inventories/ \
		| rg "inventory" \
		| fzf --preview 'bat --style=numbers --color=always --line-range :100 {}' \
			--preview-window='right:60%' \
			--header 'Select inventory file (ESC to skip)' \
			--height='80%')

	# Step 3: Select hosts if inventory was selected
	local hosts=""
	if [[ -n "$inventory" ]]; then
		hosts=$(ansible-inventory --list -i "$inventory" \
			| jq -r '
                . as $root |
                ($root | keys - ["_meta"]) as $groups |
                ($groups[] | "\u001b[32m@" + . + "\u001b[0m"),
                ($root._meta.hostvars | keys[] | "\u001b[36m" + . + "\u001b[0m")
            ' \
			| fzf -m --ansi \
				--header 'Select hosts/groups (TAB to multi-select, ESC to skip)' \
			| sed 's/\x1b\[[0-9;]*m//g' \
			|
			# Strip ANSI colors
			sed 's/^@//' \
			| sort -u)
	fi

	# Step 4: Select tags (optional)
	local tags
	tags=$(ansible-galaxy role info "$role" 2> /dev/null \
		| rg "TASK TAGS" \
		| sed 's/.*\[\(.*\)\].*/\1/' \
		| tr ',' '\n' \
		| sed 's/^[ ]*//' \
		| sort -u \
		| fzf -m --header 'Select tags (TAB to multi-select, ESC to skip)')

	# Build command
	local cmd="ansible"
	[[ -n "$inventory" ]] && cmd="$cmd -i $inventory"
	[[ -n "$hosts" ]] && cmd="$cmd $(echo $hosts | tr '\n' ',')"
	[[ -n "$tags" ]] && cmd="$cmd --tags '$(echo $tags | tr '\n' ',')'"

	print -z "$cmd -m include_role -a name=$role"
}
