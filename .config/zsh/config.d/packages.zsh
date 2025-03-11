function pkinstall() {
  local pkg=$(apt-cache search . | fzf --multi --preview='apt-cache show {1}' | awk '{print $1}')
  [[ -n $pkg ]] && sudo apt install "$pkg"
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
      pkg_remove_cmd="sudo apt remove -y {}"
      pkg_upgrade_cmd="sudo apt install --only-upgrade -y {}"
      ;;
    pacman)
      pkg_list_cmd="pacman -Qq"
      pkg_preview_cmd="pacman -Qi {}"
      pkg_remove_cmd="sudo pacman -Rns --noconfirm {}"
      pkg_upgrade_cmd="sudo pacman -Syu --noconfirm {}"
      ;;
    dnf)
      pkg_list_cmd="dnf list installed | awk 'NR>1 {print \$1}'"
      pkg_preview_cmd="dnf info {}"
      pkg_remove_cmd="sudo dnf remove -y {}"
      pkg_upgrade_cmd="sudo dnf upgrade -y {}"
      ;;
    *)
      echo "Unsupported package manager."
      return 1
      ;;
  esac

  check_sudo_nopass || sudo -v

  local selected_package=$(eval "$pkg_list_cmd" | fzf --ansi \
    --preview="$pkg_preview_cmd" \
    --header="Packages | CTRL-U: Uninstall | CTRL-G: Upgrade" \
    --bind="ctrl-u:execute($pkg_remove_cmd)+reload($pkg_list_cmd)" \
    --bind="ctrl-g:execute($pkg_upgrade_cmd)+reload($pkg_list_cmd)"
  )

  if [[ -n "$selected_package" ]]; then
    eval "$pkg_preview_cmd \"$selected_package\" | less -R"
  fi
}

# Helper function to detect package manager
function get_package_manager() {
  if command -v apt &>/dev/null; then
    echo "apt"
  elif command -v pacman &>/dev/null; then
    echo "pacman"
  elif command -v dnf &>/dev/null; then
    echo "dnf"
  else
    echo "unknown"
  fi
}

