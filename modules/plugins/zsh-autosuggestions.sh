#!/usr/bin/env bash
# =============================================================================
# zsh-autosuggestions - Fish-like Autosuggestions for ZSH
# DR Custom Terminal
# =============================================================================
# Suggests commands as you type based on history and completions.
# Suggestions are displayed in a muted color and can be accepted with
# the right arrow key or end-of-line key.
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
MODULE_NAME="zsh-autosuggestions"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("git" "zsh")

# Plugin-specific configuration
PLUGIN_REPO="https://github.com/zsh-users/zsh-autosuggestions"
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Default configuration values
DEFAULT_SUGGESTION_COLOR="fg=8"
DEFAULT_STRATEGY="(history completion)"

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
                _                                       _   _
   __ _ _   _| |_ ___  ___ _   _  __ _  __ _  ___  ___| |_(_) ___  _ __  ___
  / _` | | | | __/ _ \/ __| | | |/ _` |/ _` |/ _ \/ __| __| |/ _ \| '_ \/ __|
 | (_| | |_| | || (_) \__ \ |_| | (_| | (_| |  __/\__ \ |_| | (_) | | | \__ \
  \__,_|\__,_|\__\___/|___/\__,_|\__, |\__, |\___||___/\__|_|\___/|_| |_|___/
                                 |___/ |___/
    Fish-like autosuggestions for ZSH
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
    [[ -d "$PLUGIN_DIR" && -f "${PLUGIN_DIR}/zsh-autosuggestions.zsh" ]]
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

        if echo "$plugins" | grep -q "zsh-autosuggestions"; then
            print_success "Plugin is enabled in .zshrc"
        else
            print_warning "Plugin is NOT enabled in .zshrc"
            print_info "Add 'zsh-autosuggestions' to your plugins array"
        fi

        # Check current configuration
        if grep -q "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE" "$zshrc_path" 2>/dev/null; then
            local current_color
            current_color=$(grep "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE" "$zshrc_path" | head -1 | cut -d'"' -f2)
            echo -e "  ${ICON_BULLET} Suggestion color: ${DIM}${current_color}${NC}"
        fi

        if grep -q "ZSH_AUTOSUGGEST_STRATEGY" "$zshrc_path" 2>/dev/null; then
            local current_strategy
            current_strategy=$(grep "ZSH_AUTOSUGGEST_STRATEGY" "$zshrc_path" | head -1 | sed 's/.*=(//' | sed 's/).*//')
            echo -e "  ${ICON_BULLET} Strategy: ${DIM}${current_strategy}${NC}"
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
    print_step 3 4 "Cloning zsh-autosuggestions..."
    if ! git clone --depth=1 "$PLUGIN_REPO" "$PLUGIN_DIR" 2>/dev/null; then
        print_error "Failed to clone repository"
        return 1
    fi
    print_success "Repository cloned successfully"

    # Add to plugins array in .zshrc
    print_step 4 4 "Enabling plugin in .zshrc..."
    add_plugin_omz "zsh-autosuggestions"

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

    # Configure suggestion highlight style (color)
    echo ""
    echo -e "${BOLD}Suggestion Color Configuration${NC}"
    echo ""
    echo -e "  The suggestion color determines how autosuggestions appear."
    echo -e "  Common options:"
    echo ""
    echo -e "  ${CYAN}fg=8${NC}         Gray (default, works on most themes)"
    echo -e "  ${CYAN}fg=#6c7086${NC}   Catppuccin Overlay0"
    echo -e "  ${CYAN}fg=#928374${NC}   Gruvbox Gray"
    echo -e "  ${CYAN}fg=#4c566a${NC}   Nord Polar Night"
    echo -e "  ${CYAN}fg=#6272a4${NC}   Dracula Comment"
    echo -e "  ${CYAN}fg=240${NC}       256-color gray"
    echo ""

    local suggestion_color="$DEFAULT_SUGGESTION_COLOR"
    if confirm "Customize suggestion color?" "n"; then
        read -r -p "$(echo -e "${YELLOW}?${NC} Enter color style (e.g., fg=8 or fg=#928374): ")" suggestion_color
        [[ -z "$suggestion_color" ]] && suggestion_color="$DEFAULT_SUGGESTION_COLOR"
    fi

    # Set highlight style
    local style_line="ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=\"${suggestion_color}\""
    if grep -q "^ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=" "$zshrc_path" 2>/dev/null; then
        # Update existing
        local temp_file
        temp_file="$(mktemp)"
        sed "s|^ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=.*|${style_line}|" "$zshrc_path" > "$temp_file"
        mv "$temp_file" "$zshrc_path"
        print_success "Updated suggestion color: $suggestion_color"
    else
        add_to_zshrc "$style_line" "zsh-autosuggestions: suggestion color"
    fi

    # Configure suggestion strategy
    echo ""
    echo -e "${BOLD}Suggestion Strategy${NC}"
    echo ""
    echo -e "  The strategy determines where suggestions come from."
    echo -e "  Strategies are tried in order until one provides a suggestion."
    echo ""
    echo -e "  ${CYAN}history${NC}      Suggest from command history"
    echo -e "  ${CYAN}completion${NC}   Suggest from tab completions"
    echo -e "  ${CYAN}match_prev_cmd${NC}  Suggest command that follows the previous command"
    echo ""

    local strategy="$DEFAULT_STRATEGY"
    if confirm "Use recommended strategy (history completion)?" "y"; then
        strategy="(history completion)"
    else
        read -r -p "$(echo -e "${YELLOW}?${NC} Enter strategy (e.g., history or history completion): ")" strategy
        [[ -z "$strategy" ]] && strategy="(history)"
        # Ensure parentheses
        [[ "$strategy" != "("* ]] && strategy="($strategy)"
        [[ "$strategy" != *")" ]] && strategy="${strategy})"
    fi

    # Set strategy
    local strategy_line="ZSH_AUTOSUGGEST_STRATEGY=${strategy}"
    if grep -q "^ZSH_AUTOSUGGEST_STRATEGY=" "$zshrc_path" 2>/dev/null; then
        local temp_file
        temp_file="$(mktemp)"
        sed "s|^ZSH_AUTOSUGGEST_STRATEGY=.*|${strategy_line}|" "$zshrc_path" > "$temp_file"
        mv "$temp_file" "$zshrc_path"
        print_success "Updated suggestion strategy: $strategy"
    else
        add_to_zshrc "$strategy_line" "zsh-autosuggestions: suggestion strategy"
    fi

    # Show keybinding info
    echo ""
    print_divider "Usage"
    echo ""
    echo -e "  ${BOLD}Accept suggestions:${NC}"
    echo ""
    echo -e "  ${CYAN}Right Arrow${NC}    Accept full suggestion"
    echo -e "  ${CYAN}End${NC}            Accept full suggestion"
    echo -e "  ${CYAN}Ctrl+E${NC}         Accept full suggestion"
    echo -e "  ${CYAN}Ctrl+F${NC}         Accept full suggestion"
    echo -e "  ${CYAN}Alt+Right${NC}      Accept next word (partial)"
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

    print_warning "This will remove zsh-autosuggestions from your system"

    if ! confirm "Are you sure you want to uninstall?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove from plugins array
    print_info "Removing from plugins list..."
    remove_plugin_omz "zsh-autosuggestions"

    # Remove configuration lines
    print_info "Removing configuration..."
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"
    remove_from_zshrc "ZSH_AUTOSUGGEST" "pattern"

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
    echo -e "${BOLD}zsh-autosuggestions Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install zsh-autosuggestions (default)"
    echo "  configure   Configure plugin settings"
    echo "  update      Update to latest version"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove plugin completely"
    echo "  help        Show this help message"
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
