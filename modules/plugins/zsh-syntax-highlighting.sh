#!/usr/bin/env bash
# =============================================================================
# zsh-syntax-highlighting - Fish-like Syntax Highlighting for ZSH
# DR Custom Terminal
# =============================================================================
# Provides syntax highlighting for the shell zsh. It enables highlighting of
# commands whilst they are typed at a zsh prompt into an interactive terminal.
# This helps in reviewing commands before running them, particularly in
# catching syntax errors.
# =============================================================================

set -euo pipefail

# Get script directory for sourcing core libs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Source core libraries
source "${PROJECT_ROOT}/core/colors.sh"
source "${PROJECT_ROOT}/core/ui.sh"
source "${PROJECT_ROOT}/core/validators.sh"
source "${PROJECT_ROOT}/core/installers.sh"
source "${PROJECT_ROOT}/core/shell-config.sh"

# =============================================================================
# Module Metadata
# =============================================================================
MODULE_NAME="zsh-syntax-highlighting"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("git" "zsh")

# Plugin-specific configuration
PLUGIN_REPO="https://github.com/zsh-users/zsh-syntax-highlighting"
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
                 _                   _     _       _     _ _       _     _   _
  ___ _   _ _ __ | |_ __ ___  __    | |__ (_) __ _| |__ | (_) __ _| |__ | |_(_)_ __   __ _
 / __| | | | '_ \| __/ _` \ \/ /____| '_ \| |/ _` | '_ \| | |/ _` | '_ \| __| | '_ \ / _` |
 \__ \ |_| | | | | || (_| |>  <_____| | | | | (_| | | | | | | (_| | | | | |_| | | | | (_| |
 |___/\__, |_| |_|\__\__,_/_/\_\    |_| |_|_|\__, |_| |_|_|_|\__, |_| |_|\__|_|_| |_|\__, |
      |___/                                  |___/          |___/                   |___/
    Fish-like syntax highlighting for ZSH
EOF
    echo -e "${NC}"
    echo ""
}

# =============================================================================
# Dependency Check
# =============================================================================
check_dependencies() {
    local has_errors=0

    print_divider "Checking Dependencies"

    # Check for Oh My ZSH
    if ! has_omz; then
        print_error "Oh My ZSH is required but not installed"
        print_info "Install Oh My ZSH first: ${PROJECT_ROOT}/modules/shell/oh-my-zsh.sh"
        has_errors=1
    else
        print_success "Oh My ZSH installed"
    fi

    # Check for Git
    if ! command_exists git; then
        print_error "Git is required but not installed"
        has_errors=1
    else
        print_success "Git installed"
    fi

    echo ""
    return $has_errors
}

# =============================================================================
# Installation Status Check
# =============================================================================
is_installed() {
    [[ -d "$PLUGIN_DIR" && -f "${PLUGIN_DIR}/zsh-syntax-highlighting.zsh" ]]
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    if is_installed && [[ -d "${PLUGIN_DIR}/.git" ]]; then
        git -C "$PLUGIN_DIR" describe --tags --abbrev=0 2>/dev/null || \
        git -C "$PLUGIN_DIR" log -1 --format="%cd" --date=short 2>/dev/null || \
        echo "unknown"
    else
        echo "Not installed"
    fi
}

# =============================================================================
# Check Plugin Position in Plugins Array
# =============================================================================
check_plugin_position() {
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if [[ ! -f "$zshrc_path" ]]; then
        return 1
    fi

    # Extract plugins array and check if syntax-highlighting is last
    local plugins_line
    plugins_line=$(grep -E "^plugins=\(" "$zshrc_path" | head -1)

    if echo "$plugins_line" | grep -q "zsh-syntax-highlighting[[:space:]]*)" 2>/dev/null; then
        return 0  # Is last
    else
        return 1  # Not last or not present
    fi
}

# =============================================================================
# Ensure Plugin is Last in Array
# =============================================================================
ensure_plugin_last() {
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if [[ ! -f "$zshrc_path" ]]; then
        print_error "No .zshrc file found"
        return 1
    fi

    # Check if plugins line exists
    if ! grep -q "^plugins=(" "$zshrc_path"; then
        print_error "Could not find plugins=(...) in .zshrc"
        return 1
    fi

    # First, remove plugin if it exists
    remove_plugin_omz "zsh-syntax-highlighting"

    # Now add it at the end of the plugins array
    local temp_file
    temp_file="$(mktemp)"

    # Handle the plugins array - add zsh-syntax-highlighting right before the closing paren
    awk '
        /^plugins=\(/ {
            in_plugins=1
        }
        in_plugins && /\)/ {
            # Insert plugin before closing paren
            sub(/\)/, "zsh-syntax-highlighting)")
            in_plugins=0
        }
        { print }
    ' "$zshrc_path" > "$temp_file"

    mv "$temp_file" "$zshrc_path"

    print_success "Plugin added at end of plugins array (required position)"
    return 0
}

# =============================================================================
# Show Current Status
# =============================================================================
show_status() {
    print_divider "Current Status"

    echo -e "  ${ICON_BULLET} Plugin directory: ${DIM}${PLUGIN_DIR}${NC}"
    echo ""

    if is_installed; then
        local version
        version="$(get_version)"

        echo -e "  ${ICON_SUCCESS} ${GREEN}Installed${NC}"
        echo -e "  ${ICON_BULLET} Version: ${BOLD}${version}${NC}"
        echo ""

        # Check if plugin is enabled in .zshrc
        local zshrc_path
        zshrc_path="$(get_zshrc_path)"
        local plugins
        plugins=$(list_plugins_omz)

        if echo "$plugins" | grep -q "zsh-syntax-highlighting"; then
            print_success "Plugin is enabled in .zshrc"

            # Check if it's at the end (required)
            if check_plugin_position; then
                print_success "Plugin is correctly positioned (last in list)"
            else
                print_warning "Plugin should be LAST in the plugins array!"
                print_info "Move it to the end for proper functionality"
            fi
        else
            print_warning "Plugin is NOT enabled in .zshrc"
            print_info "Add 'zsh-syntax-highlighting' as the LAST plugin in your array"
        fi

        # Check for highlighters configuration
        if grep -q "ZSH_HIGHLIGHT_HIGHLIGHTERS" "$zshrc_path" 2>/dev/null; then
            local highlighters
            highlighters=$(grep "ZSH_HIGHLIGHT_HIGHLIGHTERS" "$zshrc_path" | head -1)
            echo -e "  ${ICON_BULLET} Highlighters: ${DIM}$(echo "$highlighters" | sed 's/.*=(//' | sed 's/).*//')${NC}"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Install Plugin
# =============================================================================
install() {
    print_divider "Installation"

    # Check for internet connectivity
    print_step 1 4 "Checking internet connection..."
    if ! has_internet; then
        print_error "No internet connection detected"
        return 1
    fi
    print_success "Internet connection available"

    # Check if already installed
    if is_installed; then
        print_info "Plugin already installed at $PLUGIN_DIR"
        if confirm "Reinstall (remove and clone fresh)?"; then
            print_info "Removing existing installation..."
            rm -rf "$PLUGIN_DIR"
        else
            return 0
        fi
    fi

    # Create custom plugins directory if needed
    print_step 2 4 "Preparing plugin directory..."
    local custom_plugins_dir
    custom_plugins_dir="$(dirname "$PLUGIN_DIR")"
    mkdir -p "$custom_plugins_dir"
    print_success "Plugin directory ready"

    # Clone the repository
    print_step 3 4 "Cloning zsh-syntax-highlighting..."
    if ! git clone --depth=1 "$PLUGIN_REPO" "$PLUGIN_DIR" 2>/dev/null; then
        print_error "Failed to clone repository"
        return 1
    fi
    print_success "Repository cloned successfully"

    # Add to plugins array in .zshrc (MUST be last)
    print_step 4 4 "Enabling plugin in .zshrc..."
    print_info "Note: This plugin MUST be last in the plugins array"
    ensure_plugin_last

    return 0
}

# =============================================================================
# Configure Plugin
# =============================================================================
configure() {
    print_divider "Configuration"

    if ! is_installed; then
        print_error "Plugin is not installed"
        return 1
    fi

    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Check and fix plugin position
    echo ""
    echo -e "${BOLD}Plugin Position Check${NC}"
    echo ""
    echo -e "  ${YELLOW}IMPORTANT:${NC} zsh-syntax-highlighting MUST be the last plugin"
    echo -e "  in your plugins array for proper functionality."
    echo ""

    if ! check_plugin_position; then
        if confirm "Fix plugin position (move to end of plugins array)?"; then
            ensure_plugin_last
        fi
    else
        print_success "Plugin is correctly positioned"
    fi

    # Configure highlighters
    echo ""
    echo -e "${BOLD}Highlighters Configuration${NC}"
    echo ""
    echo -e "  Available highlighters:"
    echo ""
    echo -e "  ${CYAN}main${NC}         Main syntax highlighting (required)"
    echo -e "  ${CYAN}brackets${NC}     Bracket matching"
    echo -e "  ${CYAN}pattern${NC}      User-defined patterns"
    echo -e "  ${CYAN}cursor${NC}       Cursor highlighting"
    echo -e "  ${CYAN}line${NC}         Entire command line highlighting"
    echo -e "  ${CYAN}root${NC}         Highlight when running as root"
    echo ""

    if confirm "Enable additional highlighters (brackets recommended)?" "y"; then
        local highlighters_line='ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)'

        if grep -q "^ZSH_HIGHLIGHT_HIGHLIGHTERS=" "$zshrc_path" 2>/dev/null; then
            local temp_file
            temp_file="$(mktemp)"
            sed "s|^ZSH_HIGHLIGHT_HIGHLIGHTERS=.*|${highlighters_line}|" "$zshrc_path" > "$temp_file"
            mv "$temp_file" "$zshrc_path"
            print_success "Updated highlighters configuration"
        else
            add_to_zshrc "$highlighters_line" "zsh-syntax-highlighting: enabled highlighters"
        fi
    fi

    # Custom styles (optional)
    echo ""
    if confirm "Configure custom highlight colors?" "n"; then
        echo ""
        echo -e "  ${BOLD}Color Style Options${NC}"
        echo ""
        echo -e "  Format: ZSH_HIGHLIGHT_STYLES[category]='style'"
        echo -e "  Example styles: fg=green, fg=red,bold, fg=#88c0d0"
        echo ""

        # Common style configurations for different themes
        if confirm "Apply Catppuccin-inspired colors?" "n"; then
            local styles=(
                "ZSH_HIGHLIGHT_STYLES[command]='fg=#89b4fa,bold'"
                "ZSH_HIGHLIGHT_STYLES[builtin]='fg=#89b4fa,bold'"
                "ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,bold'"
                "ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'"
                "ZSH_HIGHLIGHT_STYLES[path]='fg=#f9e2af,underline'"
                "ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a6e3a1'"
                "ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a6e3a1'"
                "ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8'"
            )

            echo "" >> "$zshrc_path"
            echo "# zsh-syntax-highlighting: custom styles (Catppuccin)" >> "$zshrc_path"
            for style in "${styles[@]}"; do
                echo "$style" >> "$zshrc_path"
            done
            print_success "Applied Catppuccin-inspired color scheme"
        fi
    fi

    # Show highlighting info
    echo ""
    print_divider "Highlighting Features"
    echo ""
    echo -e "  ${BOLD}What gets highlighted:${NC}"
    echo ""
    echo -e "  ${GREEN}green${NC}       Valid commands, aliases, functions"
    echo -e "  ${RED}red${NC}         Unknown commands / syntax errors"
    echo -e "  ${YELLOW}yellow${NC}      Paths and file references"
    echo -e "  ${CYAN}cyan${NC}        Comments and special characters"
    echo ""
    echo -e "  ${BOLD}Bracket matching:${NC} (if enabled)"
    echo ""
    echo -e "  Matching brackets are highlighted when cursor is on them."
    echo -e "  Unmatched brackets appear in bold red."
    echo ""

    return 0
}

# =============================================================================
# Update Plugin
# =============================================================================
update() {
    print_divider "Updating $MODULE_NAME"

    if ! is_installed; then
        print_error "Plugin is not installed"
        return 1
    fi

    if [[ ! -d "${PLUGIN_DIR}/.git" ]]; then
        print_error "Plugin directory is not a git repository"
        print_info "Consider reinstalling the plugin"
        return 1
    fi

    print_info "Pulling latest changes..."
    if git -C "$PLUGIN_DIR" pull --rebase --quiet 2>/dev/null; then
        print_success "Plugin updated to $(get_version)"
    else
        print_warning "Could not update (may have local changes)"
    fi

    return 0
}

# =============================================================================
# Uninstall Plugin
# =============================================================================
uninstall() {
    print_divider "Uninstall $MODULE_NAME"

    if ! is_installed; then
        print_info "Plugin is not installed"
        return 0
    fi

    print_warning "This will remove zsh-syntax-highlighting from your system"

    if ! confirm "Are you sure you want to uninstall?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove from plugins array
    print_info "Removing from plugins list..."
    remove_plugin_omz "zsh-syntax-highlighting"

    # Remove configuration lines
    print_info "Removing configuration..."
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"
    remove_from_zshrc "ZSH_HIGHLIGHT" "pattern"

    # Remove plugin directory
    print_info "Removing plugin directory..."
    rm -rf "$PLUGIN_DIR"

    if [[ ! -d "$PLUGIN_DIR" ]]; then
        print_success "Plugin uninstalled successfully"
    else
        print_error "Failed to remove plugin directory"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}zsh-syntax-highlighting Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install zsh-syntax-highlighting (default)"
    echo "  configure   Configure plugin settings"
    echo "  update      Update to latest version"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove plugin completely"
    echo "  help        Show this help message"
    echo ""
    echo "IMPORTANT: This plugin MUST be the LAST plugin in your plugins array!"
    echo ""
    echo "Examples:"
    echo "  $0              # Install plugin"
    echo "  $0 status       # Check installation status"
    echo "  $0 configure    # Reconfigure settings"
    echo ""
}

# =============================================================================
# Main Entry Point
# =============================================================================
main() {
    local command="${1:-install}"

    # Show header
    show_ascii_header
    print_header "$MODULE_NAME Installer"

    case "$command" in
        install)
            # Check dependencies first
            if ! check_dependencies; then
                print_error "Missing dependencies. Please install Oh My ZSH first."
                exit 1
            fi

            # Check if already installed
            if is_installed; then
                show_status
                print_warning "$MODULE_NAME is already installed"

                if confirm "Reconfigure $MODULE_NAME?"; then
                    configure
                fi
                exit 0
            fi

            install && configure
            ;;
        configure)
            if ! is_installed; then
                print_error "Plugin is not installed"
                print_info "Run: $0 install"
                exit 1
            fi
            configure
            ;;
        update)
            update
            ;;
        status)
            show_status
            ;;
        uninstall)
            uninstall
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac

    local exit_code=$?

    if [[ $exit_code -eq 0 && "$command" != "help" && "$command" != "status" ]]; then
        echo ""
        print_success "$MODULE_NAME operation complete!"
        print_info "Restart your terminal or run 'source ~/.zshrc' to apply changes"
        echo ""
    fi

    exit $exit_code
}

# Run main if executed directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
