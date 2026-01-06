#!/usr/bin/env bash
# =============================================================================
# zsh-history-substring-search - Fish-like History Search for ZSH
# DR Custom Terminal
# =============================================================================
# Allows you to type a part of a command and then use Up/Down arrow keys to
# navigate through history entries that contain that substring. Much more
# powerful than the default Ctrl+R history search.
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
MODULE_NAME="zsh-history-substring-search"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("git" "zsh")

# Plugin-specific configuration
PLUGIN_REPO="https://github.com/zsh-users/zsh-history-substring-search"
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search"

# Default keybindings
DEFAULT_UP_KEYS='("^[[A" "^[OA")'        # Up arrow sequences
DEFAULT_DOWN_KEYS='("^[[B" "^[OB")'      # Down arrow sequences

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
  _     _     _                                              _
 | |__ (_)___| |_ ___  _ __ _   _       ___  ___  __ _ _ __ | |__
 | '_ \| / __| __/ _ \| '__| | | |_____/ __|/ _ \/ _` | '_ \| '_ \
 | | | | \__ \ || (_) | |  | |_| |_____\__ \  __/ (_| | |_) | | | |
 |_| |_|_|___/\__\___/|_|   \__, |     |___/\___|\__,_| .__/|_| |_|
                            |___/                     |_|
    Fish-like history substring search for ZSH
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
    [[ -d "$PLUGIN_DIR" && -f "${PLUGIN_DIR}/zsh-history-substring-search.zsh" ]]
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

        if echo "$plugins" | grep -q "zsh-history-substring-search"; then
            print_success "Plugin is enabled in .zshrc"
        else
            print_warning "Plugin is NOT enabled in .zshrc"
            print_info "Add 'zsh-history-substring-search' to your plugins array"
        fi

        # Check keybinding configuration
        if grep -q "history-substring-search-up" "$zshrc_path" 2>/dev/null; then
            print_success "Keybindings are configured"

            # Show configured keys
            if grep -q "bindkey.*\\^\\[\\[A" "$zshrc_path" 2>/dev/null; then
                echo -e "  ${ICON_BULLET} Up Arrow: ${DIM}configured${NC}"
            fi
            if grep -q "bindkey.*\\^\\[\\[B" "$zshrc_path" 2>/dev/null; then
                echo -e "  ${ICON_BULLET} Down Arrow: ${DIM}configured${NC}"
            fi
        else
            print_warning "Keybindings may not be configured"
            print_info "Arrow keys may not work for history search"
        fi

        # Check for highlight colors
        if grep -q "HISTORY_SUBSTRING_SEARCH_HIGHLIGHT" "$zshrc_path" 2>/dev/null; then
            echo -e "  ${ICON_BULLET} Custom highlight colors configured"
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
    print_step 3 4 "Cloning zsh-history-substring-search..."
    if ! git clone --depth=1 "$PLUGIN_REPO" "$PLUGIN_DIR" 2>/dev/null; then
        print_error "Failed to clone repository"
        return 1
    fi
    print_success "Repository cloned successfully"

    # Add to plugins array in .zshrc
    print_step 4 4 "Enabling plugin in .zshrc..."
    add_plugin_omz "zsh-history-substring-search"

    return 0
}

# =============================================================================
# Configure Keybindings
# =============================================================================
configure_keybindings() {
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    print_info "Configuring keybindings for history substring search..."

    # Remove existing keybindings if present
    local temp_file
    temp_file="$(mktemp)"
    grep -v "history-substring-search" "$zshrc_path" > "$temp_file" 2>/dev/null || true
    mv "$temp_file" "$zshrc_path"

    # Add keybinding configuration block
    cat >> "$zshrc_path" << 'KEYBINDINGS'

# zsh-history-substring-search: keybindings
# Bind UP and DOWN arrow keys to history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind UP and DOWN for different terminal modes
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# Bind Ctrl+P and Ctrl+N as alternative
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# For vi mode (if using vi keybindings)
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
KEYBINDINGS

    print_success "Keybindings configured"
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

    # Configure keybindings
    echo ""
    echo -e "${BOLD}Keybinding Configuration${NC}"
    echo ""
    echo -e "  This plugin requires keybindings to connect the Up/Down arrow"
    echo -e "  keys to the history search functions."
    echo ""
    echo -e "  Default bindings to configure:"
    echo ""
    echo -e "  ${CYAN}Up Arrow${NC}    Search backward in history"
    echo -e "  ${CYAN}Down Arrow${NC}  Search forward in history"
    echo -e "  ${CYAN}Ctrl+P${NC}      Alternative for Up"
    echo -e "  ${CYAN}Ctrl+N${NC}      Alternative for Down"
    echo ""

    if confirm "Configure keybindings for arrow keys?" "y"; then
        configure_keybindings
    fi

    # Configure highlight colors
    echo ""
    echo -e "${BOLD}Highlight Colors${NC}"
    echo ""
    echo -e "  You can customize how matching text is highlighted."
    echo ""
    echo -e "  ${CYAN}HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND${NC}"
    echo -e "  Color when match is found (default: 'bg=magenta,fg=white,bold')"
    echo ""
    echo -e "  ${CYAN}HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND${NC}"
    echo -e "  Color when no match (default: 'bg=red,fg=white,bold')"
    echo ""

    if confirm "Configure custom highlight colors?" "n"; then
        echo ""
        echo -e "  ${BOLD}Color presets:${NC}"
        echo ""
        echo -e "  1. ${CYAN}Default${NC}        Magenta/Red backgrounds"
        echo -e "  2. ${CYAN}Subtle${NC}         Underline only, no background"
        echo -e "  3. ${CYAN}Catppuccin${NC}     Theme-matched colors"
        echo -e "  4. ${CYAN}Custom${NC}         Enter your own"
        echo ""

        local choice
        read -r -p "$(echo -e "${YELLOW}?${NC} Select preset (1-4): ")" choice

        case "$choice" in
            1)
                # Default - do nothing
                print_info "Using default colors"
                ;;
            2)
                # Subtle
                add_to_zshrc 'HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=green,underline"' \
                    "zsh-history-substring-search: match found color"
                add_to_zshrc 'HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,underline"' \
                    "zsh-history-substring-search: no match color"
                print_success "Subtle highlight colors applied"
                ;;
            3)
                # Catppuccin
                add_to_zshrc 'HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=#45475a,fg=#cdd6f4,bold"' \
                    "zsh-history-substring-search: match found color (Catppuccin)"
                add_to_zshrc 'HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="bg=#f38ba8,fg=#1e1e2e,bold"' \
                    "zsh-history-substring-search: no match color (Catppuccin)"
                print_success "Catppuccin highlight colors applied"
                ;;
            4)
                # Custom
                echo ""
                local found_color not_found_color
                read -r -p "$(echo -e "${YELLOW}?${NC} Found color (e.g., bg=green,fg=white): ")" found_color
                read -r -p "$(echo -e "${YELLOW}?${NC} Not found color (e.g., bg=red,fg=white): ")" not_found_color

                if [[ -n "$found_color" ]]; then
                    add_to_zshrc "HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=\"${found_color}\"" \
                        "zsh-history-substring-search: match found color"
                fi
                if [[ -n "$not_found_color" ]]; then
                    add_to_zshrc "HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=\"${not_found_color}\"" \
                        "zsh-history-substring-search: no match color"
                fi
                print_success "Custom highlight colors applied"
                ;;
            *)
                print_info "Using default colors"
                ;;
        esac
    fi

    # Configure behavior options
    echo ""
    echo -e "${BOLD}Behavior Options${NC}"
    echo ""

    if confirm "Enable fuzzy matching (match anywhere in command)?" "n"; then
        add_to_zshrc 'HISTORY_SUBSTRING_SEARCH_FUZZY=1' \
            "zsh-history-substring-search: enable fuzzy matching"
        print_success "Fuzzy matching enabled"
    fi

    if confirm "Ensure unique results (no duplicates)?" "y"; then
        add_to_zshrc 'HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1' \
            "zsh-history-substring-search: unique results only"
        print_success "Unique results enabled"
    fi

    # Show usage info
    echo ""
    print_divider "Usage"
    echo ""
    echo -e "  ${BOLD}How to use:${NC}"
    echo ""
    echo -e "  1. Start typing part of a command you remember"
    echo -e "  2. Press ${CYAN}Up Arrow${NC} to search backward through matching history"
    echo -e "  3. Press ${CYAN}Down Arrow${NC} to search forward through matches"
    echo -e "  4. Press ${CYAN}Enter${NC} to execute the selected command"
    echo ""
    echo -e "  ${BOLD}Example:${NC}"
    echo ""
    echo -e "  Type: ${DIM}git push${NC}"
    echo -e "  Press Up Arrow to find: ${DIM}git push origin main --force${NC}"
    echo -e "  Press Up again to find: ${DIM}git push origin feature-branch${NC}"
    echo ""
    echo -e "  ${BOLD}Alternative keys:${NC}"
    echo ""
    echo -e "  ${CYAN}Ctrl+P${NC}  Same as Up Arrow"
    echo -e "  ${CYAN}Ctrl+N${NC}  Same as Down Arrow"
    echo -e "  ${CYAN}k${NC}       Up (vi mode)"
    echo -e "  ${CYAN}j${NC}       Down (vi mode)"
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

    print_warning "This will remove zsh-history-substring-search from your system"

    if ! confirm "Are you sure you want to uninstall?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove from plugins array
    print_info "Removing from plugins list..."
    remove_plugin_omz "zsh-history-substring-search"

    # Remove keybindings and configuration
    print_info "Removing configuration..."
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Remove all related lines
    local temp_file
    temp_file="$(mktemp)"
    grep -v "history-substring-search" "$zshrc_path" | \
    grep -v "HISTORY_SUBSTRING_SEARCH" > "$temp_file" 2>/dev/null || true
    mv "$temp_file" "$zshrc_path"

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
    echo -e "${BOLD}zsh-history-substring-search Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install zsh-history-substring-search (default)"
    echo "  configure   Configure plugin settings and keybindings"
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
