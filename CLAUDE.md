# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DR Custom Terminal is a modular macOS terminal customization toolkit written in Bash. It installs and configures Oh My ZSH, Nerd Fonts, Powerlevel10k, and various CLI productivity tools.

## Commands

### Main Installation
```bash
./install.sh              # Interactive installation
./install.sh minimal      # Quick minimal setup (Homebrew, Oh My ZSH, fonts, Powerlevel10k)
./install.sh developer    # Full developer setup (all utilities included)
```

### Module Management
Each module supports standalone execution:
```bash
./modules/utils/fzf.sh install    # Install specific module
./modules/utils/fzf.sh status     # Check installation status
./modules/utils/fzf.sh uninstall  # Remove module
./modules/utils/fzf.sh help       # Show module help
```

### Color Schemes
```bash
./themes/color-schemes/dracula.sh   # Install terminal color scheme
```

## Architecture

### Core Library Pattern
All scripts source core libraries from `core/`:
- `colors.sh` - ANSI color definitions and output formatting
- `ui.sh` - UI components (headers, dividers, spinners, confirmation prompts)
- `validators.sh` - Validation functions (`command_exists`, `is_macos`, `has_internet`, `has_brew`)
- `installers.sh` - Installation wrappers (`install_with_brew`, `install_with_cask`, `clone_repo`)
- `shell-config.sh` - ZSH configuration helpers (`add_to_zshrc`, `source_in_zshrc`, `add_alias_zshrc`)

Scripts must source from `PROJECT_ROOT`:
```bash
source "${PROJECT_ROOT}/core/colors.sh"
source "${PROJECT_ROOT}/core/ui.sh"
source "${PROJECT_ROOT}/core/validators.sh"
source "${PROJECT_ROOT}/core/installers.sh"
```

### Module Structure
Modules follow a standard template with:
- `MODULE_NAME`, `MODULE_VERSION`, `MODULE_DEPS` metadata
- Required functions: `check_dependencies()`, `is_installed()`, `install()`, `configure()`, `uninstall()`, `show_status()`, `show_help()`
- Main entry point with command handling (`install`, `status`, `uninstall`, `help`)
- Guard pattern: `[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"`

### Directory Structure
- `modules/base/` - Foundation (xcode-cli, homebrew)
- `modules/shell/` - Shell frameworks (oh-my-zsh)
- `modules/fonts/` - Nerd fonts
- `modules/prompt/` - Prompt themes (powerlevel10k, starship)
- `modules/plugins/` - ZSH plugins
- `modules/utils/` - CLI utilities (fzf, bat, eza, ripgrep, fd, zoxide, delta, lazygit, btop, neofetch)
- `profiles/` - Installation profiles that orchestrate module installation

### Coding Conventions
- All scripts use `set -euo pipefail` for strict error handling
- Source prevention pattern: `[[ -n "${_LIB_SH_LOADED:-}" ]] && return 0`
- Log file: `.install.log` in project root
- Use core library functions for output (never raw `echo` for user messages)
