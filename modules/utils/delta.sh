#!/usr/bin/env bash
# =============================================================================
# delta - Beautiful Git Diff Viewer
# DR Custom Terminal
# =============================================================================
# delta is a syntax-highlighting pager for git, diff, and grep output.
# Features include side-by-side view, line numbers, syntax highlighting,
# and integration with bat themes.
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
MODULE_NAME="delta"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew")

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
      _      _ _
   __| | ___| | |_ __ _
  / _` |/ _ \ | __/ _` |
 | (_| |  __/ | || (_| |
  \__,_|\___|_|\__\__,_|

 Beautiful Git Diff Viewer
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
    command_exists delta
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    if is_installed; then
        delta --version 2>/dev/null | awk '{print $2}'
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
        echo -e "  ${ICON_BULLET} Location: ${DIM}$(which delta)${NC}"
        echo ""

        # Check git configuration
        local git_pager
        git_pager=$(git config --global core.pager 2>/dev/null || echo "")
        if [[ "$git_pager" == "delta" ]]; then
            print_success "Configured as git pager"
        else
            print_warning "Not configured as git pager"
        fi

        # Check for interactive diff filter
        local diff_filter
        diff_filter=$(git config --global interactive.diffFilter 2>/dev/null || echo "")
        if [[ -n "$diff_filter" ]]; then
            print_success "Interactive diff filter configured"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Install delta
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
    print_step 2 2 "Installing delta..."
    if ! install_with_brew "git-delta" "delta"; then
        print_error "Failed to install delta"
        return 1
    fi

    return 0
}

# =============================================================================
# Configure delta
# =============================================================================
configure() {
    print_divider "Configuration"

    # Configure git to use delta
    print_info "Configuring git to use delta..."

    # Set delta as the pager
    git config --global core.pager delta
    print_success "Set delta as git pager"

    # Configure interactive diff filter
    git config --global interactive.diffFilter "delta --color-only"
    print_success "Configured interactive diff filter"

    # Configure delta-specific git settings
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global delta.line-numbers true

    # Theme selection
    echo ""
    print_info "Select a theme for delta:"
    echo ""
    echo -e "  ${CYAN}1)${NC} Dracula"
    echo -e "  ${CYAN}2)${NC} Nord"
    echo -e "  ${CYAN}3)${NC} gruvbox-dark"
    echo -e "  ${CYAN}4)${NC} Monokai Extended"
    echo -e "  ${CYAN}5)${NC} Catppuccin-mocha"
    echo -e "  ${CYAN}6)${NC} OneHalfDark"
    echo -e "  ${CYAN}7)${NC} GitHub"
    echo -e "  ${CYAN}8)${NC} None (use default)"
    echo ""

    local theme_choice
    read -r -p "$(echo -e "${YELLOW}?${NC} Select theme [1-8, default=1]: ")" theme_choice
    theme_choice="${theme_choice:-1}"

    local selected_theme
    case "$theme_choice" in
        1) selected_theme="Dracula" ;;
        2) selected_theme="Nord" ;;
        3) selected_theme="gruvbox-dark" ;;
        4) selected_theme="Monokai Extended" ;;
        5) selected_theme="Catppuccin-mocha" ;;
        6) selected_theme="OneHalfDark" ;;
        7) selected_theme="GitHub" ;;
        8) selected_theme="" ;;
        *) selected_theme="Dracula" ;;
    esac

    if [[ -n "$selected_theme" ]]; then
        git config --global delta.syntax-theme "$selected_theme"
        print_success "Theme set to: $selected_theme"
    fi

    # Side-by-side option
    echo ""
    if confirm "Enable side-by-side diff view?" "y"; then
        git config --global delta.side-by-side true
        print_success "Side-by-side view enabled"
    else
        git config --global delta.side-by-side false
    fi

    # Additional options
    if confirm "Configure additional delta options?"; then
        # File decoration
        git config --global delta.file-style "bold yellow ul"
        git config --global delta.file-decoration-style "none"

        # Hunk header
        git config --global delta.hunk-header-decoration-style "cyan box ul"

        # Word diff
        if confirm "Enable word-level diff highlighting?" "y"; then
            git config --global delta.word-diff-regex "."
        fi

        print_success "Additional options configured"
    fi

    # Merge conflict style
    git config --global merge.conflictstyle diff3

    # Show usage
    echo ""
    print_divider "Usage"
    echo ""
    echo -e "  ${BOLD}delta is now your git pager! Examples:${NC}"
    echo ""
    echo -e "  ${CYAN}git diff${NC}              View diff with syntax highlighting"
    echo -e "  ${CYAN}git show${NC}              Show commit with highlighting"
    echo -e "  ${CYAN}git log -p${NC}            Log with patches"
    echo -e "  ${CYAN}git stash show -p${NC}     View stash diff"
    echo -e "  ${CYAN}git blame${NC}             Blame with highlighting"
    echo ""
    echo -e "  ${BOLD}Navigation (when viewing diffs):${NC}"
    echo ""
    echo -e "  ${CYAN}n${NC}                     Jump to next file"
    echo -e "  ${CYAN}N${NC}                     Jump to previous file"
    echo -e "  ${CYAN}q${NC}                     Quit"
    echo ""
    echo -e "  ${BOLD}Standalone usage:${NC}"
    echo ""
    echo -e "  ${CYAN}diff -u file1 file2 | delta${NC}"
    echo -e "  ${CYAN}delta file1 file2${NC}"
    echo ""

    return 0
}

# =============================================================================
# Uninstall delta
# =============================================================================
uninstall() {
    print_divider "Uninstall delta"

    print_warning "This will remove delta from your system"

    if ! confirm "Are you sure you want to uninstall delta?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove via Homebrew
    if uninstall_brew "git-delta"; then
        # Clean up git configuration
        print_info "Cleaning up git configuration..."

        git config --global --unset core.pager 2>/dev/null || true
        git config --global --unset interactive.diffFilter 2>/dev/null || true
        git config --global --unset delta.navigate 2>/dev/null || true
        git config --global --unset delta.light 2>/dev/null || true
        git config --global --unset delta.line-numbers 2>/dev/null || true
        git config --global --unset delta.side-by-side 2>/dev/null || true
        git config --global --unset delta.syntax-theme 2>/dev/null || true
        git config --global --unset delta.file-style 2>/dev/null || true
        git config --global --unset delta.file-decoration-style 2>/dev/null || true
        git config --global --unset delta.hunk-header-decoration-style 2>/dev/null || true
        git config --global --unset delta.word-diff-regex 2>/dev/null || true

        # Remove delta section if empty
        git config --global --remove-section delta 2>/dev/null || true

        print_success "delta uninstalled"
    else
        print_error "Failed to uninstall delta"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}delta Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install delta (default)"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove delta completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install delta"
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
                print_info "delta is not installed"
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
        print_info "Git will now use delta for diffs automatically"
        echo ""
    fi

    exit $exit_code
}

# Run main if executed directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
