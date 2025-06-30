function pkinstall() {
	pacman -Ss --color=always | rg '^[^ ]' | fzf --ansi --multi --preview 'pacman --color=always -Si {1}' | awk '{print $1}' | xargs -ro sudo pacman -S
}

function pklist() {
	pacman -Qq --color=always | fzf --ansi --multi --preview 'pacman --color=always -Qi {}' | xargs -ro sudo pacman -Rs
}

function yaylist() {
	yay -Qm --color=always | fzf --ansi --multi --preview 'yay --color=always -Qi {1}' | awk '{print $1}' | xargs -ro yay -Rs
}

function yayinstall() {
	yay -s --color=always | rg '^[^ ]' | fzf --ansi --multi --preview 'yay --color=always -Si {1}' | awk '{print $1}' | xargs -ro yay -S
}

