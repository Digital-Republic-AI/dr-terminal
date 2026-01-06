#!/usr/bin/env bash
# =============================================================================
# fd - Simple, Fast Find Alternative
# DR Custom Terminal
# =============================================================================
# fd is a simple, fast, and user-friendly alternative to 'find'. It features
# colorized output, smart case search, regex support, and respects .gitignore.
# Written in Rust for maximum performance.
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
MODULE_NAME="fd"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew")

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
   __    _
  / _|  | |
 | |_ __| |
 |  _/ _` |
 | || (_| |
 |_| \__,_|

 Simple, Fast Find Alternative
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
    command_exists fd
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    if is_installed; then
        fd --version 2>/dev/null | awk '{print $2}'
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
        echo -e "  ${ICON_BULLET} Location: ${DIM}$(which fd)${NC}"
        echo ""

        # Check for alias
        local zshrc_path
        zshrc_path="$(get_zshrc_path)"
        if grep -q "alias find=.*fd" "$zshrc_path" 2>/dev/null; then
            print_info "find alias configured"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Install fd
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
    print_step 2 2 "Installing fd..."
    if ! install_with_brew "fd" "fd"; then
        print_error "Failed to install fd"
        return 1
    fi

    return 0
}

# =============================================================================
# Configure fd
# =============================================================================
configure() {
    print_divider "Configuration"

    # Create ignore file
    local ignore_file="${HOME}/.fdignore"

    if confirm "Create fd ignore file?" "y"; then
        print_info "Creating ignore configuration..."

        cat > "$ignore_file" << 'EOF'
# fd ignore file
# Patterns listed here will be excluded from fd searches
# This is in addition to .gitignore patterns

# Build directories
node_modules/
dist/
build/
target/
.cache/

# Version control
.git/
.svn/
.hg/

# IDE directories
.idea/
.vscode/
*.swp
*.swo

# Python
__pycache__/
*.pyc
.venv/
venv/

# Temporary files
*.tmp
*.temp
.DS_Store
Thumbs.db
EOF

        print_success "Ignore file created: $ignore_file"
    fi

    # Offer find alias
    echo ""
    print_warning "Note: Creating a 'find' alias may break scripts that expect GNU find"
    if confirm "Create alias 'find' -> 'fd'?" "n"; then
        add_alias_zshrc "find" "fd" "fd: replace find"
        print_success "find alias added"
    fi

    # Add useful aliases
    if confirm "Add useful fd aliases?"; then
        # Find directories only
        add_alias_zshrc "fdd" "fd -t d" "fd: directories only"

        # Find files only
        add_alias_zshrc "fdf" "fd -t f" "fd: files only"

        # Find hidden files
        add_alias_zshrc "fdh" "fd -H" "fd: include hidden files"

        # Find and execute
        add_alias_zshrc "fde" "fd -x" "fd: find and execute"

        # Find case-sensitive
        add_alias_zshrc "fdc" "fd -s" "fd: case-sensitive"

        print_success "Aliases added"
    fi

    # Show usage
    echo ""
    print_divider "Usage"
    echo ""
    echo -e "  ${BOLD}Basic usage:${NC}"
    echo ""
    echo -e "  ${CYAN}fd pattern${NC}            Find files matching pattern"
    echo -e "  ${CYAN}fd pattern ./dir${NC}      Search in specific directory"
    echo -e "  ${CYAN}fd -e py${NC}              Find files with .py extension"
    echo -e "  ${CYAN}fd -t d${NC}               Find directories only"
    echo -e "  ${CYAN}fd -t f${NC}               Find files only"
    echo ""
    echo -e "  ${BOLD}Advanced usage:${NC}"
    echo ""
    echo -e "  ${CYAN}fd -H pattern${NC}         Include hidden files"
    echo -e "  ${CYAN}fd -I pattern${NC}         Don't respect .gitignore"
    echo -e "  ${CYAN}fd -x rm{}${NC}            Execute command on results"
    echo -e "  ${CYAN}fd -0 | xargs -0${NC}      Null-separated output for xargs"
    echo ""
    echo -e "  ${BOLD}Integration with other tools:${NC}"
    echo ""
    echo -e "  ${DIM}# Use fd with fzf for fuzzy file selection${NC}"
    echo -e "  ${CYAN}fd -t f | fzf${NC}"
    echo ""
    echo -e "  ${DIM}# Open found files in editor${NC}"
    echo -e "  ${CYAN}fd -e py | xargs code${NC}"
    echo ""

    return 0
}

# =============================================================================
# Uninstall fd
# =============================================================================
uninstall() {
    print_divider "Uninstall fd"

    print_warning "This will remove fd from your system"

    if ! confirm "Are you sure you want to uninstall fd?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove via Homebrew
    if uninstall_brew "fd"; then
        # Clean up shell configuration
        print_info "Cleaning up shell configuration..."
        remove_from_zshrc "alias find=.*fd" "pattern"
        remove_from_zshrc "alias fd" "pattern"

        # Remove ignore file
        rm -f "${HOME}/.fdignore"

        print_success "fd uninstalled"
    else
        print_error "Failed to uninstall fd"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}fd Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install fd (default)"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove fd completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install fd"
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
                print_info "fd is not installed"
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
