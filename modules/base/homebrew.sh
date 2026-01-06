#!/usr/bin/env bash
# =============================================================================
# Homebrew - The Missing Package Manager for macOS
# DR Custom Terminal
# =============================================================================
# Installs Homebrew, the most popular package manager for macOS. Provides
# easy installation and management of command-line tools and applications.
# Automatically configures PATH for both Apple Silicon and Intel Macs.
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
MODULE_NAME="Homebrew"
MODULE_VERSION="1.0.0"
MODULE_DEPS=()  # Xcode CLT is checked separately for better messaging

# Homebrew installation URL
readonly HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
    __  __                     __
   / / / /___  ____ ___  ___  / /_  ______  _      __
  / /_/ / __ \/ __ `__ \/ _ \/ __ \/ ___/ | | /| / /
 / __  / /_/ / / / / / /  __/ /_/ / /   | |/ |/ /
/_/ /_/\____/_/ /_/ /_/\___/_.___/_/    |__/|__/

     The Missing Package Manager for macOS
EOF
    echo -e "${NC}"
    echo ""
}

# =============================================================================
# Dependency Check
# =============================================================================
check_dependencies() {
    local has_errors=0

    # Check for Xcode Command Line Tools
    if ! xcode-select -p &>/dev/null; then
        print_error "Xcode Command Line Tools are required"
        print_info "Install them first with: xcode-select --install"
        print_info "Or run: ${PROJECT_ROOT}/modules/base/xcode-cli.sh"
        has_errors=1
    fi

    # Check for curl (should be available on macOS)
    if ! command_exists curl; then
        print_error "curl is required but not found"
        has_errors=1
    fi

    # Check for git (comes with Xcode CLT)
    if ! command_exists git; then
        print_error "git is required but not found"
        print_info "This usually means Xcode Command Line Tools need to be installed"
        has_errors=1
    fi

    return $has_errors
}

# =============================================================================
# Architecture Detection
# =============================================================================
get_architecture() {
    local arch
    arch="$(uname -m)"

    case "$arch" in
        arm64)
            echo "arm64"
            ;;
        x86_64)
            echo "intel"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

get_brew_prefix_for_arch() {
    local arch
    arch="$(get_architecture)"

    case "$arch" in
        arm64)
            echo "/opt/homebrew"
            ;;
        intel)
            echo "/usr/local"
            ;;
        *)
            echo "/usr/local"
            ;;
    esac
}

# =============================================================================
# Installation Status Check
# =============================================================================
is_installed() {
    # Check if brew command exists
    if command_exists brew; then
        return 0
    fi

    # Check common installation paths
    local brew_prefix
    brew_prefix="$(get_brew_prefix_for_arch)"

    if [[ -x "${brew_prefix}/bin/brew" ]]; then
        return 0
    fi

    return 1
}

# =============================================================================
# Get Homebrew Version
# =============================================================================
get_brew_version() {
    if command_exists brew; then
        brew --version 2>/dev/null | head -1 | awk '{print $2}'
    elif [[ -x "$(get_brew_prefix_for_arch)/bin/brew" ]]; then
        "$(get_brew_prefix_for_arch)/bin/brew" --version 2>/dev/null | head -1 | awk '{print $2}'
    else
        echo "Not installed"
    fi
}

# =============================================================================
# Show Current Status
# =============================================================================
show_status() {
    print_divider "Current Status"

    local arch
    arch="$(get_architecture)"
    local expected_prefix
    expected_prefix="$(get_brew_prefix_for_arch)"

    echo -e "  ${ICON_BULLET} Architecture: ${BOLD}${arch}${NC}"
    echo -e "  ${ICON_BULLET} Expected path: ${DIM}${expected_prefix}${NC}"
    echo ""

    if is_installed; then
        local version
        version="$(get_brew_version)"
        local actual_prefix

        if command_exists brew; then
            actual_prefix="$(brew --prefix 2>/dev/null)"
        else
            actual_prefix="$expected_prefix"
        fi

        echo -e "  ${ICON_SUCCESS} ${GREEN}Installed${NC}"
        echo -e "  ${ICON_BULLET} Version: ${BOLD}${version}${NC}"
        echo -e "  ${ICON_BULLET} Prefix: ${DIM}${actual_prefix}${NC}"
        echo ""

        # Check if brew is in PATH
        if command_exists brew; then
            print_success "Homebrew is in PATH"
        else
            print_warning "Homebrew is installed but not in PATH"
            print_info "Add this to your shell config:"
            echo -e "    ${DIM}eval \"\$(${expected_prefix}/bin/brew shellenv)\"${NC}"
        fi

        # Show some stats if available
        if command_exists brew; then
            echo ""
            print_info "Installation summary:"
            local formulae casks
            formulae=$(brew list --formula 2>/dev/null | wc -l | tr -d ' ')
            casks=$(brew list --cask 2>/dev/null | wc -l | tr -d ' ')
            echo -e "  ${ICON_BULLET} Installed formulae: ${BOLD}${formulae}${NC}"
            echo -e "  ${ICON_BULLET} Installed casks: ${BOLD}${casks}${NC}"
        fi
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Configure Shell for Homebrew
# =============================================================================
configure_shell() {
    local brew_prefix
    brew_prefix="$(get_brew_prefix_for_arch)"
    local shellenv_line="eval \"\$(${brew_prefix}/bin/brew shellenv)\""

    print_divider "Shell Configuration"

    # Check current shell
    local current_shell
    current_shell="$(get_current_shell)"
    print_info "Current shell: $current_shell"

    case "$current_shell" in
        zsh)
            local zshrc_path
            zshrc_path="$(get_zshrc_path)"
            local zprofile_path
            zprofile_path="$(get_zprofile_path)"

            # Check if already configured in .zshrc
            if grep -q "brew shellenv" "$zshrc_path" 2>/dev/null; then
                print_success "Homebrew already configured in .zshrc"
                return 0
            fi

            # Check if already configured in .zprofile
            if grep -q "brew shellenv" "$zprofile_path" 2>/dev/null; then
                print_success "Homebrew already configured in .zprofile"
                return 0
            fi

            # Add to .zprofile (recommended for login shells)
            print_info "Adding Homebrew to shell configuration..."

            # Create .zprofile if it doesn't exist
            [[ ! -f "$zprofile_path" ]] && touch "$zprofile_path"

            # Add the shellenv line
            {
                echo ""
                echo "# Homebrew"
                echo "$shellenv_line"
            } >> "$zprofile_path"

            print_success "Added Homebrew configuration to .zprofile"

            # Also add to .zshrc for immediate availability in non-login shells
            if [[ -f "$zshrc_path" ]]; then
                if ! grep -q "brew shellenv" "$zshrc_path" 2>/dev/null; then
                    {
                        echo ""
                        echo "# Homebrew (for non-login shells)"
                        echo "[[ -x \"${brew_prefix}/bin/brew\" ]] && $shellenv_line"
                    } >> "$zshrc_path"
                    print_success "Added Homebrew configuration to .zshrc"
                fi
            fi
            ;;
        bash)
            local bash_profile
            bash_profile="$(get_bash_profile_path)"

            if grep -q "brew shellenv" "$bash_profile" 2>/dev/null; then
                print_success "Homebrew already configured in $bash_profile"
                return 0
            fi

            # Add to bash profile
            {
                echo ""
                echo "# Homebrew"
                echo "$shellenv_line"
            } >> "$bash_profile"

            print_success "Added Homebrew configuration to $bash_profile"
            ;;
        *)
            print_warning "Unknown shell: $current_shell"
            print_info "Add this line to your shell configuration manually:"
            echo -e "    ${DIM}${shellenv_line}${NC}"
            ;;
    esac

    # Source the configuration in current session
    if [[ -x "${brew_prefix}/bin/brew" ]]; then
        eval "$("${brew_prefix}/bin/brew" shellenv)"
        print_success "Homebrew environment loaded in current session"
    fi

    return 0
}

# =============================================================================
# Install Homebrew
# =============================================================================
install() {
    print_divider "Installation"

    # Verify macOS
    if ! is_macos; then
        print_error "Homebrew is designed for macOS"
        print_info "For Linux, visit: https://docs.brew.sh/Homebrew-on-Linux"
        return 1
    fi

    # Show architecture info
    local arch
    arch="$(get_architecture)"
    print_info "Detected architecture: $arch"

    # Check for internet connectivity
    print_step 1 5 "Checking internet connection..."
    if ! has_internet; then
        print_error "No internet connection detected"
        print_info "Please connect to the internet and try again"
        return 1
    fi
    print_success "Internet connection available"

    # Check URL accessibility
    print_step 2 5 "Verifying Homebrew install script..."
    if ! url_accessible "https://brew.sh"; then
        print_error "Cannot reach brew.sh"
        print_info "Please check your network connection"
        return 1
    fi
    print_success "Homebrew servers reachable"

    # Download and run the installation script
    print_step 3 5 "Downloading and running Homebrew installer..."
    echo ""
    print_info "This will install Homebrew to: $(get_brew_prefix_for_arch)"
    print_info "You may be prompted for your password"
    echo ""

    # Run the official installation script
    # The script is interactive and will show progress
    if ! /bin/bash -c "$(curl -fsSL ${HOMEBREW_INSTALL_URL})"; then
        print_error "Homebrew installation failed"
        return 1
    fi

    echo ""
    print_success "Homebrew installation completed"

    # Configure shell
    print_step 4 5 "Configuring shell environment..."
    configure_shell

    # Verify installation
    print_step 5 5 "Verifying installation..."

    # Make sure brew is available
    local brew_prefix
    brew_prefix="$(get_brew_prefix_for_arch)"

    if [[ -x "${brew_prefix}/bin/brew" ]]; then
        # Ensure we can use it in this session
        eval "$("${brew_prefix}/bin/brew" shellenv)"

        if command_exists brew; then
            print_success "Homebrew is ready to use"
            return 0
        fi
    fi

    if is_installed; then
        print_success "Homebrew installed successfully"
        print_info "Start a new terminal session to use brew"
        return 0
    else
        print_error "Installation verification failed"
        return 1
    fi
}

# =============================================================================
# Configure (Post-Installation)
# =============================================================================
configure() {
    print_divider "Post-Installation Configuration"

    # Make sure brew is in PATH
    local brew_prefix
    brew_prefix="$(get_brew_prefix_for_arch)"

    if ! command_exists brew && [[ -x "${brew_prefix}/bin/brew" ]]; then
        eval "$("${brew_prefix}/bin/brew" shellenv)"
    fi

    # Run brew doctor
    print_info "Running brew doctor to check installation health..."
    echo ""

    if brew doctor 2>&1; then
        print_success "Homebrew installation is healthy"
    else
        print_warning "brew doctor reported some warnings"
        print_info "These are usually informational and can be ignored"
    fi

    echo ""

    # Disable analytics (optional)
    if confirm "Disable Homebrew analytics (telemetry)?"; then
        brew analytics off
        print_success "Analytics disabled"
    fi

    # Show next steps
    echo ""
    print_divider "Getting Started"
    echo ""
    echo -e "  ${BOLD}Common Homebrew commands:${NC}"
    echo ""
    echo -e "  ${CYAN}brew search <text>${NC}      Search for formulae"
    echo -e "  ${CYAN}brew install <formula>${NC}  Install a formula"
    echo -e "  ${CYAN}brew update${NC}             Update Homebrew"
    echo -e "  ${CYAN}brew upgrade${NC}            Upgrade all packages"
    echo -e "  ${CYAN}brew list${NC}               List installed packages"
    echo -e "  ${CYAN}brew info <formula>${NC}     Show info about a formula"
    echo ""
    echo -e "  ${BOLD}Popular packages to install:${NC}"
    echo ""
    echo -e "  ${DIM}brew install git wget jq tree htop${NC}"
    echo ""

    return 0
}

# =============================================================================
# Update Homebrew
# =============================================================================
update() {
    print_divider "Updating Homebrew"

    if ! command_exists brew; then
        print_error "Homebrew is not installed or not in PATH"
        return 1
    fi

    print_info "Updating Homebrew..."
    if brew update; then
        print_success "Homebrew updated successfully"
    else
        print_error "Failed to update Homebrew"
        return 1
    fi

    print_info "Checking for outdated packages..."
    local outdated
    outdated=$(brew outdated)

    if [[ -z "$outdated" ]]; then
        print_success "All packages are up to date"
    else
        echo ""
        echo -e "${BOLD}Outdated packages:${NC}"
        echo "$outdated"
        echo ""

        if confirm "Upgrade all packages?"; then
            if brew upgrade; then
                print_success "All packages upgraded"
            else
                print_warning "Some packages failed to upgrade"
            fi
        fi
    fi

    # Cleanup
    if confirm "Run cleanup to remove old versions?"; then
        brew cleanup
        print_success "Cleanup complete"
    fi

    return 0
}

# =============================================================================
# Uninstall Homebrew
# =============================================================================
uninstall() {
    print_divider "Uninstall Homebrew"

    print_warning "This will completely remove Homebrew and all installed packages!"
    echo ""

    if ! confirm "Are you sure you want to uninstall Homebrew?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Double confirmation
    echo ""
    print_warning "This action cannot be undone!"
    if ! confirm "Type 'y' again to confirm" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    print_info "Downloading uninstall script..."

    local uninstall_url="https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh"

    if /bin/bash -c "$(curl -fsSL ${uninstall_url})"; then
        print_success "Homebrew uninstalled"

        # Clean up shell configuration
        print_info "Cleaning up shell configuration..."
        remove_from_zshrc "brew shellenv" "pattern"

        # Remove profile entries too
        local zprofile_path
        zprofile_path="$(get_zprofile_path)"
        if [[ -f "$zprofile_path" ]]; then
            local temp_file
            temp_file="$(mktemp)"
            grep -v "brew shellenv" "$zprofile_path" > "$temp_file" 2>/dev/null || true
            grep -v "# Homebrew" "$temp_file" > "$zprofile_path" 2>/dev/null || true
            rm -f "$temp_file"
        fi

        print_success "Shell configuration cleaned up"
    else
        print_error "Failed to uninstall Homebrew"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}Homebrew Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install Homebrew (default)"
    echo "  update      Update Homebrew and packages"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove Homebrew completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install Homebrew"
    echo "  $0 status       # Check installation status"
    echo "  $0 update       # Update Homebrew and packages"
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
        print_error "This installer is designed for macOS"
        print_info "For Linux, visit: https://docs.brew.sh/Homebrew-on-Linux"
        exit 1
    fi

    case "$command" in
        install)
            # Check dependencies first
            if ! check_dependencies; then
                print_error "Missing dependencies. Please install Xcode Command Line Tools first."
                print_info "Run: ${PROJECT_ROOT}/modules/base/xcode-cli.sh"
                exit 1
            fi

            # Check if already installed
            if is_installed; then
                show_status
                print_warning "$MODULE_NAME is already installed"

                if ! confirm "Reinstall $MODULE_NAME?"; then
                    print_info "Skipping $MODULE_NAME installation"

                    # Offer to run configuration anyway
                    if confirm "Run post-installation configuration?"; then
                        configure
                    fi
                    exit 0
                fi

                # Uninstall first, then install fresh
                uninstall && install && configure
            else
                install && configure
            fi
            ;;
        update)
            if ! is_installed; then
                print_error "Homebrew is not installed"
                print_info "Run: $0 install"
                exit 1
            fi
            update
            ;;
        status)
            show_status
            ;;
        uninstall)
            if ! is_installed; then
                print_info "Homebrew is not installed"
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
        echo ""
    fi

    exit $exit_code
}

# Run main if executed directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
