#!/usr/bin/env bash
# =============================================================================
# Powerlevel10k - The Most Powerful Zsh Theme
# DR Custom Terminal
# =============================================================================
# Installs and configures Powerlevel10k, a blazing-fast theme for Zsh with
# extensive customization, git status, command timing, and beautiful icons.
#
# Features:
#   - Instant prompt for responsive shell startup
#   - Git status with detailed information
#   - Command execution time display
#   - Directory truncation with navigation hints
#   - Beautiful Nerd Font icon integration
#   - Highly configurable through p10k wizard
#
# Requirements:
#   - Git
#   - Oh My ZSH (or manual Zsh configuration)
#   - Nerd Font recommended for full icon support
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/core/colors.sh"
source "${PROJECT_ROOT}/core/ui.sh"
source "${PROJECT_ROOT}/core/validators.sh"
source "${PROJECT_ROOT}/core/installers.sh"
source "${PROJECT_ROOT}/core/shell-config.sh"

# =============================================================================
# Module Configuration
# =============================================================================
MODULE_NAME="Powerlevel10k"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("git")

readonly P10K_REPO="https://github.com/romkatv/powerlevel10k.git"
readonly P10K_OMZ_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
readonly P10K_MANUAL_DIR="$HOME/.powerlevel10k"

# =============================================================================
# ASCII Art Header
# =============================================================================
show_header() {
    echo ""
    echo -e "${BOLD_CYAN}"
    cat << 'EOF'
    ____                          __                 __   _____ ____  __
   / __ \____ _      _____  _____/ /__ _   _____    / /  <  / // __ \/ /__
  / /_/ / __ \ | /| / / _ \/ ___/ / _ \ | / / _ \  / /   / / // / / / //_/
 / ____/ /_/ / |/ |/ /  __/ /  / /  __/ |/ /  __/ / /___/ / // /_/ / ,<
/_/    \____/|__/|__/\___/_/  /_/\___/|___/\___/ /_____/_/_/ \____/_/|_|

EOF
    echo -e "${NC}"
    echo -e "${DIM}    The most powerful theme for Zsh - Emphasize speed, flexibility & out-of-the-box experience${NC}"
    echo ""
}

# =============================================================================
# Dependency Checks
# =============================================================================
check_dependencies() {
    print_divider "Checking Dependencies"

    local missing=()

    # Check git
    if command_exists git; then
        print_success "Git is installed"
    else
        print_error "Git is not installed"
        missing+=("git")
    fi

    # Check Oh My ZSH
    if has_omz; then
        print_success "Oh My ZSH is installed"
    else
        print_warning "Oh My ZSH is not installed (will use manual installation)"
    fi

    # Check for Zsh as default shell
    if is_zsh_default_shell; then
        print_success "Zsh is your default shell"
    else
        print_warning "Zsh is not your default shell"
        print_info "  Consider running: chsh -s \$(which zsh)"
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo ""
        print_error "Missing required dependencies: ${missing[*]}"
        return 1
    fi

    return 0
}

# =============================================================================
# Nerd Font Check
# =============================================================================
check_nerd_fonts() {
    print_divider "Nerd Font Check"

    local nerd_font_installed=false

    # Check for common Nerd Font installations
    local font_dirs=(
        "$HOME/Library/Fonts"
        "/Library/Fonts"
        "$HOME/.local/share/fonts"
        "/usr/share/fonts"
    )

    for dir in "${font_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            if find "$dir" -type f \( -name "*Nerd*" -o -name "*NF*" \) 2>/dev/null | head -1 | grep -q .; then
                nerd_font_installed=true
                break
            fi
        fi
    done

    if [[ "$nerd_font_installed" == true ]]; then
        print_success "Nerd Font detected"
        return 0
    else
        print_warning "No Nerd Font detected"
        echo ""
        echo -e "${YELLOW}Powerlevel10k works best with a Nerd Font for icons.${NC}"
        echo ""
        echo "  Recommended fonts:"
        echo -e "  ${CYAN}${ICON_BULLET}${NC} MesloLGS NF (recommended by p10k)"
        echo -e "  ${CYAN}${ICON_BULLET}${NC} JetBrainsMono Nerd Font"
        echo -e "  ${CYAN}${ICON_BULLET}${NC} FiraCode Nerd Font"
        echo -e "  ${CYAN}${ICON_BULLET}${NC} Hack Nerd Font"
        echo ""
        echo -e "  Install via: ${DIM}brew tap homebrew/cask-fonts && brew install font-meslo-lg-nerd-font${NC}"
        echo ""

        if confirm "Continue without Nerd Font?" "y"; then
            return 0
        else
            print_info "Install a Nerd Font first, then run this installer again"
            return 1
        fi
    fi
}

# =============================================================================
# Installation Functions
# =============================================================================
install_with_omz() {
    print_divider "Installing for Oh My ZSH"

    # Clone to Oh My ZSH custom themes directory
    if [[ -d "$P10K_OMZ_DIR" ]]; then
        print_info "Powerlevel10k already installed at: $P10K_OMZ_DIR"

        if confirm "Update existing installation?" "n"; then
            print_info "Updating Powerlevel10k..."
            if git -C "$P10K_OMZ_DIR" pull --ff-only &>/dev/null; then
                print_success "Powerlevel10k updated"
            else
                print_warning "Update failed, trying fresh install..."
                rm -rf "$P10K_OMZ_DIR"
                clone_repo_shallow "$P10K_REPO" "$P10K_OMZ_DIR"
            fi
        fi
    else
        # Fresh installation
        if clone_repo_shallow "$P10K_REPO" "$P10K_OMZ_DIR"; then
            print_success "Powerlevel10k cloned successfully"
        else
            print_error "Failed to clone Powerlevel10k"
            return 1
        fi
    fi

    # Configure as Oh My ZSH theme
    print_info "Configuring theme in .zshrc..."
    backup_zshrc
    set_omz_theme "powerlevel10k/powerlevel10k"

    return 0
}

install_manual() {
    print_divider "Manual Installation (without Oh My ZSH)"

    # Clone to home directory
    if [[ -d "$P10K_MANUAL_DIR" ]]; then
        print_info "Powerlevel10k already installed at: $P10K_MANUAL_DIR"

        if confirm "Update existing installation?" "n"; then
            print_info "Updating Powerlevel10k..."
            if git -C "$P10K_MANUAL_DIR" pull --ff-only &>/dev/null; then
                print_success "Powerlevel10k updated"
            else
                print_warning "Update failed, trying fresh install..."
                rm -rf "$P10K_MANUAL_DIR"
                clone_repo_shallow "$P10K_REPO" "$P10K_MANUAL_DIR"
            fi
        fi
    else
        if clone_repo_shallow "$P10K_REPO" "$P10K_MANUAL_DIR"; then
            print_success "Powerlevel10k cloned successfully"
        else
            print_error "Failed to clone Powerlevel10k"
            return 1
        fi
    fi

    # Add source to .zshrc
    print_info "Configuring .zshrc..."
    backup_zshrc

    local source_line="source ${P10K_MANUAL_DIR}/powerlevel10k.zsh-theme"
    add_to_zshrc "$source_line" "Powerlevel10k theme"

    return 0
}

# =============================================================================
# Post-Installation Configuration
# =============================================================================
configure_instant_prompt() {
    print_divider "Instant Prompt Configuration"

    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Check if instant prompt is already configured
    if grep -q "powerlevel10k-instant-prompt" "$zshrc_path" 2>/dev/null; then
        print_info "Instant prompt already configured"
        return 0
    fi

    if confirm "Enable Instant Prompt for faster shell startup?" "y"; then
        local instant_prompt_block='# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi'

        # Add instant prompt to top of .zshrc
        local temp_file
        temp_file="$(mktemp)"
        echo "$instant_prompt_block" > "$temp_file"
        echo "" >> "$temp_file"
        cat "$zshrc_path" >> "$temp_file"
        mv "$temp_file" "$zshrc_path"

        print_success "Instant prompt enabled"
    fi
}

configure_p10k_source() {
    print_divider "p10k Configuration"

    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Check if p10k source is already in .zshrc
    if grep -q "\[p10k\].zsh" "$zshrc_path" 2>/dev/null; then
        print_info "p10k configuration source already present"
        return 0
    fi

    local p10k_source='# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh'

    echo "" >> "$zshrc_path"
    echo "$p10k_source" >> "$zshrc_path"

    print_success "p10k configuration source added"
}

# =============================================================================
# Configuration Wizard
# =============================================================================
offer_configuration() {
    print_divider "Configuration Wizard"

    echo ""
    echo -e "${BOLD}Powerlevel10k Configuration Options:${NC}"
    echo ""
    echo -e "  ${CYAN}1)${NC} Run the configuration wizard now (recommended)"
    echo -e "  ${CYAN}2)${NC} Skip for now (run 'p10k configure' later)"
    echo ""

    if confirm "Run the p10k configuration wizard now?" "y"; then
        echo ""
        print_info "Starting p10k configuration wizard..."
        print_info "This will customize your prompt appearance"
        echo ""

        # The wizard needs to run in a new Zsh session
        if [[ -n "${ZSH_VERSION:-}" ]]; then
            # Already in Zsh, source and run
            print_info "Please run 'p10k configure' after restarting your shell"
        else
            print_info "Starting a new Zsh session for configuration..."
            echo ""
            exec zsh -c 'source ~/.zshrc && p10k configure'
        fi
    else
        echo ""
        print_info "You can configure Powerlevel10k anytime by running:"
        echo -e "  ${CYAN}p10k configure${NC}"
    fi
}

# =============================================================================
# Usage Instructions
# =============================================================================
show_instructions() {
    print_divider "Setup Complete"

    echo ""
    echo -e "${BOLD_GREEN}Powerlevel10k has been installed successfully!${NC}"
    echo ""

    echo -e "${BOLD}Next Steps:${NC}"
    echo ""
    echo -e "  ${CYAN}1.${NC} Restart your terminal or run: ${DIM}source ~/.zshrc${NC}"
    echo -e "  ${CYAN}2.${NC} Configure your prompt: ${DIM}p10k configure${NC}"
    echo ""

    echo -e "${BOLD}Useful Commands:${NC}"
    echo ""
    echo -e "  ${CYAN}${ICON_BULLET}${NC} ${DIM}p10k configure${NC}  - Run the configuration wizard"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} ${DIM}p10k reload${NC}     - Reload configuration"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} ${DIM}p10k segment${NC}    - Show available segments"
    echo ""

    echo -e "${BOLD}Configuration Files:${NC}"
    echo ""
    echo -e "  ${CYAN}${ICON_BULLET}${NC} ~/.p10k.zsh     - Your personalized p10k configuration"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} ~/.zshrc        - Shell configuration with p10k source"
    echo ""

    if ! check_nerd_fonts &>/dev/null; then
        echo -e "${YELLOW}Reminder:${NC} Install a Nerd Font for the best experience"
        echo -e "  ${DIM}brew tap homebrew/cask-fonts && brew install font-meslo-lg-nerd-font${NC}"
        echo ""
    fi

    echo -e "${DIM}For more information: https://github.com/romkatv/powerlevel10k${NC}"
    echo ""
}

# =============================================================================
# Uninstallation
# =============================================================================
uninstall() {
    print_header "Uninstall ${MODULE_NAME}"

    if confirm "Remove Powerlevel10k and its configuration?" "n"; then
        # Remove installation directory
        if [[ -d "$P10K_OMZ_DIR" ]]; then
            rm -rf "$P10K_OMZ_DIR"
            print_success "Removed: $P10K_OMZ_DIR"
        fi

        if [[ -d "$P10K_MANUAL_DIR" ]]; then
            rm -rf "$P10K_MANUAL_DIR"
            print_success "Removed: $P10K_MANUAL_DIR"
        fi

        # Remove p10k configuration
        if [[ -f "$HOME/.p10k.zsh" ]]; then
            if confirm "Remove ~/.p10k.zsh configuration?" "y"; then
                rm -f "$HOME/.p10k.zsh"
                print_success "Removed: ~/.p10k.zsh"
            fi
        fi

        # Reset theme in .zshrc
        print_info "Remember to update ZSH_THEME in ~/.zshrc"
        print_info "And remove the Powerlevel10k source line and instant prompt"

        print_success "Powerlevel10k uninstalled"
    else
        print_info "Uninstallation cancelled"
    fi
}

# =============================================================================
# Main Installation Flow
# =============================================================================
main() {
    show_header

    # Parse arguments
    case "${1:-}" in
        --uninstall|-u)
            uninstall
            return $?
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --help, -h       Show this help message"
            echo "  --uninstall, -u  Uninstall Powerlevel10k"
            echo ""
            return 0
            ;;
    esac

    # Check dependencies
    if ! check_dependencies; then
        return 1
    fi

    # Check for Nerd Fonts
    check_nerd_fonts || return 1

    # Install based on Oh My ZSH presence
    echo ""
    if has_omz; then
        install_with_omz || return 1
    else
        install_manual || return 1
    fi

    # Post-installation configuration
    configure_instant_prompt
    configure_p10k_source

    # Show instructions
    show_instructions

    # Offer to run configuration wizard
    offer_configuration

    return 0
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
