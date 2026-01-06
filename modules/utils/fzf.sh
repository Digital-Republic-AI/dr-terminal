#!/usr/bin/env bash
# =============================================================================
# fzf - Fuzzy Finder for Terminal
# DR Custom Terminal
# =============================================================================
# A command-line fuzzy finder that provides instant, interactive search for
# files, command history, and more. Integrates with shell keybindings for
# enhanced terminal productivity.
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
MODULE_NAME="fzf"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew")

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
   ___       ___
  / _|     / _|
 | |_ ____| |_
 |  _|_  /|  _|
 | |  / / | |
 |_| /___||_|

 Fuzzy Finder for Terminal
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
    command_exists fzf
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    if is_installed; then
        fzf --version 2>/dev/null | awk '{print $1}'
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
        echo -e "  ${ICON_BULLET} Location: ${DIM}$(which fzf)${NC}"
        echo ""

        # Check for shell integration
        local zshrc_path
        zshrc_path="$(get_zshrc_path)"
        if grep -q "fzf" "$zshrc_path" 2>/dev/null; then
            print_success "Shell integration configured"
        else
            print_warning "Shell integration not configured"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Install fzf
# =============================================================================
install() {
    print_divider "Installation"

    # Check for internet connectivity
    print_step 1 3 "Checking internet connection..."
    if ! has_internet; then
        print_error "No internet connection detected"
        return 1
    fi
    print_success "Internet connection available"

    # Install via Homebrew
    print_step 2 3 "Installing fzf..."
    if ! install_with_brew "fzf" "fzf"; then
        print_error "Failed to install fzf"
        return 1
    fi

    # Run fzf install script for keybindings
    print_step 3 3 "Setting up keybindings and completions..."
    local brew_prefix
    brew_prefix="$(get_brew_prefix)"

    if [[ -f "${brew_prefix}/opt/fzf/install" ]]; then
        # Run install script with options
        "${brew_prefix}/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
        print_success "Keybindings and completions installed"
    else
        print_warning "fzf install script not found, skipping keybindings setup"
    fi

    return 0
}

# =============================================================================
# Configure fzf
# =============================================================================
configure() {
    print_divider "Configuration"

    local zshrc_path
    zshrc_path="$(get_zshrc_path)"
    local brew_prefix
    brew_prefix="$(get_brew_prefix)"

    # Add fzf configuration to .zshrc
    print_info "Configuring shell integration..."

    # Source fzf keybindings
    local fzf_shell_dir="${brew_prefix}/opt/fzf/shell"
    if [[ -d "$fzf_shell_dir" ]]; then
        source_in_zshrc "${fzf_shell_dir}/completion.zsh" "fzf completion"
        source_in_zshrc "${fzf_shell_dir}/key-bindings.zsh" "fzf key bindings"
    fi

    # Add useful fzf configuration
    print_info "Adding fzf default options..."

    # Default options for fzf
    local fzf_default_opts='export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"'

    if ! grep -q "FZF_DEFAULT_OPTS" "$zshrc_path" 2>/dev/null; then
        add_to_zshrc "$fzf_default_opts" "fzf default options"
    else
        print_info "FZF_DEFAULT_OPTS already configured"
    fi

    # Offer to configure fd as default command (if available)
    if command_exists fd; then
        if confirm "Use 'fd' for faster file searching with fzf?"; then
            local fzf_default_command='export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"'
            add_to_zshrc "$fzf_default_command" "fzf default command (using fd)"

            local fzf_ctrl_t='export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"'
            add_to_zshrc "$fzf_ctrl_t" "fzf CTRL-T command"
        fi
    fi

    # Offer helpful aliases
    echo ""
    print_divider "Optional Aliases"

    if confirm "Add useful fzf aliases?"; then
        # Fuzzy history search
        add_alias_zshrc "fh" "history | fzf --tac" "fzf: fuzzy history search"

        # Fuzzy file preview
        if command_exists bat; then
            add_alias_zshrc "fp" "fzf --preview 'bat --style=numbers --color=always {}'" "fzf: fuzzy file preview with bat"
        else
            add_alias_zshrc "fp" "fzf --preview 'cat {}'" "fzf: fuzzy file preview"
        fi

        # Fuzzy cd (requires fd for best results)
        if command_exists fd; then
            add_alias_zshrc "fcd" "cd \$(fd --type d | fzf)" "fzf: fuzzy cd"
        fi

        print_success "Aliases added"
    fi

    # Show keybinding info
    echo ""
    print_divider "Keybindings"
    echo ""
    echo -e "  ${BOLD}Default keybindings:${NC}"
    echo ""
    echo -e "  ${CYAN}CTRL-T${NC}  Paste selected files onto command line"
    echo -e "  ${CYAN}CTRL-R${NC}  Search command history"
    echo -e "  ${CYAN}ALT-C${NC}   cd into selected directory"
    echo ""

    return 0
}

# =============================================================================
# Uninstall fzf
# =============================================================================
uninstall() {
    print_divider "Uninstall fzf"

    print_warning "This will remove fzf from your system"

    if ! confirm "Are you sure you want to uninstall fzf?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove via Homebrew
    if uninstall_brew "fzf"; then
        # Clean up shell configuration
        print_info "Cleaning up shell configuration..."
        remove_from_zshrc "fzf" "pattern"
        remove_from_zshrc "FZF_" "pattern"

        print_success "fzf uninstalled"
    else
        print_error "Failed to uninstall fzf"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}fzf Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install fzf (default)"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove fzf completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install fzf"
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
                print_info "fzf is not installed"
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
