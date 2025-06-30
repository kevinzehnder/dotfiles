function tg() {
	# Capture the output of the pipeline into a variable
	local selected_tasks=$(task --taskfile ${HOME}/.Taskfile.yaml --list \
		| cut -d ' ' -f2 \
		| tail -n +2 \
		| sd ':?$' '' \
		| sort \
		| fzf -m --reverse --preview 'task --taskfile ${HOME}/.Taskfile.yaml --summary {}')

	# Check if any tasks were selected
	if [ -n "$selected_tasks" ]; then
		# Loop through the selected tasks and execute the command with each task as an argument
		for task in $selected_tasks; do
			task "$@"--taskfile ${HOME}/.Taskfile.yaml $task
		done
	fi
}

