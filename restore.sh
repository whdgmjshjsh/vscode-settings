#!/bin/bash
# VS Code Settings Restore Script
# Restore from backup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# VS Code settings directory (macOS)
VSCODE_DIR="$HOME/Library/Application Support/Code/User"

# Backup base directory
BACKUP_BASE="$HOME/.vscode-backups"

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           VS Code Settings Restore Script                 ║${NC}"
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

list_backups() {
    if [ ! -d "$BACKUP_BASE" ]; then
        print_error "No backups found in $BACKUP_BASE"
        exit 1
    fi
    
    echo -e "${BLUE}Available backups:${NC}"
    echo ""
    
    local backups=()
    for dir in "$BACKUP_BASE"/*/; do
        if [ -d "$dir" ]; then
            local dirname=$(basename "$dir")
            backups+=("$dirname")
            echo "  - $dirname"
        fi
    done
    
    if [ ${#backups[@]} -eq 0 ]; then
        print_error "No backups found!"
        exit 1
    fi
    
    echo ""
}

restore_backup() {
    local backup_dir="$1"
    
    if [ ! -d "$backup_dir" ]; then
        print_error "Backup directory not found: $backup_dir"
        exit 1
    fi
    
    print_step "Restoring from $backup_dir..."
    
    # Restore settings
    if [ -f "$backup_dir/settings.json" ]; then
        cp "$backup_dir/settings.json" "$VSCODE_DIR/settings.json"
        print_step "Settings restored"
    fi
    
    # Restore keybindings
    if [ -f "$backup_dir/keybindings.json" ]; then
        cp "$backup_dir/keybindings.json" "$VSCODE_DIR/keybindings.json"
        print_step "Keybindings restored"
    fi
    
    # Restore snippets
    if [ -d "$backup_dir/snippets" ]; then
        cp -r "$backup_dir/snippets" "$VSCODE_DIR/snippets"
        print_step "Snippets restored"
    fi
}

main() {
    print_header
    
    if [ "$1" = "--latest" ]; then
        # Find the latest backup
        local latest=$(ls -td "$BACKUP_BASE"/*/ 2>/dev/null | head -1)
        if [ -z "$latest" ]; then
            print_error "No backups found!"
            exit 1
        fi
        restore_backup "$latest"
    elif [ -n "$1" ]; then
        # Use provided path
        restore_backup "$1"
    else
        # Interactive mode
        list_backups
        
        read -p "Enter backup date (YYYYMMDD_HHMMSS) or 'latest': " backup_choice
        
        if [ "$backup_choice" = "latest" ]; then
            local latest=$(ls -td "$BACKUP_BASE"/*/ 2>/dev/null | head -1)
            if [ -z "$latest" ]; then
                print_error "No backups found!"
                exit 1
            fi
            restore_backup "$latest"
        else
            restore_backup "$BACKUP_BASE/$backup_choice"
        fi
    fi
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              Restore Complete!                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Please restart VS Code to apply all changes.${NC}"
    echo ""
}

main "$@"
