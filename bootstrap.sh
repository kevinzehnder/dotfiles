#!/bin/bash

# Dotfiles bootstrap script with improved structure
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display a confirmation prompt with colored output
confirm_execution() {
    echo -e "\033[1;33mWARNING: This script will install packages and configure your environment.\033[0m"
    echo -e "\033[1;36mDo you really want to proceed? (y/n):\033[0m \c"
    read -r response
    if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "\033[1;31mOperation aborted.\033[0m"
        exit 1
    fi
}

# Function to install required packages
install_packages() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" == "ubuntu" ] || [ "$ID" == "debian" ]; then
            echo -e "\033[1;32mInstalling required packages for Debian-based systems...\033[0m"
            sudo apt-get update && sudo apt-get install -y unzip git gcc vim zsh bzip2 libfuse2 make direnv
        elif [ "$ID" == "fedora" ] || [ "$ID" == "rhel" ] || [ "$ID" == "centos" ] || [ "$ID" == "almalinux" ]; then
            echo -e "\033[1;32mInstalling required packages for RHEL-based systems...\033[0m"
            sudo dnf update && sudo dnf install -y fuse-libs zsh git unzip bzip2 util-linux-user fuse gcc make direnv
        else
            echo -e "\033[1;31mUnsupported Linux distribution: $ID\033[0m"
            exit 1
        fi
    else
        echo -e "\033[1;31mCannot determine Linux distribution\033[0m"
        exit 1
    fi
}

# Function to clone dotfiles repository
clone_dotfiles() {
    if [ ! -d "$HOME/.cfg" ]; then
        echo -e "${GREEN}Cloning dotfiles...${NC}"
        git clone --bare https://github.com/kevinzehnder/dotfiles $HOME/.cfg
    else
        echo -e "${YELLOW}.cfg directory already exists. Skipping clone.${NC}"
    fi
}

# Function to create a backup of existing dotfiles
backup_dotfiles() {
    local backup_dir="$HOME/.config-backup/$(date +%Y%m%d%H%M%S)"
    mkdir -p "$backup_dir"
    echo -e "${BLUE}Backing up to $backup_dir${NC}"
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | while read file; do
        mkdir -p "$backup_dir/$(dirname $file)"
        mv "$HOME/$file" "$backup_dir/$file"
    done
}

# Setup function for zi plugin manager
setup_zi() {
    if [ ! -d "$HOME/.config/zi/bin" ]; then
        echo -e "${GREEN}Setting up zi plugin manager...${NC}"
        mkdir -p "$HOME/.config/zi"
        git clone https://github.com/z-shell/zi.git "$HOME/.config/zi/bin"
    else
        echo -e "${YELLOW}Zi plugin manager already installed.${NC}"
    fi
}

# Install starship prompt
install_starship() {
    if ! command -v starship &> /dev/null; then
        echo -e "${GREEN}Installing Starship prompt...${NC}"
        curl -o starship.sh -sS https://starship.rs/install.sh
        chmod +x starship.sh
        sudo ./starship.sh -y
        rm starship.sh
    else
        echo -e "${YELLOW}Starship already installed.${NC}"
    fi
}

# Install devbox
install_devbox() {
    if ! command -v devbox &> /dev/null; then
        echo -e "${GREEN}Installing Devbox...${NC}"
        curl -fsSL https://get.jetify.com/devbox | bash
    else
        echo -e "${YELLOW}Devbox already installed.${NC}"
    fi
}

# Install golang
install_golang() {
    if ! command -v go &> /dev/null; then
        echo -e "${GREEN}Installing Go...${NC}"
        curl -o go.tar.gz https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
        sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz
        rm go.tar.gz
        echo -e "${GREEN}Go installed successfully.${NC}"
    else
        echo -e "${YELLOW}Go already installed.${NC}"
    fi
}

# Ensure ZSH configuration directory structure
setup_zsh_structure() {
    echo -e "${GREEN}Setting up ZSH configuration structure...${NC}"
    mkdir -p "$HOME/.config/zsh/config.d"
    mkdir -p "$HOME/.config/zsh/completions"
}

# Define config function for git bare repo
function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

# Main installation function
main() {
    # Display confirmation prompt
    confirm_execution
    
    # Install base dependencies
    install_packages
    install_golang
    install_starship
    install_devbox
    setup_zi
    setup_zsh_structure
    
    # Clone and configure dotfiles
    clone_dotfiles
    
    # Checkout dotfiles
    echo -e "${GREEN}Checking out dotfiles...${NC}"
    config checkout -f
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Checked out config.${NC}"
    else
        echo -e "${YELLOW}Conflicts detected, backing up existing files.${NC}"
        backup_dotfiles
        config checkout -f
    fi
    
    # Configure git bare repo to hide untracked files
    config config status.showUntrackedFiles no
    
    # Set ZSH as default shell if it's not already
    if [ "$SHELL" != "$(which zsh)" ]; then
        echo -e "${GREEN}Setting ZSH as default shell...${NC}"
        chsh -s $(which zsh)
    fi
    
    echo -e "${GREEN}Installation complete! Please restart your shell.${NC}"
    echo -e "${BLUE}To access your dotfiles configuration, use:${NC}"
    echo -e "  ${YELLOW}config status${NC} - Show status of dotfiles"
    echo -e "  ${YELLOW}config add${NC} - Add files to dotfiles repo"
    echo -e "  ${YELLOW}config commit${NC} - Commit changes"
    echo -e "  ${YELLOW}config push${NC} - Push changes to remote"
}

# Run the main function
main