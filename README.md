# VS Code Settings

Independent backup, migration, and restore workflow for VS Code user settings.

## Features

- Backup current settings before applying new ones
- Apply custom settings.json
- Restore from backup if needed

## Usage

### Installation

Download and run the setup script:

**via curl**

```bash
/bin/bash -c "$(curl -fL https://raw.githubusercontent.com/whdgmjsh/vscode-settings/HEAD/setup.sh)"
```

**via git**

```bash
# Clone the repository
git clone --depth=1 https://github.com/whdgmjsh/vscode-settings.git

# Run the setup script
cd vscode-settings
bash setup.sh
```

### Options

The setup script will:

1. Backup current settings to `~/.vscode-backups/<DATETIME>`
2. Apply `settings.json`

### Rollback

To restore from a backup:

```bash
# Interactive mode - shows available backups
bash restore.sh

# Restore latest backup
bash restore.sh --latest

# Restore specific backup
bash restore.sh ~/.vscode-backups/20240101_120000
```

## Customization

### Extensions

Extensions are intentionally not stored in this repository. Manage them as
`vscode` entries in the dotfiles `Brewfile`, then install them with
`brew bundle`.

### Update Settings

After making changes to your VS Code settings, copy the updated `settings.json`:

```bash
cp "$HOME/Library/Application Support/Code/User/settings.json" settings.json
```

## Files

| File | Description |
|------|-------------|
| `settings.json` | VS Code settings |
| `setup.sh` | Installation script |
| `restore.sh` | Restore from backup script |

## Backup Location

Backups are stored in:

```
~/.vscode-backups/<DATETIME>/
├── settings.json
├── keybindings.json (if exists)
└── snippets/ (if exists)
```

## Troubleshooting

### Settings not applying

1. Restart VS Code
2. Check for JSON syntax errors in `settings.json`
3. Verify the file is in the correct location:
   - macOS: `~/Library/Application Support/Code/User/settings.json`
   - Linux: `~/.config/Code/User/settings.json`
   - Windows: `%APPDATA%\Code\User\settings.json`

## License

MIT
