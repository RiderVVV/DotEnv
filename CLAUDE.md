# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a GNU Stow-based dotfiles management system with integrated 1Password CLI for secure secrets management. The repository uses a bare git repository approach with a custom `dot` command for managing dotfiles.

## Core Commands

### Dotfiles Management
```bash
# The dot command is an alias for git operations on the bare repository
dot status              # Check dotfiles repository status
dot add <file>          # Add file to dotfiles tracking
dot commit -m "message" # Commit changes
dot push               # Push to remote repository
dot diff               # Show uncommitted changes
```

### GNU Stow Package Management
```bash
# Use the stow-manager.sh script to manage configuration packages
./stow-manager.sh status              # Show status of all packages
./stow-manager.sh install             # Install all packages
./stow-manager.sh install shell git   # Install specific packages
./stow-manager.sh uninstall vscode    # Uninstall a package
./stow-manager.sh restow shell        # Reinstall a package
./stow-manager.sh list                # List available packages
```

### Secrets Management
```bash
# Initial 1Password setup
./scripts/setup-1password-secrets.sh  # Create 1Password entries

# Cache management (permanent caching - one auth, then cached forever)
./scripts/manage-secrets-cache.sh status   # Check cache status
./scripts/manage-secrets-cache.sh refresh  # Manually refresh secrets (triggers auth)
./scripts/manage-secrets-cache.sh clear    # Clear cache
```

## Architecture

### Repository Structure
- **Bare repository**: Located at `~/.dotfiles/`
- **Working tree**: Home directory (`$HOME`)
- **Package organization**: Each tool/application has its own directory (shell/, git/, vim/, etc.)
- **Stow management**: GNU Stow creates symlinks from packages to home directory

### Available Packages
- `shell/` - Shell configurations (.zshrc, .bash_profile, .p10k.zsh)
- `git/` - Git configuration (.gitconfig with aliases)
- `vim/` - Vim configuration (.vimrc)
- `vscode/` - VSCode settings
- `ghostty/` - Ghostty terminal configuration
- `zed/` - Zed editor configuration
- `cursor/` - Cursor editor configuration (special handling for spaces in paths)
- `secrets/` - Secrets template files for 1Password

### Security Features
- **Pre-commit hook**: Prevents committing sensitive patterns (AKIA, sk-ant, password, sshpass)
- **Git excludes**: .zsh.secrets, .secrets.d/, .ssh/, .m2/settings.xml
- **1Password integration**: Encrypted storage with permanent caching mechanism
- **Zero-popup experience**: Secrets cached permanently until manual refresh

### Key Shell Configuration
- **Framework**: oh-my-zsh with git plugin
- **Theme**: Powerlevel10k
- **Container aliases**: dnginx, dphp, dmysql, dredis (Docker containers)
- **Server functions**: wise(), maa(), test() for SSH connections
- **Development paths**: Go, Python, Node.js, Conda environments
- **Secrets loading**: Automatic from ~/.zsh.secrets on shell startup

## Important Notes

### Working with Cursor Configuration
The Cursor editor requires special handling due to paths with spaces. Use the dedicated script:
```bash
./scripts/stow-cursor.sh  # Special stow script for Cursor
```

### Git Configuration
The repository includes comprehensive git aliases and optimizations:
- Aliases: st (status), ci (commit), co (checkout), br (branch), lg (log graph)
- Large repository optimizations enabled
- Beyond Compare integration for diffs/merges

### Secrets Workflow
1. Secrets are stored in 1Password with tag "dotfiles"
2. Permanent cache means one-time authentication
3. Manual refresh required when secrets change in 1Password
4. Graceful fallback to local .env files if 1Password unavailable

## Development Workflow

When making changes to dotfiles:
1. Edit files directly in their normal locations
2. Use `dot add <file>` to track changes
3. Use `dot commit -m "message"` to commit
4. Use `dot push` to sync to remote

When adding new configuration packages:
1. Create new directory in ~/.dotfiles/
2. Structure it to mirror home directory paths
3. Use `./stow-manager.sh install <package>` to create symlinks
4. Add and commit the new package with dot commands