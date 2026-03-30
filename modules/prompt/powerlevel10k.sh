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

set -euo pipefail

trap 'echo -e "\n${RED:-}Installation interrupted.${NC:-}"; exit 1' INT TERM

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
show_ascii_header() {
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
    [[ -d "$P10K_OMZ_DIR" ]] || [[ -d "$P10K_MANUAL_DIR" ]]
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    local p10k_dir=""

    if [[ -d "$P10K_OMZ_DIR/.git" ]]; then
        p10k_dir="$P10K_OMZ_DIR"
    elif [[ -d "$P10K_MANUAL_DIR/.git" ]]; then
        p10k_dir="$P10K_MANUAL_DIR"
    fi

    if [[ -n "$p10k_dir" ]]; then
        git -C "$p10k_dir" describe --tags --abbrev=0 2>/dev/null || echo "unknown"
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

        if [[ -d "$P10K_OMZ_DIR" ]]; then
            echo -e "  ${ICON_BULLET} Location: ${DIM}${P10K_OMZ_DIR}${NC}"
            echo -e "  ${ICON_BULLET} Mode: Oh My ZSH theme"
        else
            echo -e "  ${ICON_BULLET} Location: ${DIM}${P10K_MANUAL_DIR}${NC}"
            echo -e "  ${ICON_BULLET} Mode: Manual installation"
        fi

        echo ""

        local zshrc_path
        zshrc_path="$(get_zshrc_path)"

        if grep -Fq "powerlevel10k" "$zshrc_path" 2>/dev/null; then
            print_success "Theme configured in .zshrc"
        else
            print_warning "Theme not configured in .zshrc"
        fi

        if grep -Fq "p10k-instant-prompt" "$zshrc_path" 2>/dev/null; then
            print_success "Instant prompt enabled"
        else
            print_warning "Instant prompt not enabled"
        fi

        if [[ -f "$HOME/.p10k.zsh" ]]; then
            print_success "p10k configuration file exists"
        else
            print_warning "No p10k configuration (run: p10k configure)"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Nerd Font Check
# =============================================================================
check_nerd_fonts() {
    print_divider "Nerd Font Check"

    local nerd_font_installed=false

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
    fi

    print_warning "No Nerd Font detected"
    echo ""
    echo -e "${YELLOW}Powerlevel10k works best with a Nerd Font for icons.${NC}"
    echo ""

    local nerd_fonts_script="${PROJECT_ROOT}/modules/fonts/nerd-fonts.sh"

    if [[ -f "$nerd_fonts_script" ]] && has_brew; then
        print_info "Installing MesloLGS NF..."
        if bash "$nerd_fonts_script" quick meslo; then
            print_success "MesloLGS NF installed"
            return 0
        fi
        print_warning "Font installation failed, continuing without Nerd Font"
    else
        print_warning "Homebrew not available, skipping font installation"
        print_info "Install manually later: brew install font-meslo-lg-nerd-font"
    fi

    return 0
}

# =============================================================================
# Installation Functions
# =============================================================================
install_with_omz() {
    print_divider "Installing for Oh My ZSH"

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
        if clone_repo_shallow "$P10K_REPO" "$P10K_OMZ_DIR"; then
            print_success "Powerlevel10k cloned successfully"
        else
            print_error "Failed to clone Powerlevel10k"
            return 1
        fi
    fi

    print_info "Configuring theme in .zshrc..."
    backup_zshrc
    set_omz_theme "powerlevel10k/powerlevel10k"

    return 0
}

install_manual() {
    print_divider "Manual Installation (without Oh My ZSH)"

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

    if grep -Fq "p10k-instant-prompt" "$zshrc_path" 2>/dev/null; then
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

        local temp_file
        temp_file="$(mktemp)"

        echo "$instant_prompt_block" > "$temp_file"
        echo "" >> "$temp_file"
        cat "$zshrc_path" >> "$temp_file"

        if mv "$temp_file" "$zshrc_path"; then
            print_success "Instant prompt enabled"
        else
            print_error "Failed to enable instant prompt"
            rm -f "$temp_file"
            return 1
        fi
    fi
}

configure_p10k_source() {
    print_divider "p10k Configuration"

    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if grep -Fq ".p10k.zsh" "$zshrc_path" 2>/dev/null; then
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
        print_info "Please run the following command after restarting your shell:"
        echo -e "  ${CYAN}p10k configure${NC}"
        echo ""
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
        echo -e "  ${DIM}brew install font-meslo-lg-nerd-font${NC}"
        echo ""
    fi

    echo -e "${DIM}For more information: https://github.com/romkatv/powerlevel10k${NC}"
    echo ""
}

# =============================================================================
# Install (full flow)
# =============================================================================
install() {
    if ! check_dependencies; then
        print_error "Missing dependencies. Please install git first."
        return 1
    fi

    check_nerd_fonts || return 1

    echo ""
    if has_omz; then
        install_with_omz || return 1
    else
        install_manual || return 1
    fi

    configure_instant_prompt
    configure_p10k_source
    show_instructions
    offer_configuration

    return 0
}

# =============================================================================
# Uninstallation
# =============================================================================
uninstall() {
    print_divider "Uninstall ${MODULE_NAME}"

    if ! is_installed; then
        print_info "Powerlevel10k is not installed"
        return 0
    fi

    if confirm "Remove Powerlevel10k and its configuration?" "n"; then
        if [[ -d "$P10K_OMZ_DIR" ]]; then
            rm -rf "$P10K_OMZ_DIR"
            print_success "Removed: $P10K_OMZ_DIR"
        fi

        if [[ -d "$P10K_MANUAL_DIR" ]]; then
            rm -rf "$P10K_MANUAL_DIR"
            print_success "Removed: $P10K_MANUAL_DIR"
        fi

        if [[ -f "$HOME/.p10k.zsh" ]]; then
            if confirm "Remove ~/.p10k.zsh configuration?" "y"; then
                rm -f "$HOME/.p10k.zsh"
                print_success "Removed: ~/.p10k.zsh"
            fi
        fi

        print_info "Remember to update ZSH_THEME in ~/.zshrc"
        print_info "And remove the Powerlevel10k source line and instant prompt"

        print_success "Powerlevel10k uninstalled"
    else
        print_info "Uninstallation cancelled"
    fi
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}Powerlevel10k Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install Powerlevel10k (default)"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove Powerlevel10k completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install Powerlevel10k"
    echo "  $0 status       # Check installation status"
    echo ""
}

# =============================================================================
# Main Entry Point
# =============================================================================
main() {
    local command="${1:-install}"

    show_ascii_header
    print_header "$MODULE_NAME Installer"

    case "$command" in
        install)
            if is_installed; then
                show_status
                print_warning "$MODULE_NAME is already installed"

                if confirm "Reconfigure $MODULE_NAME?"; then
                    if has_omz; then
                        set_omz_theme "powerlevel10k/powerlevel10k"
                    fi
                    configure_instant_prompt
                    configure_p10k_source
                    offer_configuration
                fi
                exit 0
            fi

            install
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
