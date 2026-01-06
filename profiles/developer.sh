#!/usr/bin/env bash
# =============================================================================
# Developer Profile - Complete Developer Setup
# DR Custom Terminal
# =============================================================================
# Installs the complete suite of terminal tools for developers:
#
#   Base (from Minimal profile):
#     - Xcode Command Line Tools
#     - Homebrew
#     - Oh My ZSH
#     - MesloLGS Nerd Font
#     - Powerlevel10k
#
#   ZSH Plugins:
#     - zsh-autosuggestions (Fish-like suggestions)
#     - zsh-syntax-highlighting (Command highlighting)
#     - zsh-completions (Additional completions)
#     - zsh-history-substring-search (Better history search)
#
#   CLI Utilities:
#     - fzf (Fuzzy finder)
#     - bat (Better cat with syntax highlighting)
#     - eza (Modern ls replacement)
#     - ripgrep (Fast grep alternative)
#     - fd (Fast find alternative)
#     - zoxide (Smart cd)
#     - delta (Beautiful git diffs)
#     - lazygit (Git TUI)
#
# This profile provides everything a developer needs for maximum productivity.
# =============================================================================

# Prevent direct execution - should be sourced by install.sh
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script should be sourced by install.sh, not executed directly."
    echo "Run: ./install.sh developer"
    exit 1
fi

# =============================================================================
# Profile Configuration
# =============================================================================
PROFILE_NAME="Developer"
PROFILE_DESCRIPTION="Complete developer setup with all productivity tools"

# Module categories in dependency order
DEVELOPER_BASE=(
    "xcode-cli:base:Xcode Command Line Tools"
    "homebrew:base:Homebrew"
)

DEVELOPER_SHELL=(
    "oh-my-zsh:shell:Oh My ZSH"
)

DEVELOPER_FONTS=(
    "nerd-fonts:fonts:Nerd Fonts (MesloLGS)"
)

DEVELOPER_PROMPT=(
    "powerlevel10k:prompt:Powerlevel10k"
)

DEVELOPER_PLUGINS=(
    "zsh-autosuggestions:plugins:zsh-autosuggestions"
    "zsh-syntax-highlighting:plugins:zsh-syntax-highlighting"
    "zsh-completions:plugins:zsh-completions"
    "zsh-history-substring-search:plugins:zsh-history-substring-search"
)

DEVELOPER_UTILS=(
    "fzf:utils:fzf (Fuzzy Finder)"
    "bat:utils:bat (Better cat)"
    "eza:utils:eza (Modern ls)"
    "ripgrep:utils:ripgrep (Fast grep)"
    "fd:utils:fd (Fast find)"
    "zoxide:utils:zoxide (Smart cd)"
    "delta:utils:delta (Git diffs)"
    "lazygit:utils:lazygit (Git TUI)"
)

# =============================================================================
# Helper Functions
# =============================================================================
get_module_path() {
    local module_category="$1"
    local module_name="$2"

    case "$module_category" in
        base)    echo "${MODULES_BASE}/${module_name}.sh" ;;
        shell)   echo "${MODULES_SHELL}/${module_name}.sh" ;;
        fonts)   echo "${MODULES_FONTS}/${module_name}.sh" ;;
        prompt)  echo "${MODULES_PROMPT}/${module_name}.sh" ;;
        plugins) echo "${MODULES_PLUGINS}/${module_name}.sh" ;;
        utils)   echo "${MODULES_UTILS}/${module_name}.sh" ;;
    esac
}

install_module_entry() {
    local module_entry="$1"
    local step="$2"
    local total="$3"
    local extra_args="${4:-}"

    # Parse module entry (format: name:category:display_name)
    local module_name="${module_entry%%:*}"
    local rest="${module_entry#*:}"
    local module_category="${rest%%:*}"
    local module_display="${rest#*:}"

    local module_path
    module_path=$(get_module_path "$module_category" "$module_name")

    echo ""
    print_step "$step" "$total" "Installing ${module_display}"
    log "Starting: ${module_display}"

    if [[ ! -f "$module_path" ]]; then
        print_error "Module not found: $module_path"
        FAILED_MODULES+=("${module_display}")
        log "ERROR: Module not found - ${module_display}"
        return 1
    fi

    local install_cmd="bash \"$module_path\" install"
    if [[ -n "$extra_args" ]]; then
        install_cmd="bash \"$module_path\" $extra_args"
    fi

    if eval "$install_cmd"; then
        print_success "${module_display} installed successfully"
        INSTALLED_MODULES+=("${module_display}")
        log "SUCCESS: ${module_display}"
        return 0
    else
        print_warning "Issues with ${module_display}"
        INSTALLED_MODULES+=("${module_display} (with warnings)")
        log "WARNING: ${module_display} had issues"
        return 0  # Continue despite warnings
    fi
}

# =============================================================================
# Profile Execution
# =============================================================================
run_developer_profile() {
    print_divider "Installing ${PROFILE_NAME} Profile"

    # Calculate total steps
    local total=0
    local skipped=0

    # Count base modules (may skip xcode-cli)
    for entry in "${DEVELOPER_BASE[@]}"; do
        local name="${entry%%:*}"
        if [[ "$name" == "xcode-cli" ]] && xcode-select -p &>/dev/null; then
            ((skipped++))
        else
            ((total++))
        fi
    done

    total=$((total + ${#DEVELOPER_SHELL[@]}))
    total=$((total + ${#DEVELOPER_FONTS[@]}))
    total=$((total + ${#DEVELOPER_PROMPT[@]}))
    total=$((total + ${#DEVELOPER_PLUGINS[@]}))
    total=$((total + ${#DEVELOPER_UTILS[@]}))

    local current=0

    log "Profile: ${PROFILE_NAME}"
    log "Total modules: ${total}"

    # Phase 1: Base Components
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 1: Base Components" 50 "$BOLD_CYAN" "$DIM"

    for module_entry in "${DEVELOPER_BASE[@]}"; do
        local module_name="${module_entry%%:*}"

        # Skip Xcode CLT if already installed
        if [[ "$module_name" == "xcode-cli" ]]; then
            if xcode-select -p &>/dev/null; then
                print_info "Xcode Command Line Tools already installed, skipping"
                continue
            fi
        fi

        ((current++))
        install_module_entry "$module_entry" "$current" "$total"
    done

    # Phase 2: Shell Framework
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 2: Shell Framework" 50 "$BOLD_CYAN" "$DIM"

    for module_entry in "${DEVELOPER_SHELL[@]}"; do
        ((current++))
        install_module_entry "$module_entry" "$current" "$total"
    done

    # Phase 3: Fonts
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 3: Fonts" 50 "$BOLD_CYAN" "$DIM"

    for module_entry in "${DEVELOPER_FONTS[@]}"; do
        ((current++))
        local module_name="${module_entry%%:*}"

        # Quick install MesloLGS specifically
        echo ""
        print_step "$current" "$total" "Installing Nerd Fonts (MesloLGS)"
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
    done

    # Phase 4: Prompt Theme
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 4: Prompt Theme" 50 "$BOLD_CYAN" "$DIM"

    for module_entry in "${DEVELOPER_PROMPT[@]}"; do
        ((current++))
        install_module_entry "$module_entry" "$current" "$total"
    done

    # Phase 5: ZSH Plugins
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 5: ZSH Plugins" 50 "$BOLD_CYAN" "$DIM"

    for module_entry in "${DEVELOPER_PLUGINS[@]}"; do
        ((current++))
        install_module_entry "$module_entry" "$current" "$total"
    done

    # Phase 6: CLI Utilities
    # -------------------------------------------------------------------------
    echo ""
    ascii_section_header "Phase 6: CLI Utilities" 50 "$BOLD_CYAN" "$DIM"

    for module_entry in "${DEVELOPER_UTILS[@]}"; do
        ((current++))
        install_module_entry "$module_entry" "$current" "$total"
    done

    # Profile completion message
    # -------------------------------------------------------------------------
    echo ""
    print_divider "Developer Profile Complete"

    local installed_count=${#INSTALLED_MODULES[@]}
    local failed_count=${#FAILED_MODULES[@]}

    echo ""
    echo -e "  ${BOLD}Installed:${NC} ${installed_count} modules"
    if [[ $skipped -gt 0 ]]; then
        echo -e "  ${BOLD}Skipped:${NC} ${skipped} modules (already installed)"
    fi
    if [[ $failed_count -gt 0 ]]; then
        echo -e "  ${BOLD}Failed:${NC} ${failed_count} modules"
    fi
    echo ""

    # Show quick tips for installed utilities
    show_developer_tips

    return 0
}

# =============================================================================
# Developer Tips
# =============================================================================
show_developer_tips() {
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
# Profile Status Check
# =============================================================================
check_developer_status() {
    echo -e "\n${BOLD}Developer Profile Status:${NC}\n"

    echo -e "  ${BOLD}Base Components:${NC}"

    # Check Xcode CLT
    if xcode-select -p &>/dev/null; then
        echo -e "    ${GREEN}${ICON_SUCCESS}${NC} Xcode Command Line Tools"
    else
        echo -e "    ${RED}${ICON_ERROR}${NC} Xcode Command Line Tools"
    fi

    # Check Homebrew
    if command_exists brew; then
        echo -e "    ${GREEN}${ICON_SUCCESS}${NC} Homebrew"
    else
        echo -e "    ${RED}${ICON_ERROR}${NC} Homebrew"
    fi

    # Check Oh My ZSH
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        echo -e "    ${GREEN}${ICON_SUCCESS}${NC} Oh My ZSH"
    else
        echo -e "    ${RED}${ICON_ERROR}${NC} Oh My ZSH"
    fi

    # Check Nerd Fonts
    if fc-list 2>/dev/null | grep -qi "MesloLG"; then
        echo -e "    ${GREEN}${ICON_SUCCESS}${NC} MesloLGS Nerd Font"
    else
        echo -e "    ${RED}${ICON_ERROR}${NC} MesloLGS Nerd Font"
    fi

    # Check Powerlevel10k
    local p10k_omz="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ -d "$p10k_omz" ]] || [[ -d "$HOME/.powerlevel10k" ]]; then
        echo -e "    ${GREEN}${ICON_SUCCESS}${NC} Powerlevel10k"
    else
        echo -e "    ${RED}${ICON_ERROR}${NC} Powerlevel10k"
    fi

    echo ""
    echo -e "  ${BOLD}ZSH Plugins:${NC}"

    local custom_plugins="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

    local plugins=("zsh-autosuggestions" "zsh-syntax-highlighting" "zsh-completions" "zsh-history-substring-search")
    for plugin in "${plugins[@]}"; do
        if [[ -d "${custom_plugins}/${plugin}" ]]; then
            echo -e "    ${GREEN}${ICON_SUCCESS}${NC} ${plugin}"
        else
            echo -e "    ${RED}${ICON_ERROR}${NC} ${plugin}"
        fi
    done

    echo ""
    echo -e "  ${BOLD}CLI Utilities:${NC}"

    local utils=("fzf" "bat" "eza" "rg:ripgrep" "fd" "zoxide" "delta" "lazygit")
    for util_entry in "${utils[@]}"; do
        local cmd="${util_entry%%:*}"
        local display="${util_entry#*:}"
        [[ "$cmd" == "$display" ]] && display="$cmd"

        if command_exists "$cmd"; then
            echo -e "    ${GREEN}${ICON_SUCCESS}${NC} ${display}"
        else
            echo -e "    ${RED}${ICON_ERROR}${NC} ${display}"
        fi
    done

    echo ""
}

# =============================================================================
# Export Functions
# =============================================================================
export -f run_developer_profile
export -f check_developer_status
export -f show_developer_tips
