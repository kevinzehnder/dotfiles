function pkinstall() {
	local pkg_mgr=$(get_package_manager)
	local cache_file="/tmp/.pkgcache_${pkg_mgr}"
	local cache_duration=3600 # cache threshold: 1 hour

	local pkg_search_cmd pkg_preview_cmd pkg_install_cmd pkg_update_cmd

	case "$pkg_mgr" in
		apt)
			pkg_search_cmd="apt-cache search ."
			pkg_preview_cmd="apt-cache show {1}"
			pkg_install_cmd="sudo apt install -y"
			pkg_update_cmd="sudo apt update"
			;;
		pacman)
			pkg_search_cmd="pacman -Ss | awk '/^[^ ]/ {print \$1}'"
			pkg_preview_cmd="pacman -Si {1}"
			pkg_install_cmd="sudo pacman -S --noconfirm"
			pkg_update_cmd="sudo pacman -Sy"
			;;
		dnf)
			pkg_search_cmd="dnf search all"
			pkg_preview_cmd="dnf info {1}"
			pkg_install_cmd="sudo dnf install -y"
			pkg_update_cmd="sudo dnf makecache"
			;;
		*)
			echo "Unsupported package manager."
			return 1
			;;
	esac

	check_sudo_nopass || sudo -v

	# Refresh cache if old or nonexistent
	if [[ ! -f "$cache_file" || $(($(date +%s) - $(stat -c %Y "$cache_file"))) -gt $cache_duration ]]; then
		echo "🟡 Updating package cache..."
		eval "$pkg_update_cmd"
		touch "$cache_file"
	fi

	local pkgs=$(eval "$pkg_search_cmd" \
		| fzf --multi \
			--preview="$pkg_preview_cmd" \
			--header="Select packages to install" \
		| awk '{print $1}')

	[[ -n "$pkgs" ]] && eval "$pkg_install_cmd $pkgs"
}

function pklist() {
	local pkg_mgr=$(get_package_manager)

	local pkg_list_cmd
	local pkg_preview_cmd
	local pkg_remove_cmd
	local pkg_upgrade_cmd

	case "$pkg_mgr" in
		apt)
			pkg_list_cmd="apt list --installed | awk -F'/' 'NR>1 {print \$1}'"
			pkg_preview_cmd="apt show {}"
			pkg_remove_cmd="sudo apt remove {}"
			pkg_upgrade_cmd="sudo apt install --only-upgrade {}"
			;;
		pacman)
			pkg_list_cmd="pacman -Qq"
			pkg_preview_cmd="pacman -Qi {}"
			pkg_remove_cmd="sudo pacman -Rns {}"
			pkg_upgrade_cmd="sudo pacman -Syu {}"
			;;
		dnf)
			pkg_list_cmd="dnf list installed | awk 'NR>1 {print \$1}'"
			pkg_preview_cmd="dnf info {}"
			pkg_remove_cmd="sudo dnf remove {}"
			pkg_upgrade_cmd="sudo dnf upgrade {}"
			;;
		*)
			echo "Unsupported package manager."
			return 1
			;;
	esac

	check_sudo_nopass || sudo -v

	local selected_package=$(
		eval "$pkg_list_cmd" | fzf --ansi \
			--preview="$pkg_preview_cmd" \
			--header="Packages | CTRL-U: Uninstall | CTRL-G: Upgrade" \
			--bind="ctrl-u:execute($pkg_remove_cmd)+reload($pkg_list_cmd)" \
			--bind="ctrl-g:execute($pkg_upgrade_cmd)+reload($pkg_list_cmd)"
	)

	if [[ -n "$selected_package" ]]; then
		eval "$pkg_preview_cmd \"$selected_package\" | less -R"
	fi
}
