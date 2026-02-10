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
# Installation Plan Display
# =============================================================================
show_installation_plan() {
    print_divider "What Will Be Installed"

    echo ""
    echo -e "  ${BOLD}Base Components:${NC}"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} Xcode Command Line Tools"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} Homebrew (package manager)"
    echo ""
    echo -e "  ${BOLD}Shell Framework:${NC}"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} Oh My ZSH"
    echo ""
    echo -e "  ${BOLD}Fonts:${NC}"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} MesloLGS Nerd Font"
    echo ""
    echo -e "  ${BOLD}Prompt Theme:${NC}"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} Powerlevel10k"
    echo ""
    echo -e "  ${BOLD}ZSH Plugins:${NC}"
    echo -e "  ${CYAN}${ICON_BULLET}${NC} zsh-autosuggestions"
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
    TOTAL_STEPS=16
    if xcode-select -p &>/dev/null; then
        ((TOTAL_STEPS--))
    fi
}

run_installation() {
    log "Starting installation"

    # Phase 1: Base Components
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 1: Base Components" 50 "$BOLD_CYAN" "$DIM"

    # Xcode CLI - skip if already installed
    if ! xcode-select -p &>/dev/null; then
        run_module "${MODULES_BASE}/xcode-cli.sh" "Xcode Command Line Tools"
    else
        print_info "Xcode Command Line Tools already installed, skipping"
    fi

    run_module "${MODULES_BASE}/homebrew.sh" "Homebrew"

    # Phase 2: Shell Framework
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 2: Shell Framework" 50 "$BOLD_CYAN" "$DIM"

    run_module "${MODULES_SHELL}/oh-my-zsh.sh" "Oh My ZSH"

    # Phase 3: Fonts
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 3: Fonts" 50 "$BOLD_CYAN" "$DIM"

    # Quick install MesloLGS specifically
    ((CURRENT_STEP++))
    echo ""
    print_step "$CURRENT_STEP" "$TOTAL_STEPS" "Installing Nerd Fonts (MesloLGS)"
    log "Starting: Nerd Fonts"

    local module_path="${MODULES_FONTS}/nerd-fonts.sh"
    if [[ -f "$module_path" ]]; then
        if bash "$module_path" quick meslo; then
            print_success "Nerd Fonts (MesloLGS) installed successfully"
            INSTALLED_MODULES+=("Nerd Fonts (MesloLGS)")
            log "SUCCESS: Nerd Fonts"
        else
            print_warning "Issues with Nerd Fonts"
            INSTALLED_MODULES+=("Nerd Fonts (with warnings)")
            log "WARNING: Nerd Fonts had issues"
        fi
    else
        print_error "Module not found: $module_path"
        FAILED_MODULES+=("Nerd Fonts")
    fi

    # Phase 4: Prompt Theme
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 4: Prompt Theme" 50 "$BOLD_CYAN" "$DIM"

    run_module "${MODULES_PROMPT}/powerlevel10k.sh" "Powerlevel10k"

    # Phase 5: ZSH Plugins
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 5: ZSH Plugins" 50 "$BOLD_CYAN" "$DIM"

    run_module "${MODULES_PLUGINS}/zsh-autosuggestions.sh" "zsh-autosuggestions"
    run_module "${MODULES_PLUGINS}/zsh-syntax-highlighting.sh" "zsh-syntax-highlighting"
    run_module "${MODULES_PLUGINS}/zsh-completions.sh" "zsh-completions"
    run_module "${MODULES_PLUGINS}/zsh-history-substring-search.sh" "zsh-history-substring-search"

    # Phase 6: CLI Utilities
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 6: CLI Utilities" 50 "$BOLD_CYAN" "$DIM"

    run_module "${MODULES_UTILS}/fzf.sh" "fzf (Fuzzy Finder)"
    run_module "${MODULES_UTILS}/bat.sh" "bat (Better cat)"
    run_module "${MODULES_UTILS}/eza.sh" "eza (Modern ls)"
    run_module "${MODULES_UTILS}/ripgrep.sh" "ripgrep (Fast grep)"
    run_module "${MODULES_UTILS}/fd.sh" "fd (Fast find)"
    run_module "${MODULES_UTILS}/zoxide.sh" "zoxide (Smart cd)"
    run_module "${MODULES_UTILS}/delta.sh" "delta (Git diffs)"
    run_module "${MODULES_UTILS}/lazygit.sh" "lazygit (Git TUI)"

    echo ""
    print_divider "Installation Complete"
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
# Quick Tips
# =============================================================================
show_tips() {
    print_divider "Quick Tips"

    echo ""
    echo -e "  ${BOLD}Installed utilities and their key commands:${NC}"
    echo ""

    # Check each utility and show tips
    if command_exists fzf; then
        echo -e "  ${CYAN}fzf${NC}      CTRL-T (files), CTRL-R (history), ALT-C (cd)"
    fi

    if command_exists bat; then
        echo -e "  ${CYAN}bat${NC}      Use instead of 'cat' for syntax highlighting"
    fi

    if command_exists eza; then
        echo -e "  ${CYAN}eza${NC}      Use 'eza -la' for colorful file listing"
    fi

    if command_exists rg; then
        echo -e "  ${CYAN}ripgrep${NC}  Use 'rg <pattern>' for fast searching"
    fi

    if command_exists fd; then
        echo -e "  ${CYAN}fd${NC}       Use 'fd <pattern>' for fast file finding"
    fi

    if command_exists zoxide; then
        echo -e "  ${CYAN}zoxide${NC}   Use 'z <dir>' for smart directory jumping"
    fi

    if command_exists delta; then
        echo -e "  ${CYAN}delta${NC}    Git diffs now have syntax highlighting"
    fi

    if command_exists lazygit; then
        echo -e "  ${CYAN}lazygit${NC}  Run 'lazygit' for interactive git TUI"
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
    echo "  ./install.sh"
    echo ""
    echo -e "${BOLD}Options:${NC}"
    echo "  --help, -h     Show this help message"
    echo "  --version, -v  Show version"
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
        *)
            # Default installation flow
            show_welcome

            if ! preflight_checks; then
                print_error "Pre-flight checks failed"
                exit 1
            fi

            show_installation_plan

            echo ""
            if ! confirm "Start installation?"; then
                print_info "Installation cancelled"
                exit 0
            fi

            calculate_steps
            run_installation
            show_tips
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
