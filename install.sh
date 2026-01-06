#!/usr/bin/env bash
# =============================================================================
# DR Custom Terminal - Main Installer
# =============================================================================
# The ultimate terminal customization toolkit for macOS. This installer
# orchestrates the installation of Oh My ZSH, Nerd Fonts, Powerlevel10k,
# and various productivity utilities to create the perfect terminal setup.
#
# Usage:
#   ./install.sh              # Interactive installation
#   ./install.sh minimal      # Quick minimal setup
#   ./install.sh developer    # Full developer setup
#   ./install.sh --help       # Show help
#
# Repository: https://github.com/yourusername/terminal-customization
# =============================================================================

set -euo pipefail

# Cleanup trap for interrupted installation
trap 'echo -e "\n${RED}Installation interrupted.${NC}"; exit 1' INT TERM

# Get absolute paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PROJECT_ROOT="$SCRIPT_DIR"

# Source core libraries
source "${PROJECT_ROOT}/core/colors.sh"
source "${PROJECT_ROOT}/core/ui.sh"
source "${PROJECT_ROOT}/core/validators.sh"
source "${PROJECT_ROOT}/themes/ascii-art/logos/main.sh"

# =============================================================================
# Installer Configuration
# =============================================================================
INSTALLER_VERSION="1.0.0"
LOG_FILE="${PROJECT_ROOT}/.install.log"

# Module paths
MODULES_BASE="${PROJECT_ROOT}/modules/base"
MODULES_SHELL="${PROJECT_ROOT}/modules/shell"
MODULES_FONTS="${PROJECT_ROOT}/modules/fonts"
MODULES_PROMPT="${PROJECT_ROOT}/modules/prompt"
MODULES_PLUGINS="${PROJECT_ROOT}/modules/plugins"
MODULES_UTILS="${PROJECT_ROOT}/modules/utils"
PROFILES_DIR="${PROJECT_ROOT}/profiles"

# Installation tracking
declare -a INSTALLED_MODULES=()
declare -a FAILED_MODULES=()
TOTAL_STEPS=0
CURRENT_STEP=0

# =============================================================================
# Logging
# =============================================================================
log() {
    local message="$1"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    echo "[$timestamp] $message" >> "$LOG_FILE"
}

# =============================================================================
# ASCII Art Welcome
# =============================================================================
show_welcome() {
    clear

    # Display main logo
    ascii_logo_main

    echo ""
    echo -e "${DIM}Version ${INSTALLER_VERSION} | macOS Terminal Setup${NC}"
    echo ""
    ascii_divider_fancy 68
    echo ""
}

# =============================================================================
# Pre-flight Checks
# =============================================================================
preflight_checks() {
    print_divider "Pre-flight Checks"

    local has_errors=0

    # Check OS
    if is_macos; then
        print_success "macOS detected: $(sw_vers -productVersion 2>/dev/null || echo 'unknown')"
    else
        print_error "This installer is designed for macOS"
        has_errors=1
    fi

    # Check architecture
    local arch
    arch="$(uname -m)"
    print_info "Architecture: $arch"

    # Check for internet connectivity
    if has_internet; then
        print_success "Internet connection available"
    else
        print_error "No internet connection detected"
        print_info "Please connect to the internet and try again"
        has_errors=1
    fi

    # Check for required commands
    if command_exists curl; then
        print_success "curl is available"
    else
        print_error "curl is required but not found"
        has_errors=1
    fi

    if command_exists git; then
        print_success "git is available"
    else
        print_warning "git is not installed (will be installed via Xcode CLT)"
    fi

    # Check for existing installations
    echo ""
    print_info "Checking for existing installations..."

    if command_exists brew; then
        print_info "  Homebrew: $(brew --version 2>/dev/null | head -1 | awk '{print $2}')"
    else
        print_info "  Homebrew: not installed"
    fi

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_info "  Oh My ZSH: installed"
    else
        print_info "  Oh My ZSH: not installed"
    fi

    echo ""

    return $has_errors
}

# =============================================================================
# Profile Definitions
# =============================================================================
show_profile_details() {
    local profile="$1"

    case "$profile" in
        1|minimal)
            echo -e "\n${BOLD}Minimal Profile${NC}"
            echo -e "${DIM}Basic terminal enhancement with essential tools${NC}\n"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} Homebrew (package manager)"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} Oh My ZSH (shell framework)"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} MesloLGS Nerd Font"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} Powerlevel10k (beautiful prompt)"
            echo ""
            ;;
        2|developer)
            echo -e "\n${BOLD}Developer Profile${NC}"
            echo -e "${DIM}Complete setup with all productivity tools${NC}\n"
            echo -e "  ${BOLD}Base:${NC}"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} Everything in Minimal profile"
            echo ""
            echo -e "  ${BOLD}ZSH Plugins:${NC}"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} zsh-autosuggestions (fish-like suggestions)"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} zsh-syntax-highlighting"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} zsh-completions"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} zsh-history-substring-search"
            echo ""
            echo -e "  ${BOLD}CLI Utilities:${NC}"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} fzf (fuzzy finder)"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} bat (better cat)"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} eza (modern ls)"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} ripgrep (fast grep)"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} fd (find alternative)"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} zoxide (smart cd)"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} delta (git diff viewer)"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} lazygit (git TUI)"
            echo ""
            ;;
        3|custom)
            echo -e "\n${BOLD}Custom Profile${NC}"
            echo -e "${DIM}Choose exactly what you want to install${NC}\n"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} Interactive module selection"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} Pick and choose each component"
            echo -e "  ${CYAN}${ICON_BULLET}${NC} Skip components you don't need"
            echo ""
            ;;
    esac
}

# =============================================================================
# Profile Selection Menu
# =============================================================================
select_profile() {
    print_divider "Select Installation Profile"

    echo ""
    echo -e "  ${CYAN}1)${NC} ${BOLD}Minimal${NC}"
    echo -e "     ${DIM}Homebrew + Oh My ZSH + Powerlevel10k + Nerd Fonts${NC}"
    echo ""
    echo -e "  ${CYAN}2)${NC} ${BOLD}Developer${NC}"
    echo -e "     ${DIM}Minimal + all ZSH plugins + essential utilities${NC}"
    echo ""
    echo -e "  ${CYAN}3)${NC} ${BOLD}Custom${NC}"
    echo -e "     ${DIM}Interactive module selection${NC}"
    echo ""

    while true; do
        read -r -p "$(echo -e "${YELLOW}?${NC} Select profile [1-3]: ")" choice

        case "$choice" in
            1)
                show_profile_details "minimal"
                if confirm "Install Minimal profile?"; then
                    echo "minimal"
                    return 0
                fi
                ;;
            2)
                show_profile_details "developer"
                if confirm "Install Developer profile?"; then
                    echo "developer"
                    return 0
                fi
                ;;
            3)
                show_profile_details "custom"
                if confirm "Continue with Custom installation?"; then
                    echo "custom"
                    return 0
                fi
                ;;
            *)
                print_warning "Please enter 1, 2, or 3"
                ;;
        esac
    done
}

# =============================================================================
# Custom Module Selection
# =============================================================================
select_custom_modules() {
    local -a selected_base=()
    local -a selected_shell=()
    local -a selected_fonts=()
    local -a selected_prompt=()
    local -a selected_plugins=()
    local -a selected_utils=()

    print_divider "Base Components"
    echo ""

    # Always install base components
    echo -e "  ${BOLD}Required:${NC}"
    echo -e "  ${GREEN}${ICON_SUCCESS}${NC} Xcode Command Line Tools (if needed)"
    echo -e "  ${GREEN}${ICON_SUCCESS}${NC} Homebrew"
    echo ""
    selected_base=("xcode-cli" "homebrew")

    # Shell framework
    print_divider "Shell Framework"
    if confirm "Install Oh My ZSH (ZSH framework)?"; then
        selected_shell+=("oh-my-zsh")
    fi

    # Fonts
    print_divider "Fonts"
    if confirm "Install Nerd Fonts (required for icons)?"; then
        echo -e "\n${BOLD}Select fonts to install:${NC}\n"
        echo -e "  ${CYAN}1)${NC} MesloLGS NF (recommended for Powerlevel10k)"
        echo -e "  ${CYAN}2)${NC} JetBrains Mono NF"
        echo -e "  ${CYAN}3)${NC} All popular fonts"
        echo ""

        read -r -p "$(echo -e "${YELLOW}?${NC} Select font option [1-3]: ")" font_choice
        case "$font_choice" in
            1) selected_fonts=("meslo") ;;
            2) selected_fonts=("jetbrains") ;;
            3) selected_fonts=("all") ;;
            *)
                print_warning "Invalid selection. Using default: MesloLGS NF"
                selected_fonts=("meslo")
                ;;
        esac
    fi

    # Prompt theme
    print_divider "Prompt Theme"
    echo -e "\n${BOLD}Select prompt theme:${NC}\n"
    echo -e "  ${CYAN}1)${NC} Powerlevel10k (highly customizable, recommended)"
    echo -e "  ${CYAN}2)${NC} Starship (minimal, fast)"
    echo -e "  ${CYAN}3)${NC} None"
    echo ""

    read -r -p "$(echo -e "${YELLOW}?${NC} Select prompt [1-3]: ")" prompt_choice
    case "$prompt_choice" in
        1) selected_prompt=("powerlevel10k") ;;
        2) selected_prompt=("starship") ;;
        *) selected_prompt=() ;;
    esac

    # Plugins (only if Oh My ZSH selected)
    if [[ " ${selected_shell[*]} " =~ " oh-my-zsh " ]]; then
        print_divider "ZSH Plugins"
        echo -e "\n${BOLD}Select plugins to install:${NC}\n"

        local -a plugin_options=("zsh-autosuggestions" "zsh-syntax-highlighting" "zsh-completions" "zsh-history-substring-search")
        for plugin in "${plugin_options[@]}"; do
            if confirm "Install $plugin?"; then
                selected_plugins+=("$plugin")
            fi
        done
    fi

    # Utilities
    print_divider "CLI Utilities"
    echo -e "\n${BOLD}Select utilities to install:${NC}\n"

    local -a util_options=("fzf:Fuzzy finder" "bat:Better cat" "eza:Modern ls" "ripgrep:Fast grep" "fd:Find alternative" "zoxide:Smart cd" "delta:Git diff viewer" "lazygit:Git TUI" "btop:System monitor" "neofetch:System info")

    for util_entry in "${util_options[@]}"; do
        local util_name="${util_entry%%:*}"
        local util_desc="${util_entry#*:}"
        if confirm "Install $util_name ($util_desc)?"; then
            selected_utils+=("$util_name")
        fi
    done

    # Return selections via global variables
    CUSTOM_BASE=("${selected_base[@]}")
    CUSTOM_SHELL=("${selected_shell[@]}")
    CUSTOM_FONTS=("${selected_fonts[@]}")
    CUSTOM_PROMPT=("${selected_prompt[@]}")
    CUSTOM_PLUGINS=("${selected_plugins[@]}")
    CUSTOM_UTILS=("${selected_utils[@]}")
}

# =============================================================================
# Module Execution
# =============================================================================
run_module() {
    local module_path="$1"
    local module_name="$2"
    local options="${3:-}"

    ((CURRENT_STEP++))

    echo ""
    print_step "$CURRENT_STEP" "$TOTAL_STEPS" "Installing $module_name"
    log "Starting installation: $module_name"

    if [[ ! -f "$module_path" ]]; then
        print_error "Module not found: $module_path"
        FAILED_MODULES+=("$module_name")
        log "ERROR: Module not found: $module_path"
        return 1
    fi

    # Run the module
    if bash "$module_path" $options; then
        print_success "$module_name installed successfully"
        INSTALLED_MODULES+=("$module_name")
        log "SUCCESS: $module_name installed"
        return 0
    else
        print_error "Failed to install $module_name"
        FAILED_MODULES+=("$module_name")
        log "ERROR: Failed to install $module_name"
        return 1
    fi
}

# =============================================================================
# Installation Orchestration
# =============================================================================
calculate_steps() {
    local profile="$1"

    case "$profile" in
        minimal)
            TOTAL_STEPS=4  # xcode-cli, homebrew, oh-my-zsh, nerd-fonts, powerlevel10k
            # Adjust: xcode-cli might be skipped if already installed
            if xcode-select -p &>/dev/null; then
                TOTAL_STEPS=3
            fi
            ;;
        developer)
            TOTAL_STEPS=16  # All modules
            if xcode-select -p &>/dev/null; then
                ((TOTAL_STEPS--))
            fi
            ;;
        custom)
            TOTAL_STEPS=${#CUSTOM_BASE[@]}
            TOTAL_STEPS=$((TOTAL_STEPS + ${#CUSTOM_SHELL[@]}))
            TOTAL_STEPS=$((TOTAL_STEPS + ${#CUSTOM_FONTS[@]}))
            TOTAL_STEPS=$((TOTAL_STEPS + ${#CUSTOM_PROMPT[@]}))
            TOTAL_STEPS=$((TOTAL_STEPS + ${#CUSTOM_PLUGINS[@]}))
            TOTAL_STEPS=$((TOTAL_STEPS + ${#CUSTOM_UTILS[@]}))
            ;;
    esac
}

install_profile() {
    local profile="$1"

    log "Starting installation: profile=$profile"

    case "$profile" in
        minimal)
            source "${PROFILES_DIR}/minimal.sh"
            run_minimal_profile
            ;;
        developer)
            source "${PROFILES_DIR}/developer.sh"
            run_developer_profile
            ;;
        custom)
            run_custom_installation
            ;;
    esac
}

run_custom_installation() {
    # Base modules (always required)
    for module in "${CUSTOM_BASE[@]}"; do
        case "$module" in
            xcode-cli)
                if ! xcode-select -p &>/dev/null; then
                    run_module "${MODULES_BASE}/xcode-cli.sh" "Xcode Command Line Tools"
                else
                    print_info "Xcode Command Line Tools already installed, skipping"
                fi
                ;;
            homebrew)
                run_module "${MODULES_BASE}/homebrew.sh" "Homebrew"
                ;;
        esac
    done

    # Shell framework
    for module in "${CUSTOM_SHELL[@]}"; do
        run_module "${MODULES_SHELL}/${module}.sh" "Oh My ZSH"
    done

    # Fonts
    for font in "${CUSTOM_FONTS[@]}"; do
        if [[ "$font" == "all" ]]; then
            run_module "${MODULES_FONTS}/nerd-fonts.sh" "Nerd Fonts" "install"
        else
            run_module "${MODULES_FONTS}/nerd-fonts.sh" "Nerd Font ($font)" "quick $font"
        fi
    done

    # Prompt theme
    for prompt in "${CUSTOM_PROMPT[@]}"; do
        run_module "${MODULES_PROMPT}/${prompt}.sh" "$prompt"
    done

    # Plugins
    for plugin in "${CUSTOM_PLUGINS[@]}"; do
        run_module "${MODULES_PLUGINS}/${plugin}.sh" "$plugin"
    done

    # Utilities
    for util in "${CUSTOM_UTILS[@]}"; do
        run_module "${MODULES_UTILS}/${util}.sh" "$util"
    done
}

# =============================================================================
# Installation Summary
# =============================================================================
show_summary() {
    echo ""
    ascii_divider_fancy 68
    print_divider "Installation Summary"

    # Show installed modules
    if [[ ${#INSTALLED_MODULES[@]} -gt 0 ]]; then
        echo -e "\n${BOLD_GREEN}Successfully Installed:${NC}"
        for module in "${INSTALLED_MODULES[@]}"; do
            echo -e "  ${GREEN}${ICON_SUCCESS}${NC} $module"
        done
    fi

    # Show failed modules
    if [[ ${#FAILED_MODULES[@]} -gt 0 ]]; then
        echo -e "\n${BOLD_RED}Failed to Install:${NC}"
        for module in "${FAILED_MODULES[@]}"; do
            echo -e "  ${RED}${ICON_ERROR}${NC} $module"
        done
    fi

    echo ""

    # Overall status
    if [[ ${#FAILED_MODULES[@]} -eq 0 ]]; then
        echo -e "${BOLD_GREEN}Installation completed successfully!${NC}"
    else
        echo -e "${BOLD_YELLOW}Installation completed with some errors.${NC}"
        echo -e "Check the log file for details: ${DIM}${LOG_FILE}${NC}"
    fi

    echo ""
}

# =============================================================================
# Next Steps
# =============================================================================
show_next_steps() {
    print_divider "Next Steps"

    echo ""
    echo -e "  ${BOLD}1.${NC} ${CYAN}Restart your terminal${NC}"
    echo -e "     ${DIM}Or run: source ~/.zshrc${NC}"
    echo ""

    # Powerlevel10k configuration
    if [[ " ${INSTALLED_MODULES[*]} " =~ "owerlevel10k" ]] || [[ " ${INSTALLED_MODULES[*]} " =~ "p10k" ]]; then
        echo -e "  ${BOLD}2.${NC} ${CYAN}Configure Powerlevel10k${NC}"
        echo -e "     ${DIM}Run: p10k configure${NC}"
        echo ""
    fi

    # Font configuration
    echo -e "  ${BOLD}3.${NC} ${CYAN}Set your terminal font${NC}"
    echo -e "     ${DIM}In iTerm2: Preferences > Profiles > Text > Font${NC}"
    echo -e "     ${DIM}Select: MesloLGS NF (or your installed Nerd Font)${NC}"
    echo ""

    # Links
    print_divider "Useful Links"
    echo ""
    echo -e "  ${CYAN}${ICON_BULLET}${NC} Powerlevel10k: ${DIM}https://github.com/romkatv/powerlevel10k${NC}"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} Oh My ZSH:     ${DIM}https://ohmyz.sh${NC}"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} Nerd Fonts:    ${DIM}https://www.nerdfonts.com${NC}"
    echo ""

    # Final message
    ascii_divider_fancy 68
    echo ""
    echo -e "  ${BOLD_CYAN}Enjoy your new terminal setup!${NC}"
    echo ""
}

# =============================================================================
# Help
# =============================================================================
show_help() {
    show_welcome

    echo -e "${BOLD}Usage:${NC}"
    echo "  ./install.sh [profile]"
    echo ""
    echo -e "${BOLD}Profiles:${NC}"
    echo "  (none)      Interactive installation with profile selection"
    echo "  minimal     Quick minimal setup (Homebrew, Oh My ZSH, P10k)"
    echo "  developer   Full developer setup with all tools"
    echo ""
    echo -e "${BOLD}Options:${NC}"
    echo "  --help, -h     Show this help message"
    echo "  --version, -v  Show version"
    echo ""
    echo -e "${BOLD}Examples:${NC}"
    echo "  ./install.sh           # Interactive installation"
    echo "  ./install.sh minimal   # Quick minimal setup"
    echo "  ./install.sh developer # Full developer setup"
    echo ""
}

# =============================================================================
# Main Entry Point
# =============================================================================
main() {
    # Initialize log file
    echo "DR Custom Terminal - Installation Log" > "$LOG_FILE"
    echo "Started: $(date)" >> "$LOG_FILE"
    echo "========================================" >> "$LOG_FILE"

    # Parse arguments
    case "${1:-}" in
        --help|-h)
            show_help
            exit 0
            ;;
        --version|-v)
            echo "DR Custom Terminal v${INSTALLER_VERSION}"
            exit 0
            ;;
        minimal)
            show_welcome
            if ! preflight_checks; then
                print_error "Pre-flight checks failed"
                exit 1
            fi
            if confirm "Install Minimal profile?"; then
                show_profile_details "minimal"
                calculate_steps "minimal"
                install_profile "minimal"
                show_summary
                show_next_steps
            fi
            ;;
        developer)
            show_welcome
            if ! preflight_checks; then
                print_error "Pre-flight checks failed"
                exit 1
            fi
            if confirm "Install Developer profile?"; then
                show_profile_details "developer"
                calculate_steps "developer"
                install_profile "developer"
                show_summary
                show_next_steps
            fi
            ;;
        *)
            # Interactive mode
            show_welcome

            if ! preflight_checks; then
                print_error "Pre-flight checks failed"
                exit 1
            fi

            # Select profile
            local selected_profile
            selected_profile=$(select_profile)

            # Handle custom module selection
            if [[ "$selected_profile" == "custom" ]]; then
                select_custom_modules
            fi

            # Calculate steps and confirm
            calculate_steps "$selected_profile"

            echo ""
            print_divider "Ready to Install"
            echo ""
            echo -e "  ${BOLD}Profile:${NC} $selected_profile"
            echo -e "  ${BOLD}Total modules:${NC} $TOTAL_STEPS"
            echo ""

            if ! confirm "Begin installation?"; then
                print_info "Installation cancelled"
                exit 0
            fi

            # Run installation
            install_profile "$selected_profile"

            # Show summary and next steps
            show_summary
            show_next_steps
            ;;
    esac

    log "Installation finished at $(date)"

    # Return appropriate exit code
    if [[ ${#FAILED_MODULES[@]} -gt 0 ]]; then
        exit 1
    fi
    exit 0
}

# Run main if executed directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
