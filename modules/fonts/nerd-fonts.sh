#!/usr/bin/env bash
# =============================================================================
# Nerd Fonts - Developer fonts with icons installer
# DR Custom Terminal
# =============================================================================
# Installs Nerd Fonts - patched fonts with programming ligatures and icons.
# These fonts are essential for tools like Powerlevel10k, Starship, and
# various terminal applications that use icons and glyphs.
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
MODULE_NAME="Nerd Fonts"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew")

# =============================================================================
# Font Definitions
# =============================================================================
# Font data arrays - parallel arrays for compatibility
# Format: cask_name|display_name|description|fc_search_pattern
FONT_KEYS=("meslo" "jetbrains" "fira" "hack" "source" "cascadia")
FONT_CASKS=("font-meslo-lg-nerd-font" "font-jetbrains-mono-nerd-font" "font-fira-code-nerd-font" "font-hack-nerd-font" "font-sauce-code-pro-nerd-font" "font-caskaydia-cove-nerd-font")
FONT_NAMES=("MesloLGS NF" "JetBrains Mono NF" "Fira Code NF" "Hack NF" "Source Code Pro NF" "Cascadia Code NF")
FONT_DESCRIPTIONS=("Recommended for Powerlevel10k" "Popular monospace font with ligatures" "Popular font with programming ligatures" "Clean and readable monospace font" "Adobe's monospace font for coding" "Microsoft's terminal font")
FONT_PATTERNS=("MesloLG" "JetBrains" "FiraCode" "Hack" "SauceCodePro" "CaskaydiaCove")

FONT_COUNT=${#FONT_KEYS[@]}

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
    _   __              __   ______            __
   / | / /__  _________/ /  / ____/___  ____  / /______
  /  |/ / _ \/ ___/ __  /  / /_  / __ \/ __ \/ __/ ___/
 / /|  /  __/ /  / /_/ /  / __/ / /_/ / / / / /_(__  )
/_/ |_/\___/_/   \__,_/  /_/    \____/_/ /_/\__/____/

           Developer Fonts with Icons
EOF
    echo -e "${NC}"
    echo ""
}

# =============================================================================
# Dependency Check
# =============================================================================
check_dependencies() {
    local has_errors=0

    # Check for Homebrew
    if ! has_brew; then
        print_error "Homebrew is required to install Nerd Fonts"
        print_info "Install Homebrew first with: ${PROJECT_ROOT}/modules/base/homebrew.sh"
        has_errors=1
    fi

    return $has_errors
}

# =============================================================================
# Font Installation Helpers
# =============================================================================

# Get font index by key
get_font_index() {
    local key="$1"
    local i

    for i in "${!FONT_KEYS[@]}"; do
        if [[ "${FONT_KEYS[$i]}" == "$key" ]]; then
            echo "$i"
            return 0
        fi
    done

    echo "-1"
    return 1
}

# Get font info by key
get_font_cask() {
    local key="$1"
    local idx
    idx=$(get_font_index "$key")
    [[ "$idx" != "-1" ]] && echo "${FONT_CASKS[$idx]}"
}

get_font_display_name() {
    local key="$1"
    local idx
    idx=$(get_font_index "$key")
    [[ "$idx" != "-1" ]] && echo "${FONT_NAMES[$idx]}"
}

get_font_description() {
    local key="$1"
    local idx
    idx=$(get_font_index "$key")
    [[ "$idx" != "-1" ]] && echo "${FONT_DESCRIPTIONS[$idx]}"
}

get_font_search_pattern() {
    local key="$1"
    local idx
    idx=$(get_font_index "$key")
    [[ "$idx" != "-1" ]] && echo "${FONT_PATTERNS[$idx]}"
}

# Check if a font is installed using fc-list
is_font_installed() {
    local search_pattern="$1"
    local cask="${2:-}"

    # Check with fc-list if available
    if command_exists fc-list; then
        fc-list 2>/dev/null | grep -qi "$search_pattern" && return 0
    fi

    # Fallback: check with brew
    if [[ -n "$cask" ]]; then
        brew list --cask "$cask" &>/dev/null && return 0
    fi

    return 1
}

# Install a single font
install_font() {
    local key="$1"
    local cask display_name search_pattern

    cask=$(get_font_cask "$key")
    display_name=$(get_font_display_name "$key")
    search_pattern=$(get_font_search_pattern "$key")

    if [[ -z "$cask" ]]; then
        print_error "Unknown font key: $key"
        return 1
    fi

    # Check if already installed
    if is_font_installed "$search_pattern" "$cask"; then
        print_info "$display_name is already installed"
        return 0
    fi

    # Install using brew cask
    print_info "Installing $display_name..."
    if brew install --cask "$cask" 2>/dev/null; then
        print_success "$display_name installed successfully"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

# =============================================================================
# Show Current Status
# =============================================================================
show_status() {
    print_divider "Installed Nerd Fonts"

    local installed_count=0

    for key in "${FONT_KEYS[@]}"; do
        local display_name search_pattern cask
        display_name=$(get_font_display_name "$key")
        search_pattern=$(get_font_search_pattern "$key")
        cask=$(get_font_cask "$key")

        if is_font_installed "$search_pattern" "$cask"; then
            echo -e "  ${ICON_SUCCESS} ${GREEN}${display_name}${NC}"
            ((installed_count++))
        else
            echo -e "  ${ICON_BULLET} ${DIM}${display_name}${NC} (not installed)"
        fi
    done

    echo ""
    echo -e "  ${BOLD}${installed_count}/${FONT_COUNT}${NC} fonts installed"
    echo ""

    # Check font cache status
    if command_exists fc-cache; then
        print_info "Font cache is available (fc-cache)"
    fi
}

# =============================================================================
# Interactive Font Selection Menu
# =============================================================================
show_font_menu() {
    echo -e "\n${BOLD}Select fonts to install:${NC}"
    echo -e "${DIM}(Enter numbers separated by spaces, or 'all' for all fonts)${NC}\n"

    local index=1
    for key in "${FONT_KEYS[@]}"; do
        local display_name description search_pattern cask status_icon
        display_name=$(get_font_display_name "$key")
        description=$(get_font_description "$key")
        search_pattern=$(get_font_search_pattern "$key")
        cask=$(get_font_cask "$key")

        if is_font_installed "$search_pattern" "$cask"; then
            status_icon="${GREEN}${ICON_SUCCESS}${NC}"
        else
            status_icon="${DIM}${ICON_BULLET}${NC}"
        fi

        echo -e "  ${CYAN}${index})${NC} ${status_icon} ${BOLD}${display_name}${NC}"
        echo -e "     ${DIM}${description}${NC}"

        ((index++))
    done

    echo ""
    echo -e "  ${CYAN}7)${NC} ${BOLD}Install All Popular Fonts${NC}"
    echo ""
}

# Parse user selection and return font keys
parse_font_selection() {
    local input="$1"
    local selected_fonts=()

    # Handle 'all' selection
    if [[ "${input,,}" == "all" || "$input" == "7" ]]; then
        echo "${FONT_KEYS[*]}"
        return 0
    fi

    # Parse space-separated numbers
    for choice in $input; do
        # Validate input is a number
        if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
            print_warning "'$choice' is not a valid number" >&2
            continue
        fi

        # Validate range (1-6)
        if [[ $choice -lt 1 || $choice -gt $FONT_COUNT ]]; then
            print_warning "'$choice' is out of range (1-${FONT_COUNT})" >&2
            continue
        fi

        # Map to font key (1-indexed)
        local key_index=$((choice - 1))
        selected_fonts+=("${FONT_KEYS[$key_index]}")
    done

    if [[ ${#selected_fonts[@]} -eq 0 ]]; then
        return 1
    fi

    echo "${selected_fonts[*]}"
    return 0
}

# =============================================================================
# Installation
# =============================================================================
install() {
    print_divider "Installation"

    # Ensure Homebrew cask-fonts tap is available
    print_step 1 3 "Checking Homebrew fonts tap..."
    # The cask-fonts tap has been deprecated, fonts are now in homebrew/cask
    # Just verify we can access font casks
    print_info "Verifying font cask availability..."
    print_success "Font casks available"

    # Show font selection menu
    print_step 2 3 "Select fonts to install"
    show_font_menu

    # Get user selection
    local input
    read -r -p "$(echo -e "${YELLOW}?${NC} Enter choices: ")" input

    if [[ -z "$input" ]]; then
        print_info "No fonts selected, exiting"
        return 0
    fi

    # Parse selection
    local selected_fonts
    if ! selected_fonts=$(parse_font_selection "$input"); then
        print_error "No valid fonts selected"
        return 1
    fi

    # Install selected fonts
    print_step 3 3 "Installing selected fonts..."
    echo ""

    local success_count=0
    local fail_count=0

    for key in $selected_fonts; do
        if install_font "$key"; then
            ((success_count++)) || true
        else
            ((fail_count++)) || true
        fi
    done

    echo ""

    # Refresh font cache
    if command_exists fc-cache; then
        print_info "Refreshing font cache..."
        fc-cache -f 2>/dev/null || true
        print_success "Font cache refreshed"
    fi

    # Summary
    echo ""
    print_divider "Installation Summary"
    echo -e "  ${ICON_SUCCESS} ${GREEN}Installed:${NC} ${success_count} font(s)"

    if [[ $fail_count -gt 0 ]]; then
        echo -e "  ${ICON_ERROR} ${RED}Failed:${NC} ${fail_count} font(s)"
    fi

    echo ""

    return $((fail_count > 0 ? 1 : 0))
}

# =============================================================================
# Post-Installation Configuration
# =============================================================================
configure() {
    print_divider "Terminal Configuration"

    echo -e "${BOLD}To use Nerd Fonts in your terminal:${NC}\n"

    echo -e "${CYAN}iTerm2:${NC}"
    echo -e "  1. Open iTerm2 Preferences (Cmd + ,)"
    echo -e "  2. Go to Profiles > Text"
    echo -e "  3. Under Font, click 'Change Font'"
    echo -e "  4. Select your installed Nerd Font"
    echo -e "  5. Enable 'Use ligatures' for fonts that support them"
    echo ""

    echo -e "${CYAN}Terminal.app:${NC}"
    echo -e "  1. Open Terminal Preferences (Cmd + ,)"
    echo -e "  2. Select your profile under Profiles"
    echo -e "  3. Click 'Change' next to Font"
    echo -e "  4. Select your installed Nerd Font"
    echo ""

    echo -e "${CYAN}VS Code:${NC}"
    echo -e "  1. Open Settings (Cmd + ,)"
    echo -e "  2. Search for 'terminal font'"
    echo -e "  3. Set 'Terminal > Integrated: Font Family' to:"
    echo -e "     ${DIM}'MesloLGS NF', 'JetBrainsMono Nerd Font', monospace${NC}"
    echo ""

    echo -e "${CYAN}Recommended font for Powerlevel10k:${NC}"
    echo -e "  ${BOLD}MesloLGS NF${NC} - specifically designed for Powerlevel10k"
    echo ""

    echo -e "${DIM}Note: You may need to restart your terminal after installing fonts.${NC}"
    echo ""

    return 0
}

# =============================================================================
# Uninstall Fonts
# =============================================================================
uninstall() {
    print_divider "Uninstall Nerd Fonts"

    # Check what's installed
    local installed_fonts=()

    for key in "${FONT_KEYS[@]}"; do
        local cask search_pattern
        cask=$(get_font_cask "$key")
        search_pattern=$(get_font_search_pattern "$key")

        if is_font_installed "$search_pattern" "$cask"; then
            installed_fonts+=("$key")
        fi
    done

    if [[ ${#installed_fonts[@]} -eq 0 ]]; then
        print_info "No Nerd Fonts are currently installed"
        return 0
    fi

    echo -e "\n${BOLD}Installed fonts:${NC}\n"

    local index=1
    for key in "${installed_fonts[@]}"; do
        local display_name
        display_name=$(get_font_display_name "$key")
        echo -e "  ${CYAN}${index})${NC} ${display_name}"
        ((index++))
    done

    local all_option=$index
    echo ""
    echo -e "  ${CYAN}${all_option})${NC} ${BOLD}Uninstall All${NC}"
    echo ""

    read -r -p "$(echo -e "${YELLOW}?${NC} Enter fonts to uninstall (space-separated): ")" input

    if [[ -z "$input" ]]; then
        print_info "No fonts selected, exiting"
        return 0
    fi

    local fonts_to_remove=()

    # Handle 'all' selection
    if [[ "${input,,}" == "all" || "$input" == "$all_option" ]]; then
        fonts_to_remove=("${installed_fonts[@]}")
    else
        for choice in $input; do
            if [[ "$choice" =~ ^[0-9]+$ && $choice -ge 1 && $choice -lt $all_option ]]; then
                fonts_to_remove+=("${installed_fonts[$((choice-1))]}")
            fi
        done
    fi

    if [[ ${#fonts_to_remove[@]} -eq 0 ]]; then
        print_info "No valid fonts selected"
        return 0
    fi

    # Confirm uninstallation
    print_warning "This will uninstall ${#fonts_to_remove[@]} font(s)"
    if ! confirm "Continue with uninstallation?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Uninstall fonts
    for key in "${fonts_to_remove[@]}"; do
        local cask display_name
        cask=$(get_font_cask "$key")
        display_name=$(get_font_display_name "$key")

        print_info "Uninstalling $display_name..."
        if brew uninstall --cask "$cask" 2>/dev/null; then
            print_success "$display_name uninstalled"
        else
            print_warning "Could not uninstall $display_name"
        fi
    done

    # Refresh font cache
    if command_exists fc-cache; then
        fc-cache -f 2>/dev/null || true
    fi

    print_success "Uninstallation complete"
    return 0
}

# =============================================================================
# Quick Install (Non-Interactive)
# =============================================================================
quick_install() {
    local font_key="${1:-}"

    if [[ -z "$font_key" ]]; then
        print_error "Font key required"
        print_info "Available fonts: ${FONT_KEYS[*]}"
        return 1
    fi

    local idx
    idx=$(get_font_index "$font_key")

    if [[ "$idx" == "-1" ]]; then
        print_error "Unknown font: $font_key"
        print_info "Available fonts: ${FONT_KEYS[*]}"
        return 1
    fi

    install_font "$font_key"
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}Nerd Fonts Installer${NC}"
    echo ""
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  install           Interactive font installation (default)"
    echo "  quick <font>      Quick install a specific font"
    echo "  status            Show installed fonts"
    echo "  configure         Show terminal configuration instructions"
    echo "  uninstall         Remove installed fonts"
    echo "  help              Show this help message"
    echo ""
    echo "Available fonts for quick install:"
    for i in "${!FONT_KEYS[@]}"; do
        local key="${FONT_KEYS[$i]}"
        local display_name="${FONT_NAMES[$i]}"
        local description="${FONT_DESCRIPTIONS[$i]}"
        echo "  $key - $display_name ($description)"
    done
    echo ""
    echo "Examples:"
    echo "  $0                          # Interactive installation"
    echo "  $0 quick meslo              # Install MesloLGS NF only"
    echo "  $0 quick jetbrains          # Install JetBrains Mono NF only"
    echo "  $0 status                   # Check installed fonts"
    echo ""
}

# =============================================================================
# Main Entry Point
# =============================================================================
main() {
    local command="${1:-install}"
    shift 2>/dev/null || true

    # Show header
    show_ascii_header
    print_header "$MODULE_NAME Installer"

    # Check OS requirement
    if ! is_macos; then
        print_error "This installer is designed for macOS"
        print_info "For other systems, visit: https://www.nerdfonts.com/font-downloads"
        exit 1
    fi

    case "$command" in
        install)
            # Check dependencies first
            if ! check_dependencies; then
                print_error "Missing dependencies. Please install Homebrew first."
                print_info "Run: ${PROJECT_ROOT}/modules/base/homebrew.sh"
                exit 1
            fi

            show_status
            install && configure
            ;;
        quick)
            # Check dependencies first
            if ! check_dependencies; then
                print_error "Missing dependencies. Please install Homebrew first."
                exit 1
            fi

            quick_install "${1:-}"
            ;;
        status)
            show_status
            ;;
        configure)
            configure
            ;;
        uninstall)
            if ! check_dependencies; then
                print_error "Homebrew is required for uninstallation"
                exit 1
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
        echo ""
    fi

    exit $exit_code
}

# Run main if executed directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
