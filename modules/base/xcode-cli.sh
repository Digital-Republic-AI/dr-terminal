#!/usr/bin/env bash
# =============================================================================
# Xcode Command Line Tools - Essential Developer Tools for macOS
# DR Custom Terminal
# =============================================================================
# Installs Apple's Xcode Command Line Tools which provide essential
# development utilities including git, clang, make, and other build tools.
# Required as a prerequisite for Homebrew and most development workflows.
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
MODULE_NAME="Xcode Command Line Tools"
MODULE_VERSION="1.0.0"
MODULE_DEPS=()  # No dependencies - this is a base prerequisite

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
    __  __               __
   / / / /___ ___  ___  / /_  ____
  / /_/ / __ `__ \/ _ \/ __ \/ __ \
 / __  / / / / / /  __/ / / / /_/ /
/_/ /_/_/ /_/ /_/\___/_/ /_/\____/

   _  __              __
  | |/ /_________  __/ /__
  |   // ___/ __ \/ __  / _ \
 /   |/ /__/ /_/ / /_/ /  __/
/_/|_|\___/\____/\__,_/\___/

     Command Line Tools
EOF
    echo -e "${NC}"
    echo ""
}

# =============================================================================
# Dependency Check
# =============================================================================
check_dependencies() {
    # Xcode CLT has no dependencies - it's the base layer
    for dep in "${MODULE_DEPS[@]}"; do
        if ! command_exists "$dep"; then
            print_error "Dependency not found: $dep"
            return 1
        fi
    done
    return 0
}

# =============================================================================
# Installation Status Check
# =============================================================================
is_installed() {
    # Check if Xcode CLT is installed via xcode-select
    if xcode-select -p &>/dev/null; then
        local install_path
        install_path="$(xcode-select -p 2>/dev/null)"

        # Verify the path actually exists and has content
        if [[ -d "$install_path" ]]; then
            # Additional verification: check for essential tools
            if [[ -f "${install_path}/usr/bin/git" ]] || command_exists git; then
                return 0
            fi
        fi
    fi
    return 1
}

# =============================================================================
# Get Installation Path
# =============================================================================
get_install_path() {
    xcode-select -p 2>/dev/null || echo "Not installed"
}

# =============================================================================
# Get CLT Version
# =============================================================================
get_clt_version() {
    if is_installed; then
        # Try to get version from pkgutil
        local version
        version=$(pkgutil --pkg-info=com.apple.pkg.CLTools_Executables 2>/dev/null | grep version | awk '{print $2}')

        if [[ -n "$version" ]]; then
            echo "$version"
        else
            # Fallback: get from install path
            local install_path
            install_path="$(get_install_path)"
            if [[ "$install_path" == *"Xcode.app"* ]]; then
                echo "Xcode (full)"
            else
                echo "Unknown"
            fi
        fi
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
        local install_path version
        install_path="$(get_install_path)"
        version="$(get_clt_version)"

        echo -e "  ${ICON_SUCCESS} ${GREEN}Installed${NC}"
        echo -e "  ${ICON_BULLET} Version: ${BOLD}${version}${NC}"
        echo -e "  ${ICON_BULLET} Path: ${DIM}${install_path}${NC}"
        echo ""

        # Show available tools
        print_info "Available developer tools:"
        echo -e "  ${ICON_BULLET} git: $(git --version 2>/dev/null | head -1 || echo 'not found')"
        echo -e "  ${ICON_BULLET} clang: $(clang --version 2>/dev/null | head -1 || echo 'not found')"
        echo -e "  ${ICON_BULLET} make: $(make --version 2>/dev/null | head -1 || echo 'not found')"
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Wait for Installation to Complete
# =============================================================================
wait_for_installation() {
    local max_wait=1800  # 30 minutes max
    local wait_interval=5
    local elapsed=0

    print_info "Waiting for installation to complete..."
    print_info "This may take several minutes. Please follow the installation dialog."
    echo ""

    # Wait for the installer process to appear
    sleep 3

    while [[ $elapsed -lt $max_wait ]]; do
        # Check if installation is complete
        if is_installed; then
            echo ""
            return 0
        fi

        # Check if installer is still running
        if ! pgrep -x "Install Command Line Developer Tools" &>/dev/null && \
           ! pgrep -f "softwareupdate" &>/dev/null && \
           [[ $elapsed -gt 30 ]]; then
            # Installer seems to have finished or was cancelled
            if is_installed; then
                echo ""
                return 0
            else
                # Give it a bit more time in case of lag
                sleep 5
                if is_installed; then
                    echo ""
                    return 0
                fi
                echo ""
                return 1
            fi
        fi

        # Show progress indicator
        local spinner_char
        case $((elapsed / 5 % 4)) in
            0) spinner_char="|" ;;
            1) spinner_char="/" ;;
            2) spinner_char="-" ;;
            3) spinner_char="\\" ;;
        esac
        printf "\r  ${CYAN}%s${NC} Installing... (${elapsed}s elapsed)" "$spinner_char"

        sleep $wait_interval
        elapsed=$((elapsed + wait_interval))
    done

    echo ""
    print_error "Installation timed out after ${max_wait} seconds"
    return 1
}

# =============================================================================
# Install Xcode Command Line Tools
# =============================================================================
install() {
    print_divider "Installation"

    # Verify macOS
    if ! is_macos; then
        print_error "Xcode Command Line Tools are only available on macOS"
        return 1
    fi

    # Check for internet connectivity
    print_step 1 4 "Checking internet connection..."
    if ! has_internet; then
        print_error "No internet connection detected"
        print_info "Please connect to the internet and try again"
        return 1
    fi
    print_success "Internet connection available"

    # Trigger the installation dialog
    print_step 2 4 "Triggering installation dialog..."
    print_info "A system dialog will appear asking to install the tools"
    echo ""

    # Use xcode-select --install to trigger the GUI installer
    # This will show a dialog to the user
    if ! xcode-select --install 2>/dev/null; then
        # If this returns non-zero, it might already be installed
        # or the user cancelled
        if is_installed; then
            print_warning "Xcode Command Line Tools appear to be already installed"
            return 0
        fi

        print_error "Failed to trigger installation dialog"
        print_info "You can try installing manually by running:"
        echo -e "    ${DIM}xcode-select --install${NC}"
        return 1
    fi

    # Wait for installation to complete
    print_step 3 4 "Waiting for installation..."
    if ! wait_for_installation; then
        print_error "Installation was cancelled or failed"
        print_info "You can retry by running this script again"
        return 1
    fi

    # Verify installation
    print_step 4 4 "Verifying installation..."
    if is_installed; then
        print_success "Xcode Command Line Tools installed successfully!"
        return 0
    else
        print_error "Installation verification failed"
        print_info "Please try running: xcode-select --install"
        return 1
    fi
}

# =============================================================================
# Configure (Post-Installation)
# =============================================================================
configure() {
    print_divider "Configuration"

    # Accept Xcode license if needed
    print_info "Checking Xcode license..."

    # Try to run a simple compilation to check license status
    if echo 'int main() { return 0; }' | clang -x c - -o /dev/null 2>&1 | grep -q "license"; then
        print_warning "Xcode license needs to be accepted"
        print_info "Running: sudo xcodebuild -license accept"

        if sudo xcodebuild -license accept 2>/dev/null; then
            print_success "Xcode license accepted"
        else
            print_warning "Could not automatically accept license"
            print_info "You may need to run: sudo xcodebuild -license accept"
        fi
    else
        print_success "Xcode license already accepted"
    fi

    # Show summary of installed tools
    echo ""
    print_info "Installed tools summary:"
    echo -e "  ${ICON_BULLET} git $(git --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
    echo -e "  ${ICON_BULLET} clang $(clang --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
    echo -e "  ${ICON_BULLET} make $(make --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+' | head -1)"
    echo -e "  ${ICON_BULLET} And many more..."

    return 0
}

# =============================================================================
# Reinstall (Remove and Install Fresh)
# =============================================================================
reinstall() {
    print_divider "Reinstallation"

    print_warning "This will remove the existing Xcode Command Line Tools installation"

    if ! confirm "Proceed with reinstallation?"; then
        print_info "Reinstallation cancelled"
        return 0
    fi

    # Remove existing installation
    print_info "Removing existing installation..."

    local install_path
    install_path="$(get_install_path)"

    if [[ "$install_path" == *"CommandLineTools"* ]]; then
        if sudo rm -rf /Library/Developer/CommandLineTools 2>/dev/null; then
            print_success "Removed existing installation"
        else
            print_error "Failed to remove existing installation"
            return 1
        fi
    else
        print_warning "Full Xcode installation detected, skipping removal"
        print_info "Use the App Store to manage full Xcode installations"
        return 1
    fi

    # Reset xcode-select
    sudo xcode-select --reset 2>/dev/null || true

    # Install fresh
    install
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}Xcode Command Line Tools Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install Xcode Command Line Tools (default)"
    echo "  reinstall   Remove and reinstall"
    echo "  status      Show current installation status"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install (interactive)"
    echo "  $0 status       # Check installation status"
    echo "  $0 reinstall    # Force reinstallation"
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

    # Check OS requirement
    if ! is_macos; then
        print_error "This installer is only for macOS"
        exit 1
    fi

    # Check dependencies
    if ! check_dependencies; then
        print_error "Missing dependencies. Aborting."
        exit 1
    fi

    case "$command" in
        install)
            # Check if already installed
            if is_installed; then
                show_status
                print_warning "$MODULE_NAME is already installed"

                if ! confirm "Reinstall $MODULE_NAME?"; then
                    print_info "Skipping $MODULE_NAME installation"
                    exit 0
                fi

                reinstall
            else
                install && configure
            fi
            ;;
        reinstall)
            reinstall && configure
            ;;
        status)
            show_status
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

    if [[ $exit_code -eq 0 ]]; then
        echo ""
        print_success "$MODULE_NAME setup complete!"
        echo ""
    fi

    exit $exit_code
}

# Run main if executed directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
