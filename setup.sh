#!/bin/bash
# VS Code Settings Migration Script
# One-click setup for VS Code settings and extensions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# VS Code settings directory (macOS)
VSCODE_DIR="$HOME/Library/Application Support/Code/User"

# Backup directory
BACKUP_DIR="$HOME/.vscode-backups/$(date +%Y%m%d_%H%M%S)"

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           VS Code Settings Migration Script               ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}▸ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

backup_settings() {
    print_step "Backing up current settings..."
    mkdir -p "$BACKUP_DIR"
    
    if [ -f "$VSCODE_DIR/settings.json" ]; then
        cp "$VSCODE_DIR/settings.json" "$BACKUP_DIR/settings.json"
        print_step "Settings backed up to $BACKUP_DIR"
    fi
    
    # Backup keybindings if exists
    if [ -f "$VSCODE_DIR/keybindings.json" ]; then
        cp "$VSCODE_DIR/keybindings.json" "$BACKUP_DIR/keybindings.json"
    fi
    
    # Backup snippets if exists
    if [ -d "$VSCODE_DIR/snippets" ] && [ "$(ls -A "$VSCODE_DIR/snippets" 2>/dev/null)" ]; then
        cp -r "$VSCODE_DIR/snippets" "$BACKUP_DIR/snippets"
    fi
}

install_extensions() {
    print_step "Installing extensions..."
    
    if [ ! -f "$SCRIPT_DIR/extensions.list" ]; then
        print_error "extensions.list not found!"
        exit 1
    fi
    
    local total=$(wc -l < "$SCRIPT_DIR/extensions.list" | tr -d ' ')
    local current=0
    
    while IFS= read -r extension; do
        if [ -n "$extension" ]; then
            current=$((current + 1))
            echo -ne "\r${BLUE}Installing extension $current/$total: $extension${NC}"
            code --install-extension "$extension" --force 2>/dev/null || true
        fi
    done < "$SCRIPT_DIR/extensions.list"
    
    echo ""
    print_step "Extensions installation complete!"
}

apply_settings() {
    print_step "Applying settings..."
    
    if [ ! -f "$SCRIPT_DIR/settings.json" ]; then
        print_error "settings.json not found!"
        exit 1
    fi
    
    # Ensure directory exists
    mkdir -p "$VSCODE_DIR"
    
    # Copy settings
    cp "$SCRIPT_DIR/settings.json" "$VSCODE_DIR/settings.json"
    print_step "Settings applied successfully!"
}

main() {
    print_header
    
    echo -e "${BLUE}This script will:${NC}"
    echo "  1. Backup your current VS Code settings"
    echo "  2. Install all extensions from extensions.list"
    echo "  3. Apply settings from settings.json"
    echo ""
    
    read -p "Do you want to continue? (y/N) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        exit 0
    fi
    
    echo ""
    backup_settings
    echo ""
    install_extensions
    echo ""
    apply_settings
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Setup Complete!                              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Please restart VS Code to apply all changes.${NC}"
    echo ""
    echo -e "Backup location: ${BLUE}$BACKUP_DIR${NC}"
    echo ""
}

main "$@"
