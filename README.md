# Dotfiles

My personal dotfiles and configuration files.

## Structure

```
dotfiles/
├── .bashrc                   # Bash configuration
├── .config/                  # Application configs
│   ├── base16/               # Base16 color themes
│   ├── btop/                 # Btop++ settings
│   ├── direnv/               # Direnv settings
│   ├── fzf/                  # FZF key bindings and completions
│   ├── k9s/                  # K9s Kubernetes UI config
│   ├── lazygit/              # Lazygit config
│   ├── navi/                 # Navi cheatsheet tool config
│   ├── nvim/                 # Neovim config
│   ├── procs/                # Process viewer config
│   ├── yamlfmt/              # YAML formatter settings
│   ├── yamllint/             # YAML linter settings
│   ├── zellij/               # Zellij terminal multiplexer config
│   ├── zi/                   # Zi plugin manager config
│   └── zsh/                  # ZSH configurations
│       ├── completions/      # ZSH completions
│       └── config.d/         # Modular ZSH config files
├── .prettierrc               # Prettier formatter config
├── .tmux.conf                # Tmux configuration
├── .zshrc                    # ZSH main configuration
└── CLAUDE.md                 # Guidelines for Claude AI when working with this repo
```

## Installation

### Automatic Installation

The repository includes a bootstrap script that handles all installation steps:

```bash
# Method 1: Clone and run bootstrap script
git clone https://github.com/kevinzehnder/dotfiles.git
cd dotfiles
./bootstrap.sh

# Method 2: Direct install (one-liner)
curl -fsSL https://raw.githubusercontent.com/kevinzehnder/dotfiles/master/bootstrap.sh | bash
```

The bootstrap script:
- Detects your OS (Debian/Ubuntu or RHEL/Fedora)
- Installs required system packages
- Sets up Golang, Starship prompt, and Devbox
- Creates the proper directory structure
- Backs up any existing dotfiles
- Sets ZSH as your default shell
- Configures dotfiles using a git bare repository

### Manual Installation

If you prefer to install manually:

```bash
# Clone the bare repository
git clone --bare https://github.com/kevinzehnder/dotfiles.git $HOME/.cfg

# Define the config alias 
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Checkout the actual files
config checkout

# If there are conflicts, back up the originals and try again
# config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} {}.bak
# config checkout

# Hide untracked files
config config status.showUntrackedFiles no
```

## Features

- Modular ZSH configuration with Zi plugin manager:
  - `plugins.zsh` - Plugin management with Zi
  - `aliases.zsh` - All shell aliases in one place
  - `environment.zsh` - Environment variables and paths
  - `options.zsh` - ZSH shell options
  - `keybindings.zsh` - Keyboard shortcuts
  - `completion.zsh` - Completion settings
  - Additional tool-specific configs in separate files
- Extensive Neovim configuration with LSP support
- Customized Tmux configuration
- Various CLI tool configurations
- Kubernetes tool configurations
- Custom ZSH functions and aliases

## Key Tools

- **Shell**: ZSH with Zi plugin manager
- **Terminal Multiplexers**: Tmux, Zellij
- **Editor**: Neovim
- **Git UI**: Lazygit
- **File Navigation**: fzf, eza
- **Kubernetes**: k9s, kubectl
- **Container Tools**: Docker, Nerdctl

## License

MIT
