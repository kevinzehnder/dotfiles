# Manage nerdctl containers with fzf
function ncont() {
	# Make sure we have sudo permissions first
	check_sudo_nopass || sudo -v

	# Base command to list containers
	local list_cmd="sudo nerdctl container ls --format '{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"

	# Show all containers if -a flag is passed
	if [[ "$1" == "-a" ]]; then
		list_cmd="sudo nerdctl container ls -a --format '{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"
	fi

	# Container information preview
	local preview_cmd='
        id=$(echo {} | cut -f1)
        sudo nerdctl container inspect $id | jq
    '

	# Container logs preview
	local logs_preview='
        id=$(echo {} | cut -f1)
        sudo nerdctl container logs --tail 100 $id
    '

	# Main fzf command with bindings
	eval "$list_cmd" | fzf --ansi \
		--header-lines=1 \
		--preview-window=right:60%:wrap \
		--preview "$preview_cmd" \
		--header $'Container Management | CTRL-R: reload\nCTRL-L: logs | CTRL-F: follow logs | CTRL-S: start\nCTRL-D: stop | CTRL-K: kill | CTRL-X: rm | CTRL-E: exec bash' \
		--bind "ctrl-r:reload($list_cmd)" \
		--bind "ctrl-l:execute(id=\$(echo {} | cut -f1); sudo nerdctl container logs --tail 500 \$id | less -R)" \
		--bind "ctrl-f:execute(id=\$(echo {} | cut -f1); sudo nerdctl container logs --follow \$id)" \
		--bind "ctrl-s:execute(id=\$(echo {} | cut -f1); sudo nerdctl container start \$id)" \
		--bind "ctrl-d:execute(id=\$(echo {} | cut -f1); sudo nerdctl container stop \$id)" \
		--bind "ctrl-k:execute(id=\$(echo {} | cut -f1); sudo nerdctl container kill \$id)" \
		--bind "ctrl-x:execute(id=\$(echo {} | cut -f1); sudo nerdctl container rm \$id)" \
		--bind "ctrl-e:execute(id=\$(echo {} | cut -f1); sudo nerdctl container exec -it \$id bash)" \
		--bind "ctrl-p:toggle-preview" \
		--bind "ctrl-v:preview($logs_preview)"
}

# Manage nerdctl images with fzf
function nimg() {
	# Make sure we have sudo permissions first
	check_sudo_nopass || sudo -v

	# Base command to list images
	local list_cmd="sudo nerdctl image ls --format '{{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}'"

	# Image information preview
	local preview_cmd='
        id=$(echo {} | cut -f1)
        sudo nerdctl image inspect $id | jq
    '

	# Main fzf command with bindings
	eval "$list_cmd" | fzf --ansi \
		--header-lines=1 \
		--preview-window=right:60%:wrap \
		--preview "$preview_cmd" \
		--header $'Image Management | CTRL-R: reload\nCTRL-D: remove image | CTRL-P: pull | CTRL-F: search' \
		--bind "ctrl-r:reload($list_cmd)" \
		--bind "ctrl-d:execute(id=\$(echo {} | cut -f1); sudo nerdctl image rm \$id)" \
		--bind "ctrl-p:execute(read -p 'Image to pull: ' img && sudo nerdctl pull \$img)" \
		--bind "ctrl-f:execute(read -p 'Search image: ' img && sudo nerdctl search \$img | less)"
}

# View logs of nerdctl containers
function nlogs() {
	# Make sure we have sudo permissions first
	check_sudo_nopass || sudo -v

	local container=$(sudo nerdctl container ls --format '{{.Names}}' | fzf --header="Select container")

	if [[ -n "$container" ]]; then
		if [[ "$1" == "-f" ]]; then
			sudo nerdctl container logs --follow "$container"
		else
			sudo nerdctl container logs --tail 1000 "$container" | less -R
		fi
	fi
}

# View networks
function nnet() {
	# Make sure we have sudo permissions first
	check_sudo_nopass || sudo -v

	local preview_cmd='
        name=$(echo {} | awk "{print \$2}")
        sudo nerdctl network inspect $name | jq
    '

	sudo nerdctl network ls | fzf --ansi \
		--header-lines=1 \
		--preview "$preview_cmd" \
		--preview-window=right:60%:wrap \
		--header $'Network Management | CTRL-R: reload\nCTRL-X: remove network | CTRL-C: create network' \
		--bind "ctrl-r:reload(sudo nerdctl network ls)" \
		--bind "ctrl-x:execute(name=\$(echo {} | awk '{print \$2}'); sudo nerdctl network rm \$name)" \
		--bind "ctrl-c:execute(read -p 'Network name: ' net && sudo nerdctl network create \$net)"
}

# View volumes
function nvol() {
	# Make sure we have sudo permissions first
	check_sudo_nopass || sudo -v

	local preview_cmd='
        name=$(echo {} | awk "{print \$2}")
        sudo nerdctl volume inspect $name | jq
    '

	sudo nerdctl volume ls | fzf --ansi \
		--header-lines=1 \
		--preview "$preview_cmd" \
		--preview-window=right:60%:wrap \
		--header $'Volume Management | CTRL-R: reload\nCTRL-X: remove volume | CTRL-C: create volume' \
		--bind "ctrl-r:reload(sudo nerdctl volume ls)" \
		--bind "ctrl-x:execute(name=\$(echo {} | awk '{print \$2}'); sudo nerdctl volume rm \$name)" \
		--bind "ctrl-c:execute(read -p 'Volume name: ' vol && sudo nerdctl volume create \$vol)"
}

# Docker compose management
function ncomp() {
	local dir=${1:-.}

	# Make sure we have sudo permissions first
	check_sudo_nopass || sudo -v

	# Go to the directory containing compose file
	cd "$dir" || return 1

	local preview_cmd='
        service=$(echo {} | cut -d" " -f1)
        sudo nerdctl compose ps $service
        echo -e "\n\033[1;35mLogs:\033[0m\n"
        sudo nerdctl compose logs --tail 30 $service
    '

	if [[ -f "docker-compose.yml" ]] || [[ -f "compose.yml" ]]; then
		sudo nerdctl compose ps --services | fzf --ansi \
			--preview "$preview_cmd" \
			--preview-window=right:70%:wrap \
			--header $'Compose Management | CTRL-R: reload\nCTRL-U: up | CTRL-D: down | CTRL-L: logs\nCTRL-S: start | CTRL-X: stop | CTRL-B: build' \
			--bind "ctrl-r:reload(sudo nerdctl compose ps --services)" \
			--bind "ctrl-u:execute(sudo nerdctl compose up -d {})" \
			--bind "ctrl-d:execute(sudo nerdctl compose down {})" \
			--bind "ctrl-l:execute(sudo nerdctl compose logs --tail 1000 {} | less -R)" \
			--bind "ctrl-s:execute(sudo nerdctl compose start {})" \
			--bind "ctrl-x:execute(sudo nerdctl compose stop {})" \
			--bind "ctrl-b:execute(sudo nerdctl compose build {})"
	else
		echo "No docker-compose.yml or compose.yml found in $dir"
		return 1
	fi
}
