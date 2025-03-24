# Color Themes
alias light='colorschemeswitcher solarized'
alias dark='colorschemeswitcher dark'
alias gruv='colorschemeswitcher gruvbox'

function colorschemeswitcher() {
	if [ "$1" = "solarized" ]; then
		touch ~/.lightmode
		base16_solarized-light
		[ -f ~/.zi/plugins/tinted-theming---tinted-fzf/bash/base16-$BASE16_THEME.config ] && source ~/.zi/plugins/tinted-theming---tinted-fzf/bash/base16-$BASE16_THEME.config
		export BAT_THEME="Solarized (light)"
		change_zellij_theme "solarized-light"
		change_k9s_theme "solarized_light"
	elif [ "$1" = "gruvbox" ]; then
		rm -f ~/.lightmode
		base16_gruvbox-dark-medium
		[ -f ~/.zi/plugins/tinted-theming---tinted-fzf/bash/base16-$BASE16_THEME.config ] && source ~/.zi/plugins/tinted-theming---tinted-fzf/bash/base16-$BASE16_THEME.config
		export BAT_THEME="gruvbox-dark"
		change_zellij_theme "gruvbox"
	else
		rm -f ~/.lightmode
		[ -f ~/.config/base16/base16-tokyo-night.config ] && source ~/.config/base16/base16-tokyo-night.config
		[ -f $HOME/.config/base16/base16-tokyo-night.sh ] && source $HOME/.config/base16/base16-tokyo-night.sh
		export BAT_THEME="OneHalfDark"
		change_zellij_theme "tokyo-night-dark"
		change_k9s_theme "nord"
	fi
}

function change_zellij_theme() {
	if [ "$#" -ne 1 ]; then
		echo "Usage: change_zellij_theme <new-theme>"
		return 1
	fi

	CONFIG_FILE="$HOME/.config/zellij/config.kdl"
	NEW_THEME="$1"

	if [ ! -f "$CONFIG_FILE" ]; then
		echo "Configuration file not found: $CONFIG_FILE"
		return 1
	fi

	# Use sed to replace the theme line
	sed -i.bak "s/^theme \".*\"$/theme \"$NEW_THEME\"/" "$CONFIG_FILE"
}

function change_k9s_theme() {
	if [ "$#" -ne 1 ]; then
		echo "Usage: change_k9s_theme <new-theme>"
		return 1
	fi
	CONFIG_FILE="$HOME/.config/k9s/config.yaml"
	NEW_THEME="$1"

	if [ ! -f "$CONFIG_FILE" ]; then
		echo "Configuration file not found: $CONFIG_FILE"
		return 1
	fi

	# Use sed to replace the skin line, considering the nested structure
	sed -i.bak 's/^ *skin: .*$/    skin: '"$NEW_THEME"'/' "$CONFIG_FILE"
}

function darkmodechecker() {
	# Check if the AppsUseLightTheme registry key exists and its value is 1
	# if /mnt/c/Windows/System32/reg.exe query 'HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' /v AppsUseLightTheme | grep -q '0x1'; then
	if [ -f ~/.lightmode ]; then
		# If the registry key value is 1, execute "light"
		light
	else
		# If the registry key value is not 1, execute "dark"
		dark
	fi
}

# run DarkMode Check if we're not on an SSH connection
if [[ -z "$SSH_CONNECTION" ]]; then
	darkmodechecker
else
	if [[ -f ~/.lightmode ]]; then
		light
	else
		dark
	fi
fi
