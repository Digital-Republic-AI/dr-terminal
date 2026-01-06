#!/usr/bin/env bash
# =============================================================================
# bat - A cat Clone with Syntax Highlighting
# DR Custom Terminal
# =============================================================================
# A modern replacement for cat with syntax highlighting, line numbers, and
# Git integration. Perfect for viewing code and config files in the terminal.
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
MODULE_NAME="bat"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew")

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
  _           _
 | |         | |
 | |__   __ _| |_
 | '_ \ / _` | __|
 | |_) | (_| | |_
 |_.__/ \__,_|\__|

 cat with Syntax Highlighting
EOF
    echo -e "${NC}"
    echo ""
}

# =============================================================================
# Dependency Check
# =============================================================================
check_dependencies() {
    local has_errors=0

    for dep in "${MODULE_DEPS[@]}"; do
        if ! command_exists "$dep"; then
            print_error "Required dependency not found: $dep"
            has_errors=1
        fi
    done

    return $has_errors
}

# =============================================================================
# Installation Status Check
# =============================================================================
is_installed() {
    command_exists bat
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    if is_installed; then
        bat --version 2>/dev/null | awk '{print $2}'
    else
        echo "Not installed"
    fi
}

# =============================================================================
# Show Current Status
# =============================================================================
show_status() {
    print_divider "Current Status"

    if is_installed; then
        local version
        version="$(get_version)"

        echo -e "  ${ICON_SUCCESS} ${GREEN}Installed${NC}"
        echo -e "  ${ICON_BULLET} Version: ${BOLD}${version}${NC}"
        echo -e "  ${ICON_BULLET} Location: ${DIM}$(which bat)${NC}"
        echo ""

        # Check current theme
        local current_theme
        local config_file
        config_file="$(bat --config-file 2>/dev/null)" || true
        if [[ -n "$config_file" && -f "$config_file" ]]; then
            current_theme=$(grep "theme" "$config_file" 2>/dev/null | cut -d'"' -f2) || current_theme="default"
        else
            current_theme="default"
        fi
        echo -e "  ${ICON_BULLET} Theme: ${BOLD}${current_theme:-default}${NC}"

        # Check for cat alias
        local zshrc_path
        zshrc_path="$(get_zshrc_path)"
        if grep -q "alias cat=.*bat" "$zshrc_path" 2>/dev/null; then
            print_success "cat alias configured"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Install bat
# =============================================================================
install() {
    print_divider "Installation"

    # Check for internet connectivity
    print_step 1 2 "Checking internet connection..."
    if ! has_internet; then
        print_error "No internet connection detected"
        return 1
    fi
    print_success "Internet connection available"

    # Install via Homebrew
    print_step 2 2 "Installing bat..."
    if ! install_with_brew "bat" "bat"; then
        print_error "Failed to install bat"
        return 1
    fi

    return 0
}

# =============================================================================
# Configure bat
# =============================================================================
configure() {
    print_divider "Configuration"

    # Create config directory if needed
    local config_dir="${HOME}/.config/bat"
    local config_file="${config_dir}/config"

    mkdir -p "$config_dir"

    # Theme selection
    echo ""
    print_info "Available themes (popular options):"
    echo ""
    echo -e "  ${CYAN}1)${NC} Dracula"
    echo -e "  ${CYAN}2)${NC} OneHalfDark"
    echo -e "  ${CYAN}3)${NC} Nord"
    echo -e "  ${CYAN}4)${NC} gruvbox-dark"
    echo -e "  ${CYAN}5)${NC} Catppuccin-mocha"
    echo -e "  ${CYAN}6)${NC} TwoDark"
    echo -e "  ${CYAN}7)${NC} Solarized (dark)"
    echo -e "  ${CYAN}8)${NC} ansi (minimal)"
    echo ""

    local theme_choice
    read -r -p "$(echo -e "${YELLOW}?${NC} Select theme [1-8, default=1]: ")" theme_choice
    theme_choice="${theme_choice:-1}"

    local selected_theme
    case "$theme_choice" in
        1) selected_theme="Dracula" ;;
        2) selected_theme="OneHalfDark" ;;
        3) selected_theme="Nord" ;;
        4) selected_theme="gruvbox-dark" ;;
        5) selected_theme="Catppuccin-mocha" ;;
        6) selected_theme="TwoDark" ;;
        7) selected_theme="Solarized (dark)" ;;
        8) selected_theme="ansi" ;;
        *) selected_theme="Dracula" ;;
    esac

    # Write config file
    print_info "Creating bat configuration..."

    cat > "$config_file" << EOF
# bat configuration file
# Generated by DR Custom Terminal

# Set the theme
--theme="${selected_theme}"

# Show line numbers
--style="numbers,changes,header"

# Use italic text (if terminal supports it)
--italic-text=always

# Set the pager
--paging=auto
EOF

    print_success "Configuration saved to: $config_file"

    # Offer cat alias
    echo ""
    if confirm "Create alias 'cat' -> 'bat'?" "y"; then
        add_alias_zshrc "cat" "bat" "bat: replace cat with bat"
        print_success "cat alias added"
    fi

    # Add additional helpful aliases
    if confirm "Add helpful bat aliases?"; then
        # bat with plain output (no decorations)
        add_alias_zshrc "batp" "bat --plain" "bat: plain output"

        # bat for help pages
        add_alias_zshrc "bathelp" "bat --plain --language=help" "bat: help pages"

        # Set MANPAGER to use bat for man pages
        local man_pager='export MANPAGER="sh -c '\''col -bx | bat -l man -p'\''"'
        add_to_zshrc "$man_pager" "Use bat as MANPAGER"

        print_success "Aliases added"
    fi

    # Show usage info
    echo ""
    print_divider "Usage"
    echo ""
    echo -e "  ${BOLD}Basic usage:${NC}"
    echo ""
    echo -e "  ${CYAN}bat file.txt${NC}         View file with syntax highlighting"
    echo -e "  ${CYAN}bat -l python file${NC}   Force Python syntax highlighting"
    echo -e "  ${CYAN}bat --list-themes${NC}    List all available themes"
    echo -e "  ${CYAN}bat --list-languages${NC} List supported languages"
    echo ""
    echo -e "  ${BOLD}Tip:${NC} bat integrates well with other tools:"
    echo -e "  ${DIM}git diff | bat${NC}"
    echo -e "  ${DIM}find . -name '*.py' | xargs bat${NC}"
    echo ""

    return 0
}

# =============================================================================
# Uninstall bat
# =============================================================================
uninstall() {
    print_divider "Uninstall bat"

    print_warning "This will remove bat from your system"

    if ! confirm "Are you sure you want to uninstall bat?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove via Homebrew
    if uninstall_brew "bat"; then
        # Clean up shell configuration
        print_info "Cleaning up shell configuration..."
        remove_from_zshrc "alias cat=.*bat" "pattern"
        remove_from_zshrc "batp" "pattern"
        remove_from_zshrc "bathelp" "pattern"
        remove_from_zshrc "MANPAGER.*bat" "pattern"

        # Remove config
        rm -rf "${HOME}/.config/bat"

        print_success "bat uninstalled"
    else
        print_error "Failed to uninstall bat"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}bat Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install bat (default)"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove bat completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install bat"
    echo "  $0 status       # Check installation status"
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
                print_error "Missing dependencies. Please install Homebrew first."
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
        status)
            show_status
            ;;
        uninstall)
            if ! is_installed; then
                print_info "bat is not installed"
                exit 0
            fi
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
