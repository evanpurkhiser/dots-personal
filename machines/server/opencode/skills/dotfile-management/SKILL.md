# Dotfile Management Skill

Manage Evan's dotfiles using the `dots` utility for organizing and installing configuration files.

## Overview

Dotfiles are managed in `/home/evan/.local/etc` (this repository) using the `dots` utility. The workflow is:

1. Edit configuration files in the appropriate group
2. Run `dots install` to install/update configs
3. Test the changes
4. Repeat until satisfied
5. Commit with descriptive message

## Repository Structure

```
/home/evan/.local/etc/
├── base/              # Core configs for all environments
├── common/            # Platform-specific (osx/linux) and development configs
└── machines/          # Machine-specific configurations
    ├── home/          # Home machine configs
    ├── work/          # Work machine configs
    └── server/        # Server machine configs (current machine)
```

## Active Configuration

Check current profile and groups:
```bash
~/.local/bin/dots config active
```

Current setup:
- Profile: `server`
- Groups: `base` + `machines/server`

## Common Commands

### View what will be installed
```bash
~/.local/bin/dots files
```

### See differences before installing
```bash
~/.local/bin/dots diff
```

### Install/update dotfiles
```bash
~/.local/bin/dots install
```

### List available profiles
```bash
~/.local/bin/dots config profiles
```

### Switch profile (rare)
```bash
~/.local/bin/dots config use <profile>
```

## File Installation

- Default install path: `$HOME/.config` (follows XDG Base Directory Standard)
- Files can have `.install` scripts that run after installation
- Files can have `.override` suffix to completely replace base files
- Files without `.override` are appended/merged with base files

## Workflow Guidelines

### When editing configs:

1. **Identify the right group**:
   - `base/` - Used across ALL machines (bash, vim, etc.)
   - `common/development/` - Development tools
   - `common/platform-osx/` - macOS-specific
   - `machines/server/` - This server only

2. **Edit the config file** in the appropriate location

3. **Install and test**:
   ```bash
   ~/.local/bin/dots install
   # Test the changes
   ```

4. **Repeat** until satisfied

5. **Commit** with clear message:
   ```bash
   git add <files>
   git commit -m "<component>: <what changed>"
   # Examples:
   # "vim: Add stage hunk action"
   # "bash: Add ft alias for running pnpm test"
   # "atuin: Use direct server:7070 endpoint"
   ```

### When asked to modify dotfiles:

- **DO**: Iterate with `dots install` between changes to test
- **DO**: Use simple, descriptive commit messages
- **DO**: Edit files in the source groups, not in ~/.config directly
- **DON'T**: Commit until changes are tested and working
- **DON'T**: Change profiles/groups unless explicitly needed (rare)

## Examples

### Adding a bash alias
1. Edit `base/bash/aliases` or `machines/server/bash/aliases`
2. Run `~/.local/bin/dots install`
3. Test: `source ~/.config/bash/aliases`
4. Commit: `git commit -m "bash: Add new alias for X"`

### Updating vim config
1. Edit `base/vim/vimrc`
2. Run `~/.local/bin/dots install`
3. Test: Open vim and verify
4. Commit: `git commit -m "vim: Add/update X configuration"`

### Server-specific config
1. Edit or create file in `machines/server/`
2. Run `~/.local/bin/dots install`
3. Test the changes
4. Commit: `git commit -m "<tool>: Server-specific X"`

## Important Notes

- The `dots` binary is at `~/.local/bin/dots`
- Configuration groups cascade (later groups extend/override earlier ones)
- Shebang lines are removed when files are merged/appended
- Installation scripts must be executable and have a shebang
- Always test with `dots install` before committing
