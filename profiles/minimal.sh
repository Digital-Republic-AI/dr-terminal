#!/usr/bin/env bash
# =============================================================================
# Minimal Profile - Basic Terminal Enhancement
# DR Custom Terminal
# =============================================================================
# Installs the essential components for a beautiful and functional terminal:
#   - Xcode Command Line Tools (if not present)
#   - Homebrew (package manager)
#   - Oh My ZSH (shell framework)
#   - MesloLGS Nerd Font (for icons)
#   - Powerlevel10k (beautiful prompt)
#
# This profile provides a solid foundation that can be extended later.
# =============================================================================

# Prevent direct execution - should be sourced by install.sh
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script should be sourced by install.sh, not executed directly."
    echo "Run: ./install.sh minimal"
    exit 1
fi

# =============================================================================
# Profile Configuration
# =============================================================================
PROFILE_NAME="Minimal"
PROFILE_DESCRIPTION="Basic terminal enhancement with essential tools"

# Module list in dependency order
MINIMAL_MODULES=(
    "xcode-cli:base:Xcode Command Line Tools"
    "homebrew:base:Homebrew"
    "oh-my-zsh:shell:Oh My ZSH"
    "nerd-fonts:fonts:Nerd Fonts (MesloLGS)"
    "powerlevel10k:prompt:Powerlevel10k"
)

# =============================================================================
# Profile Execution
# =============================================================================
run_minimal_profile() {
    print_divider "Installing ${PROFILE_NAME} Profile"

    local total=${#MINIMAL_MODULES[@]}
    local current=0
    local skipped=0

    log "Profile: ${PROFILE_NAME}"
    log "Total modules: ${total}"

    for module_entry in "${MINIMAL_MODULES[@]}"; do
        # Parse module entry (format: name:category:display_name)
        local module_name="${module_entry%%:*}"
        local rest="${module_entry#*:}"
        local module_category="${rest%%:*}"
        local module_display="${rest#*:}"

        ((current++))

        # Determine module path
        local module_path=""
        case "$module_category" in
            base)
                module_path="${MODULES_BASE}/${module_name}.sh"
                ;;
            shell)
                module_path="${MODULES_SHELL}/${module_name}.sh"
                ;;
            fonts)
                module_path="${MODULES_FONTS}/${module_name}.sh"
                ;;
            prompt)
                module_path="${MODULES_PROMPT}/${module_name}.sh"
                ;;
        esac

        # Special handling for Xcode CLI
        if [[ "$module_name" == "xcode-cli" ]]; then
            if xcode-select -p &>/dev/null; then
                print_info "[${current}/${total}] ${module_display} already installed, skipping"
                ((skipped++))
                continue
            fi
        fi

        # Special handling for Nerd Fonts (quick install MesloLGS)
        if [[ "$module_name" == "nerd-fonts" ]]; then
            echo ""
            print_step "$current" "$total" "Installing ${module_display}"
            log "Starting: ${module_display}"

            if [[ -f "$module_path" ]]; then
                if bash "$module_path" quick meslo; then
                    print_success "${module_display} installed successfully"
                    INSTALLED_MODULES+=("${module_display}")
                    log "SUCCESS: ${module_display}"
                else
                    print_error "Failed to install ${module_display}"
                    FAILED_MODULES+=("${module_display}")
                    log "ERROR: ${module_display}"
                fi
            else
                print_error "Module not found: $module_path"
                FAILED_MODULES+=("${module_display}")
            fi
            continue
        fi

        # Standard module installation
        echo ""
        print_step "$current" "$total" "Installing ${module_display}"
        log "Starting: ${module_display}"

        if [[ -f "$module_path" ]]; then
            if bash "$module_path" install; then
                print_success "${module_display} installed successfully"
                INSTALLED_MODULES+=("${module_display}")
                log "SUCCESS: ${module_display}"
            else
                print_warning "Issues with ${module_display} (continuing...)"
                # Don't add to FAILED_MODULES for non-critical warnings
                if [[ "$module_name" != "xcode-cli" && "$module_name" != "homebrew" ]]; then
                    INSTALLED_MODULES+=("${module_display} (with warnings)")
                else
                    FAILED_MODULES+=("${module_display}")
                fi
                log "WARNING: ${module_display} had issues"
            fi
        else
            print_error "Module not found: $module_path"
            FAILED_MODULES+=("${module_display}")
            log "ERROR: Module not found - ${module_display}"
        fi
    done

    # Profile completion message
    echo ""
    print_divider "Minimal Profile Complete"

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

    return 0
}

# =============================================================================
# Profile Status Check
# =============================================================================
check_minimal_status() {
    echo -e "\n${BOLD}Minimal Profile Status:${NC}\n"

    # Check Xcode CLT
    if xcode-select -p &>/dev/null; then
        echo -e "  ${GREEN}${ICON_SUCCESS}${NC} Xcode Command Line Tools"
    else
        echo -e "  ${RED}${ICON_ERROR}${NC} Xcode Command Line Tools"
    fi

    # Check Homebrew
    if command_exists brew; then
        echo -e "  ${GREEN}${ICON_SUCCESS}${NC} Homebrew ($(brew --version 2>/dev/null | head -1 | awk '{print $2}'))"
    else
        echo -e "  ${RED}${ICON_ERROR}${NC} Homebrew"
    fi

    # Check Oh My ZSH
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        echo -e "  ${GREEN}${ICON_SUCCESS}${NC} Oh My ZSH"
    else
        echo -e "  ${RED}${ICON_ERROR}${NC} Oh My ZSH"
    fi

    # Check Nerd Fonts (MesloLGS)
    if fc-list 2>/dev/null | grep -qi "MesloLG"; then
        echo -e "  ${GREEN}${ICON_SUCCESS}${NC} MesloLGS Nerd Font"
    else
        echo -e "  ${RED}${ICON_ERROR}${NC} MesloLGS Nerd Font"
    fi

    # Check Powerlevel10k
    local p10k_omz="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    local p10k_manual="$HOME/.powerlevel10k"
    if [[ -d "$p10k_omz" ]] || [[ -d "$p10k_manual" ]]; then
        echo -e "  ${GREEN}${ICON_SUCCESS}${NC} Powerlevel10k"
    else
        echo -e "  ${RED}${ICON_ERROR}${NC} Powerlevel10k"
    fi

    echo ""
}

# =============================================================================
# Export Functions
# =============================================================================
export -f run_minimal_profile
export -f check_minimal_status
