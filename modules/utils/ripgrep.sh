#!/usr/bin/env bash
# =============================================================================
# ripgrep - Fast Recursive Search Tool
# DR Custom Terminal
# =============================================================================
# ripgrep (rg) is a line-oriented search tool that recursively searches
# directories for regex patterns while respecting gitignore rules.
# Extremely fast due to Rust implementation and smart optimizations.
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
MODULE_NAME="ripgrep"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew")

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
       _
  _ __(_)_ __   __ _ _ __ ___ _ __
 | '__| | '_ \ / _` | '__/ _ \ '_ \
 | |  | | |_) | (_| | | |  __/ |_) |
 |_|  |_| .__/ \__, |_|  \___| .__/
        |_|    |___/         |_|

 Fast Recursive Search (rg)
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
    command_exists rg
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    if is_installed; then
        rg --version 2>/dev/null | head -1 | awk '{print $2}'
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
        echo -e "  ${ICON_BULLET} Location: ${DIM}$(which rg)${NC}"
        echo ""

        # Check for config
        if [[ -f "${HOME}/.ripgreprc" ]]; then
            print_success "Configuration file exists"
        fi

        # Check for alias
        local zshrc_path
        zshrc_path="$(get_zshrc_path)"
        if grep -q "alias grep=.*rg" "$zshrc_path" 2>/dev/null; then
            print_info "grep alias configured"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Install ripgrep
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
    print_step 2 2 "Installing ripgrep..."
    if ! install_with_brew "ripgrep" "ripgrep"; then
        print_error "Failed to install ripgrep"
        return 1
    fi

    return 0
}

# =============================================================================
# Configure ripgrep
# =============================================================================
configure() {
    print_divider "Configuration"

    # Create configuration file
    local config_file="${HOME}/.ripgreprc"

    if confirm "Create ripgrep configuration file?" "y"; then
        print_info "Creating configuration..."

        cat > "$config_file" << 'EOF'
# ripgrep configuration file
# Documentation: https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md

# Search hidden files and directories
--hidden

# Follow symbolic links
--follow

# Don't search these directories
--glob=!.git/*
--glob=!node_modules/*
--glob=!.cache/*
--glob=!*.min.js
--glob=!*.min.css
--glob=!package-lock.json
--glob=!yarn.lock

# Smart case: case-insensitive unless pattern has uppercase
--smart-case

# Show line numbers
--line-number

# Show column numbers
--column

# Add color output
--color=auto

# Use extended regex
--pcre2
EOF

        # Set the RIPGREP_CONFIG_PATH
        add_to_zshrc "export RIPGREP_CONFIG_PATH=\"${config_file}\"" "ripgrep config path"

        print_success "Configuration saved to: $config_file"
    fi

    # Offer grep alias
    echo ""
    if confirm "Create alias 'grep' -> 'rg'?"; then
        add_alias_zshrc "grep" "rg" "ripgrep: replace grep"
        print_success "grep alias added"
    fi

    # Additional aliases
    if confirm "Add useful ripgrep aliases?"; then
        # Search in specific file types
        add_alias_zshrc "rgpy" "rg -t py" "ripgrep: search Python files"
        add_alias_zshrc "rgjs" "rg -t js" "ripgrep: search JavaScript files"
        add_alias_zshrc "rgts" "rg -t ts" "ripgrep: search TypeScript files"

        # Search with context
        add_alias_zshrc "rgc" "rg -C 3" "ripgrep: search with 3 lines context"

        # Count matches
        add_alias_zshrc "rgcount" "rg -c" "ripgrep: count matches per file"

        # List files with matches
        add_alias_zshrc "rgfiles" "rg -l" "ripgrep: list files with matches"

        # Fixed string search (literal)
        add_alias_zshrc "rgf" "rg -F" "ripgrep: fixed string search"

        print_success "Aliases added"
    fi

    # Show usage
    echo ""
    print_divider "Usage"
    echo ""
    echo -e "  ${BOLD}Basic usage:${NC}"
    echo ""
    echo -e "  ${CYAN}rg 'pattern'${NC}           Search for pattern recursively"
    echo -e "  ${CYAN}rg 'pattern' ./src${NC}     Search in specific directory"
    echo -e "  ${CYAN}rg -i 'pattern'${NC}        Case-insensitive search"
    echo -e "  ${CYAN}rg -w 'word'${NC}           Match whole words only"
    echo ""
    echo -e "  ${BOLD}Advanced usage:${NC}"
    echo ""
    echo -e "  ${CYAN}rg -t py 'import'${NC}      Search only Python files"
    echo -e "  ${CYAN}rg -C 3 'pattern'${NC}      Show 3 lines of context"
    echo -e "  ${CYAN}rg -l 'pattern'${NC}        List matching files only"
    echo -e "  ${CYAN}rg -c 'pattern'${NC}        Count matches per file"
    echo -e "  ${CYAN}rg -v 'pattern'${NC}        Invert match (exclude)"
    echo ""
    echo -e "  ${BOLD}Tip:${NC} ripgrep respects .gitignore by default!"
    echo ""

    return 0
}

# =============================================================================
# Uninstall ripgrep
# =============================================================================
uninstall() {
    print_divider "Uninstall ripgrep"

    print_warning "This will remove ripgrep from your system"

    if ! confirm "Are you sure you want to uninstall ripgrep?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove via Homebrew
    if uninstall_brew "ripgrep"; then
        # Clean up shell configuration
        print_info "Cleaning up shell configuration..."
        remove_from_zshrc "alias grep=.*rg" "pattern"
        remove_from_zshrc "rg" "pattern"
        remove_from_zshrc "RIPGREP_CONFIG_PATH" "pattern"

        # Remove config file
        rm -f "${HOME}/.ripgreprc"

        print_success "ripgrep uninstalled"
    else
        print_error "Failed to uninstall ripgrep"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}ripgrep Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install ripgrep (default)"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove ripgrep completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install ripgrep"
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
                print_info "ripgrep is not installed"
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
