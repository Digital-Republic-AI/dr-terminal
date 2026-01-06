#!/usr/bin/env bash
# =============================================================================
# eza - Modern ls Replacement
# DR Custom Terminal
# =============================================================================
# A modern, maintained replacement for 'ls' with colors, icons, Git integration,
# and tree view. Fork of the unmaintained 'exa' project.
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
MODULE_NAME="eza"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew")

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'

  ___ ______ _
 / _ \_  / _` |
|  __// / (_| |
 \___/___\__,_|

 Modern ls Replacement
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
    command_exists eza
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    if is_installed; then
        eza --version 2>/dev/null | head -1 | awk '{print $1}'
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
        echo -e "  ${ICON_BULLET} Location: ${DIM}$(which eza)${NC}"
        echo ""

        # Check for aliases
        local zshrc_path
        zshrc_path="$(get_zshrc_path)"
        if grep -q "alias ls=.*eza" "$zshrc_path" 2>/dev/null; then
            print_success "ls aliases configured"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Install eza
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
    print_step 2 2 "Installing eza..."
    if ! install_with_brew "eza" "eza"; then
        print_error "Failed to install eza"
        return 1
    fi

    return 0
}

# =============================================================================
# Configure eza
# =============================================================================
configure() {
    print_divider "Configuration"

    echo ""
    print_info "eza provides a modern ls experience with:"
    echo -e "  ${ICON_BULLET} Color-coded file types"
    echo -e "  ${ICON_BULLET} Git status integration"
    echo -e "  ${ICON_BULLET} File icons (with Nerd Font)"
    echo -e "  ${ICON_BULLET} Tree view support"
    echo ""

    # Standard aliases
    if confirm "Replace 'ls' with eza aliases?" "y"; then
        # Basic ls replacement
        add_alias_zshrc "ls" "eza --color=always --group-directories-first" "eza: ls replacement"

        # Detailed list
        add_alias_zshrc "ll" "eza -l --color=always --group-directories-first --icons" "eza: long list"

        # All files including hidden
        add_alias_zshrc "la" "eza -la --color=always --group-directories-first --icons" "eza: all files"

        # Tree view
        add_alias_zshrc "tree" "eza --tree --color=always --group-directories-first --icons" "eza: tree view"

        # Tree with level limit
        add_alias_zshrc "lt" "eza --tree --level=2 --color=always --group-directories-first --icons" "eza: tree (2 levels)"

        print_success "Aliases added"
    fi

    # Additional aliases
    if confirm "Add more eza aliases?"; then
        # Show only directories
        add_alias_zshrc "lsd" "eza -lD --color=always --icons" "eza: directories only"

        # Show only files
        add_alias_zshrc "lsf" "eza -lf --color=always --icons --color-scale" "eza: files only"

        # Sort by modification time
        add_alias_zshrc "lst" "eza -l --sort=modified --color=always --icons" "eza: sort by time"

        # Sort by size
        add_alias_zshrc "lss" "eza -l --sort=size --color=always --icons" "eza: sort by size"

        # Git-aware listing
        add_alias_zshrc "lg" "eza -l --git --color=always --icons" "eza: with git status"

        print_success "Additional aliases added"
    fi

    # EZA_COLORS configuration
    if confirm "Configure custom colors?"; then
        # Add EZA_COLORS for enhanced theming
        local eza_colors='export EZA_COLORS="da=1;34:di=1;34:ex=1;32:fi=0:ln=1;36:mh=0:or=1;31:ow=1;34:pi=33:so=1;35:su=37;41:sg=30;43:st=37;44:tw=30;42"'
        add_to_zshrc "$eza_colors" "eza color configuration"
        print_success "Colors configured"
    fi

    # Icon note
    echo ""
    print_divider "Note: Icons"
    echo ""
    echo -e "  ${BOLD}Icons require a Nerd Font${NC}"
    echo ""
    echo -e "  To display icons properly, install a Nerd Font:"
    echo -e "  ${DIM}brew install --cask font-hack-nerd-font${NC}"
    echo -e "  ${DIM}brew install --cask font-fira-code-nerd-font${NC}"
    echo -e "  ${DIM}brew install --cask font-jetbrains-mono-nerd-font${NC}"
    echo ""
    echo -e "  Then set your terminal to use the installed font."
    echo ""

    # Show usage
    print_divider "Usage"
    echo ""
    echo -e "  ${BOLD}After configuration:${NC}"
    echo ""
    echo -e "  ${CYAN}ls${NC}      List files (eza)"
    echo -e "  ${CYAN}ll${NC}      Long list with icons"
    echo -e "  ${CYAN}la${NC}      All files including hidden"
    echo -e "  ${CYAN}tree${NC}    Tree view"
    echo -e "  ${CYAN}lt${NC}      Tree (2 levels)"
    echo ""

    return 0
}

# =============================================================================
# Uninstall eza
# =============================================================================
uninstall() {
    print_divider "Uninstall eza"

    print_warning "This will remove eza from your system"

    if ! confirm "Are you sure you want to uninstall eza?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove via Homebrew
    if uninstall_brew "eza"; then
        # Clean up shell configuration
        print_info "Cleaning up shell configuration..."
        remove_from_zshrc "alias ls=.*eza" "pattern"
        remove_from_zshrc "alias ll=.*eza" "pattern"
        remove_from_zshrc "alias la=.*eza" "pattern"
        remove_from_zshrc "alias tree=.*eza" "pattern"
        remove_from_zshrc "alias lt=.*eza" "pattern"
        remove_from_zshrc "alias lsd=.*eza" "pattern"
        remove_from_zshrc "alias lsf=.*eza" "pattern"
        remove_from_zshrc "alias lst=.*eza" "pattern"
        remove_from_zshrc "alias lss=.*eza" "pattern"
        remove_from_zshrc "alias lg=.*eza" "pattern"
        remove_from_zshrc "EZA_COLORS" "pattern"

        print_success "eza uninstalled"
    else
        print_error "Failed to uninstall eza"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}eza Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install eza (default)"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove eza completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install eza"
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
                print_info "eza is not installed"
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
