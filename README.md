# VS Code Settings

One-click migration for VS Code settings and extensions.

## Features

- Backup current settings before applying new ones
- Install all extensions automatically
- Apply custom settings.json
- Restore from backup if needed

## Usage

### Installation

Download and run the setup script:

**via curl**

```bash
/bin/bash -c "$(curl -fL https://raw.githubusercontent.com/YOUR_USERNAME/vscode-settings/HEAD/setup.sh)"
```

**via git**

```bash
# Clone the repository
git clone --depth=1 https://github.com/YOUR_USERNAME/vscode-settings.git

# Run the setup script
cd vscode-settings
bash setup.sh
```

### Options

The setup script will:

1. Backup your current settings to `~/.vscode-backups/<DATETIME>`
2. Install all extensions from `extensions.list`
3. Apply settings from `settings.json`

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

### Update Extensions

To update the extensions list after installing new extensions:

```bash
code --list-extensions > extensions.list
```

### Update Settings

After making changes to your VS Code settings, copy the updated `settings.json`:

```bash
cp "$HOME/Library/Application Support/Code/User/settings.json" settings.json
```

### Update extensions.json

The `extensions.json` file is used for VS Code's recommendations format. Update it when you add new extensions:

```bash
# Convert extensions.list to extensions.json format
echo '{"recommendations": [' > extensions.json
sed 's/.*/"&",/' extensions.list >> extensions.json
sed -i '' '$ s/,$//' extensions.json
echo ']}' >> extensions.json
```

## Files

| File | Description |
|------|-------------|
| `settings.json` | VS Code settings |
| `extensions.list` | List of extensions (one per line) |
| `extensions.json` | Extensions in VS Code recommendations format |
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

### Extensions not installing

If extensions fail to install, try:

```bash
# Force reinstall
code --install-extension <extension-id> --force
```

### Settings not applying

1. Restart VS Code
2. Check for JSON syntax errors in `settings.json`
3. Verify the file is in the correct location:
   - macOS: `~/Library/Application Support/Code/User/settings.json`
   - Linux: `~/.config/Code/User/settings.json`
   - Windows: `%APPDATA%\Code\User\settings.json`

## License

MIT
