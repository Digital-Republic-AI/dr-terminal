#!/usr/bin/env bash
# =============================================================================
# neofetch - System Information with ASCII Art
# DR Custom Terminal
# =============================================================================
# neofetch is a command-line system information tool that displays information
# about your operating system, software, and hardware alongside an ASCII logo.
# Highly customizable with many themes and configuration options.
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
MODULE_NAME="neofetch"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew")

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
                       __      _       _
  _ __   ___  ___    / _| ___| |_ ___| |__
 | '_ \ / _ \/ _ \  | |_ / _ \ __/ __| '_ \
 | | | |  __/ (_) | |  _|  __/ || (__| | | |
 |_| |_|\___|\___/  |_|  \___|\__\___|_| |_|

 System Information with ASCII Art
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
    command_exists neofetch
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    if is_installed; then
        neofetch --version 2>/dev/null | head -1 | awk '{print $2}'
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
        echo -e "  ${ICON_BULLET} Location: ${DIM}$(which neofetch)${NC}"
        echo ""

        # Check for config
        local config_file="${HOME}/.config/neofetch/config.conf"
        if [[ -f "$config_file" ]]; then
            print_success "Configuration file exists"
        fi

        # Check if added to shell startup
        local zshrc_path
        zshrc_path="$(get_zshrc_path)"
        if grep -q "neofetch" "$zshrc_path" 2>/dev/null; then
            print_success "Added to shell startup"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Install neofetch
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
    print_step 2 2 "Installing neofetch..."
    if ! install_with_brew "neofetch" "neofetch"; then
        print_error "Failed to install neofetch"
        return 1
    fi

    return 0
}

# =============================================================================
# Configure neofetch
# =============================================================================
configure() {
    print_divider "Configuration"

    # Create config directory and generate default config
    local config_dir="${HOME}/.config/neofetch"
    local config_file="${config_dir}/config.conf"

    mkdir -p "$config_dir"

    # Generate default config if it doesn't exist
    if [[ ! -f "$config_file" ]]; then
        print_info "Generating default configuration..."
        neofetch --print_config > "$config_file" 2>/dev/null || true
        print_success "Configuration created at: $config_file"
    fi

    # Customize info fields
    if confirm "Customize displayed information?" "y"; then
        print_info "Modifying configuration..."

        # Create a cleaner config
        cat > "$config_file" << 'EOF'
# neofetch configuration
# Generated by DR Custom Terminal

# See: https://github.com/dylanaraps/neofetch/wiki/Customizing-Info
print_info() {
    info title
    info underline

    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "Terminal" term
    info "CPU" cpu
    info "GPU" gpu
    info "Memory" memory

    info cols
}

# Title
title_fqdn="off"

# Kernel
kernel_shorthand="on"

# Distro
distro_shorthand="off"
os_arch="on"

# Uptime
uptime_shorthand="on"

# Memory
memory_percent="on"
memory_unit="gib"

# Packages
package_managers="on"

# Shell
shell_path="off"
shell_version="on"

# CPU
speed_type="bios_limit"
speed_shorthand="off"
cpu_brand="on"
cpu_speed="on"
cpu_cores="logical"
cpu_temp="off"

# GPU
gpu_brand="on"
gpu_type="all"

# Text Colors
colors=(distro)

# Text Options
bold="on"
underline_enabled="on"
underline_char="-"
separator=":"

# Color Blocks
block_range=(0 15)
color_blocks="on"
block_width=3
block_height=1
col_offset="auto"

# Progress Bars
bar_char_elapsed="-"
bar_char_total="="
bar_border="on"
bar_length=15
bar_color_elapsed="distro"
bar_color_total="distro"

# Info display
cpu_display="off"
memory_display="off"
battery_display="off"
disk_display="off"

# Backend Settings
image_backend="ascii"
image_source="auto"

# ASCII Options
ascii_distro="auto"
ascii_colors=(distro)
ascii_bold="on"

# Image Options
image_loop="off"
thumbnail_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch"
crop_mode="normal"
crop_offset="center"
image_size="auto"
gap=3
yoffset=0
xoffset=0
background_color=

# Misc Options
stdout="off"
EOF

        print_success "Configuration customized"
    fi

    # ASCII art options
    echo ""
    print_info "neofetch supports custom ASCII art!"
    echo ""
    echo -e "  ${ICON_BULLET} Built-in distro logos"
    echo -e "  ${ICON_BULLET} Custom ASCII from file"
    echo -e "  ${ICON_BULLET} Image support (kitty, iTerm2)"
    echo ""

    # Shell startup option
    echo ""
    if confirm "Add neofetch to shell startup?" "n"; then
        local zshrc_path
        zshrc_path="$(get_zshrc_path)"

        # Check if already present
        if grep -q "neofetch" "$zshrc_path" 2>/dev/null; then
            print_info "neofetch already in shell startup"
        else
            # Add to end of .zshrc
            echo "" >> "$zshrc_path"
            echo "# Show system info on terminal start" >> "$zshrc_path"
            echo "neofetch" >> "$zshrc_path"
            print_success "Added neofetch to shell startup"
            print_info "neofetch will run each time you open a terminal"
        fi
    fi

    # Show demo
    echo ""
    print_divider "Preview"
    echo ""
    print_info "Here's what neofetch looks like:"
    echo ""

    # Run neofetch
    neofetch

    echo ""
    print_divider "Customization Tips"
    echo ""
    echo -e "  ${BOLD}Edit configuration:${NC}"
    echo -e "  ${DIM}nano ~/.config/neofetch/config.conf${NC}"
    echo ""
    echo -e "  ${BOLD}Use custom ASCII art:${NC}"
    echo -e "  ${CYAN}neofetch --ascii /path/to/ascii.txt${NC}"
    echo ""
    echo -e "  ${BOLD}Use image instead of ASCII:${NC}"
    echo -e "  ${CYAN}neofetch --iterm2 /path/to/image.png${NC}"
    echo -e "  ${DIM}(Requires iTerm2 or kitty)${NC}"
    echo ""
    echo -e "  ${BOLD}Show different distro logo:${NC}"
    echo -e "  ${CYAN}neofetch --ascii_distro arch${NC}"
    echo ""
    echo -e "  ${BOLD}List all options:${NC}"
    echo -e "  ${CYAN}neofetch --help${NC}"
    echo ""

    return 0
}

# =============================================================================
# Uninstall neofetch
# =============================================================================
uninstall() {
    print_divider "Uninstall neofetch"

    print_warning "This will remove neofetch from your system"

    if ! confirm "Are you sure you want to uninstall neofetch?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove via Homebrew
    if uninstall_brew "neofetch"; then
        # Clean up shell configuration
        print_info "Cleaning up shell configuration..."
        remove_from_zshrc "neofetch" "pattern"
        remove_from_zshrc "Show system info on terminal start" "pattern"

        # Ask about config removal
        local config_dir="${HOME}/.config/neofetch"
        if [[ -d "$config_dir" ]]; then
            if confirm "Remove neofetch configuration?" "n"; then
                rm -rf "$config_dir"
                print_success "Configuration removed"
            else
                print_info "Configuration kept at: $config_dir"
            fi
        fi

        print_success "neofetch uninstalled"
    else
        print_error "Failed to uninstall neofetch"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}neofetch Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install neofetch (default)"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove neofetch completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install neofetch"
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
                print_info "neofetch is not installed"
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
        print_info "Run 'neofetch' to display system information"
        echo ""
    fi

    exit $exit_code
}

# Run main if executed directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
