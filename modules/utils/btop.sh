#!/usr/bin/env bash
# =============================================================================
# btop - Modern Resource Monitor
# DR Custom Terminal
# =============================================================================
# btop++ is a modern resource monitor with a beautiful terminal UI. It shows
# CPU, memory, disk, network, and process information with graphs and themes.
# A significant upgrade from htop with GPU monitoring support.
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
MODULE_NAME="btop"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew")

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
  _     _
 | |__ | |_ ___  _ __
 | '_ \| __/ _ \| '_ \
 | |_) | || (_) | |_) |
 |_.__/ \__\___/| .__/
                |_|

 Modern Resource Monitor
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
    command_exists btop
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    if is_installed; then
        btop --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1
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
        echo -e "  ${ICON_BULLET} Location: ${DIM}$(which btop)${NC}"
        echo ""

        # Check for config
        local config_dir="${HOME}/.config/btop"
        if [[ -f "${config_dir}/btop.conf" ]]; then
            print_success "Configuration file exists"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Install btop
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
    print_step 2 2 "Installing btop..."
    if ! install_with_brew "btop" "btop"; then
        print_error "Failed to install btop"
        return 1
    fi

    return 0
}

# =============================================================================
# Configure btop
# =============================================================================
configure() {
    print_divider "Configuration"

    # Create config directory
    local config_dir="${HOME}/.config/btop"
    local config_file="${config_dir}/btop.conf"
    local themes_dir="${config_dir}/themes"

    mkdir -p "$config_dir"
    mkdir -p "$themes_dir"

    # Theme selection
    echo ""
    print_info "btop includes many built-in themes. Select one:"
    echo ""
    echo -e "  ${CYAN}1)${NC} Default (dark)"
    echo -e "  ${CYAN}2)${NC} Dracula"
    echo -e "  ${CYAN}3)${NC} Nord"
    echo -e "  ${CYAN}4)${NC} Gruvbox Dark"
    echo -e "  ${CYAN}5)${NC} One Dark"
    echo -e "  ${CYAN}6)${NC} Catppuccin Mocha"
    echo -e "  ${CYAN}7)${NC} Tokyo Night"
    echo -e "  ${CYAN}8)${NC} Solarized Dark"
    echo ""

    local theme_choice
    read -r -p "$(echo -e "${YELLOW}?${NC} Select theme [1-8, default=1]: ")" theme_choice
    theme_choice="${theme_choice:-1}"

    local selected_theme
    case "$theme_choice" in
        1) selected_theme="Default" ;;
        2) selected_theme="dracula" ;;
        3) selected_theme="nord" ;;
        4) selected_theme="gruvbox_dark" ;;
        5) selected_theme="onedark" ;;
        6) selected_theme="catppuccin_mocha" ;;
        7) selected_theme="tokyo-night" ;;
        8) selected_theme="solarized_dark" ;;
        *) selected_theme="Default" ;;
    esac

    # Create configuration file
    if confirm "Create btop configuration file?" "y"; then
        print_info "Creating configuration..."

        cat > "$config_file" << EOF
# btop configuration file
# Generated by DR Custom Terminal

# Color theme
color_theme = "${selected_theme}"

# Set to true to enable 24-bit truecolor
truecolor = true

# Set to true to force tty mode
force_tty = false

# Presets for the position of the boxes
presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty"

# Enable vim keys for navigation
vim_keys = true

# Rounded corners on boxes
rounded_corners = true

# Default symbols to use for graph drawing
graph_symbol = "braille"

# Manually set which boxes to show (cpu, mem, net, proc)
shown_boxes = "cpu mem net proc"

# Update time in milliseconds
update_ms = 2000

# Processes sorting
proc_sorting = "cpu lazy"

# Reverse sorting order
proc_reversed = false

# Show processes as a tree
proc_tree = false

# Which cpu to show in "cpu box"
cpu_graph_upper = "total"
cpu_graph_lower = "total"

# Show cpu stats per core
cpu_single_graph = false

# Toggle cpu box showing temperatures
check_temp = true

# Which sensor to use for cpu temp
cpu_sensor = "Auto"

# Show memory values in percentage instead of bytes
mem_graphs = true
mem_below_net = false

# Show net upload/download
net_download = 100
net_upload = 100
net_auto = true
net_sync = true

# Show GPU stats (if available)
show_gpu_info = Auto

# Show battery stats (if available)
show_battery = true

# Logging
log_level = "WARNING"
EOF

        print_success "Configuration saved to: $config_file"
        print_success "Theme set to: $selected_theme"
    fi

    # Alias suggestion
    if confirm "Add alias 'top' -> 'btop'?" "n"; then
        add_alias_zshrc "top" "btop" "btop: replace top"
        print_success "top alias added"
    fi

    if confirm "Add alias 'htop' -> 'btop'?" "n"; then
        add_alias_zshrc "htop" "btop" "btop: replace htop"
        print_success "htop alias added"
    fi

    # Show usage
    echo ""
    print_divider "Usage"
    echo ""
    echo -e "  ${BOLD}Start btop:${NC}"
    echo ""
    echo -e "  ${CYAN}btop${NC}              Launch btop"
    echo ""
    echo -e "  ${BOLD}Key bindings:${NC}"
    echo ""
    echo -e "  ${CYAN}h/l or Left/Right${NC}    Switch between boxes"
    echo -e "  ${CYAN}j/k or Up/Down${NC}       Navigate within boxes"
    echo -e "  ${CYAN}Enter${NC}                Select/Toggle"
    echo -e "  ${CYAN}t${NC}                    Toggle tree view"
    echo -e "  ${CYAN}r${NC}                    Reverse sort order"
    echo -e "  ${CYAN}f${NC}                    Filter processes"
    echo -e "  ${CYAN}c${NC}                    Toggle compact mode"
    echo -e "  ${CYAN}p${NC}                    Cycle presets"
    echo -e "  ${CYAN}m${NC}                    Toggle options menu"
    echo -e "  ${CYAN}Esc${NC}                  Back/Cancel"
    echo -e "  ${CYAN}q${NC}                    Quit"
    echo ""
    echo -e "  ${BOLD}Features:${NC}"
    echo ""
    echo -e "  ${ICON_BULLET} CPU usage graphs and temperature"
    echo -e "  ${ICON_BULLET} Memory and swap usage"
    echo -e "  ${ICON_BULLET} Disk I/O statistics"
    echo -e "  ${ICON_BULLET} Network upload/download"
    echo -e "  ${ICON_BULLET} Process list with tree view"
    echo -e "  ${ICON_BULLET} GPU stats (if available)"
    echo -e "  ${ICON_BULLET} Battery status (on laptops)"
    echo ""

    return 0
}

# =============================================================================
# Uninstall btop
# =============================================================================
uninstall() {
    print_divider "Uninstall btop"

    print_warning "This will remove btop from your system"

    if ! confirm "Are you sure you want to uninstall btop?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove via Homebrew
    if uninstall_brew "btop"; then
        # Clean up shell configuration
        print_info "Cleaning up shell configuration..."
        remove_from_zshrc "alias top=.*btop" "pattern"
        remove_from_zshrc "alias htop=.*btop" "pattern"

        # Ask about config removal
        local config_dir="${HOME}/.config/btop"
        if [[ -d "$config_dir" ]]; then
            if confirm "Remove btop configuration?" "n"; then
                rm -rf "$config_dir"
                print_success "Configuration removed"
            else
                print_info "Configuration kept at: $config_dir"
            fi
        fi

        print_success "btop uninstalled"
    else
        print_error "Failed to uninstall btop"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}btop Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install btop (default)"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove btop completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install btop"
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
                print_info "btop is not installed"
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
        print_info "Run 'btop' to start the resource monitor"
        echo ""
    fi

    exit $exit_code
}

# Run main if executed directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
