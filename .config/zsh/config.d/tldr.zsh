
alias tldrf="tldr --list | fzf --ansi --preview 'script -qec \"tldr {1}\"' --height=80% --preview-window=right,60% | xargs tldr"

