#!/usr/bin/env bash
# =============================================================================
# zsh-completions - Additional Completion Definitions for ZSH
# DR Custom Terminal
# =============================================================================
# Provides additional completion definitions for many commands not included
# in the default ZSH distribution. Adds completions for tools like docker,
# git-flow, npm, cargo, and many more.
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
MODULE_NAME="zsh-completions"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("git" "zsh")

# Plugin-specific configuration
PLUGIN_REPO="https://github.com/zsh-users/zsh-completions"
PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions"

# =============================================================================
# ASCII Art Header
# =============================================================================
show_ascii_header() {
    echo -e "${CYAN}"
    cat << 'EOF'
                           _      _   _
   ___ ___  _ __ ___  _ __ | | ___| |_(_) ___  _ __  ___
  / __/ _ \| '_ ` _ \| '_ \| |/ _ \ __| |/ _ \| '_ \/ __|
 | (_| (_) | | | | | | |_) | |  __/ |_| | (_) | | | \__ \
  \___\___/|_| |_| |_| .__/|_|\___|\__|_|\___/|_| |_|___/
                     |_|
    Additional completion definitions for ZSH
EOF
    echo -e "${NC}"
    echo ""
}

# =============================================================================
# Dependency Check
# =============================================================================
check_dependencies() {
    local has_errors=0

    print_divider "Checking Dependencies"

    # Check for Oh My ZSH
    if ! has_omz; then
        print_error "Oh My ZSH is required but not installed"
        print_info "Install Oh My ZSH first: ${PROJECT_ROOT}/modules/shell/oh-my-zsh.sh"
        has_errors=1
    else
        print_success "Oh My ZSH installed"
    fi

    # Check for Git
    if ! command_exists git; then
        print_error "Git is required but not installed"
        has_errors=1
    else
        print_success "Git installed"
    fi

    echo ""
    return $has_errors
}

# =============================================================================
# Installation Status Check
# =============================================================================
is_installed() {
    [[ -d "$PLUGIN_DIR" && -d "${PLUGIN_DIR}/src" ]]
}

# =============================================================================
# Get Version
# =============================================================================
get_version() {
    if is_installed && [[ -d "${PLUGIN_DIR}/.git" ]]; then
        git -C "$PLUGIN_DIR" describe --tags --abbrev=0 2>/dev/null || \
        git -C "$PLUGIN_DIR" log -1 --format="%cd" --date=short 2>/dev/null || \
        echo "unknown"
    else
        echo "Not installed"
    fi
}

# =============================================================================
# Count Available Completions
# =============================================================================
count_completions() {
    if is_installed; then
        find "${PLUGIN_DIR}/src" -name "_*" -type f 2>/dev/null | wc -l | tr -d ' '
    else
        echo "0"
    fi
}

# =============================================================================
# Show Current Status
# =============================================================================
show_status() {
    print_divider "Current Status"

    echo -e "  ${ICON_BULLET} Plugin directory: ${DIM}${PLUGIN_DIR}${NC}"
    echo ""

    if is_installed; then
        local version
        version="$(get_version)"
        local completion_count
        completion_count="$(count_completions)"

        echo -e "  ${ICON_SUCCESS} ${GREEN}Installed${NC}"
        echo -e "  ${ICON_BULLET} Version: ${BOLD}${version}${NC}"
        echo -e "  ${ICON_BULLET} Completions available: ${BOLD}${completion_count}${NC}"
        echo ""

        # Check if plugin is enabled in .zshrc
        local zshrc_path
        zshrc_path="$(get_zshrc_path)"
        local plugins
        plugins=$(list_plugins_omz)

        if echo "$plugins" | grep -q "zsh-completions"; then
            print_success "Plugin is enabled in .zshrc"
        else
            print_warning "Plugin is NOT enabled in .zshrc"
            print_info "Add 'zsh-completions' to your plugins array"
        fi

        # Check if fpath is configured
        if grep -q "fpath.*zsh-completions" "$zshrc_path" 2>/dev/null; then
            print_success "fpath is configured"
        else
            print_warning "fpath may need configuration for completions to work"
        fi

        # List some available completions
        echo ""
        echo -e "  ${BOLD}Sample completions available:${NC}"
        local sample_completions
        sample_completions=$(find "${PLUGIN_DIR}/src" -name "_*" -type f 2>/dev/null | \
            head -10 | xargs -I {} basename {} | sed 's/^_/  /' | sort)
        echo -e "${DIM}${sample_completions}${NC}"
        echo -e "  ${DIM}... and $(( $(count_completions) - 10 )) more${NC}"
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Install Plugin
# =============================================================================
install() {
    print_divider "Installation"

    # Check for internet connectivity
    print_step 1 5 "Checking internet connection..."
    if ! has_internet; then
        print_error "No internet connection detected"
        return 1
    fi
    print_success "Internet connection available"

    # Check if already installed
    if is_installed; then
        print_info "Plugin already installed at $PLUGIN_DIR"
        if confirm "Reinstall (remove and clone fresh)?"; then
            print_info "Removing existing installation..."
            rm -rf "$PLUGIN_DIR"
        else
            return 0
        fi
    fi

    # Create custom plugins directory if needed
    print_step 2 5 "Preparing plugin directory..."
    local custom_plugins_dir
    custom_plugins_dir="$(dirname "$PLUGIN_DIR")"
    mkdir -p "$custom_plugins_dir"
    print_success "Plugin directory ready"

    # Clone the repository
    print_step 3 5 "Cloning zsh-completions..."
    if ! git clone --depth=1 "$PLUGIN_REPO" "$PLUGIN_DIR" 2>/dev/null; then
        print_error "Failed to clone repository"
        return 1
    fi
    print_success "Repository cloned successfully"

    # Add to plugins array in .zshrc
    print_step 4 5 "Enabling plugin in .zshrc..."
    add_plugin_omz "zsh-completions"

    # Configure fpath
    print_step 5 5 "Configuring fpath..."
    configure_fpath

    return 0
}

# =============================================================================
# Configure fpath for Completions
# =============================================================================
configure_fpath() {
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Check if fpath is already configured
    if grep -q "fpath.*zsh-completions" "$zshrc_path" 2>/dev/null; then
        print_info "fpath already configured for zsh-completions"
        return 0
    fi

    # Add fpath configuration before compinit
    # This needs to be placed BEFORE oh-my-zsh is sourced
    local fpath_line="fpath+=\"${PLUGIN_DIR}/src\""

    # Check if there's an fpath section or plugins section
    local temp_file
    temp_file="$(mktemp)"

    if grep -q "^plugins=(" "$zshrc_path"; then
        # Add before plugins line
        awk -v line="$fpath_line" '
            /^plugins=\(/ && !added {
                print "# zsh-completions: add completions to fpath"
                print line
                print ""
                added=1
            }
            { print }
        ' "$zshrc_path" > "$temp_file"
        mv "$temp_file" "$zshrc_path"
    else
        # Add near the top of file
        add_to_zshrc "$fpath_line" "zsh-completions: add completions to fpath" "top"
    fi

    print_success "fpath configured"
    return 0
}

# =============================================================================
# Rebuild Completions Cache
# =============================================================================
rebuild_completions() {
    print_divider "Rebuilding Completions Cache"

    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Fix permissions on completion directories
    print_info "Fixing completion directory permissions..."
    if compaudit 2>/dev/null | xargs -r chmod g-w,o-w 2>/dev/null; then
        print_success "Permissions fixed"
    else
        print_info "No permission issues found"
    fi

    # Remove old completion cache
    print_info "Removing old completion cache..."
    local zcompdump_files
    zcompdump_files=$(find "$HOME" -maxdepth 1 -name ".zcompdump*" 2>/dev/null)
    if [[ -n "$zcompdump_files" ]]; then
        rm -f "$HOME"/.zcompdump*
        print_success "Old cache files removed"
    else
        print_info "No cache files to remove"
    fi

    # Instruct user to rebuild
    echo ""
    print_info "Completion cache will rebuild on next shell start."
    print_info "Run this command to rebuild now:"
    echo ""
    echo -e "  ${CYAN}rm -f ~/.zcompdump; compinit${NC}"
    echo ""

    return 0
}

# =============================================================================
# Configure Plugin
# =============================================================================
configure() {
    print_divider "Configuration"

    if ! is_installed; then
        print_error "Plugin is not installed"
        return 1
    fi

    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Check fpath configuration
    echo ""
    echo -e "${BOLD}fpath Configuration${NC}"
    echo ""
    echo -e "  The fpath (function path) must include the completions directory"
    echo -e "  for ZSH to find the additional completion definitions."
    echo ""

    if ! grep -q "fpath.*zsh-completions" "$zshrc_path" 2>/dev/null; then
        if confirm "Configure fpath for zsh-completions?"; then
            configure_fpath
        fi
    else
        print_success "fpath is already configured"
    fi

    # Offer to rebuild completions
    echo ""
    echo -e "${BOLD}Completions Cache${NC}"
    echo ""
    echo -e "  After adding new completions, the cache should be rebuilt."
    echo -e "  This ensures all new completions are available."
    echo ""

    if confirm "Rebuild completions cache now?" "y"; then
        rebuild_completions
    fi

    # Show available completions
    echo ""
    print_divider "Available Completions"
    echo ""
    echo -e "  This plugin provides completions for many tools including:"
    echo ""

    # List popular completions
    local popular_completions=(
        "docker" "docker-compose" "git-flow"
        "cargo" "rustup" "npm" "yarn"
        "kubectl" "helm" "terraform"
        "brew" "bundler" "gem"
        "go" "gradle" "maven"
        "pip" "poetry" "pipenv"
        "redis-cli" "mongo" "mysql"
        "vagrant" "ansible" "packer"
    )

    local available_completions=""
    for comp in "${popular_completions[@]}"; do
        if [[ -f "${PLUGIN_DIR}/src/_${comp}" ]]; then
            available_completions+="  ${CYAN}${comp}${NC}\n"
        fi
    done

    if [[ -n "$available_completions" ]]; then
        echo -e "$available_completions"
    fi

    echo ""
    echo -e "  Total completions available: ${BOLD}$(count_completions)${NC}"
    echo ""
    echo -e "  To see all available completions:"
    echo -e "  ${DIM}ls ${PLUGIN_DIR}/src/${NC}"
    echo ""

    return 0
}

# =============================================================================
# Update Plugin
# =============================================================================
update() {
    print_divider "Updating $MODULE_NAME"

    if ! is_installed; then
        print_error "Plugin is not installed"
        return 1
    fi

    if [[ ! -d "${PLUGIN_DIR}/.git" ]]; then
        print_error "Plugin directory is not a git repository"
        print_info "Consider reinstalling the plugin"
        return 1
    fi

    print_info "Pulling latest changes..."
    if git -C "$PLUGIN_DIR" pull --rebase --quiet 2>/dev/null; then
        local new_count
        new_count="$(count_completions)"
        print_success "Plugin updated to $(get_version) (${new_count} completions)"

        # Rebuild completions after update
        if confirm "Rebuild completions cache?" "y"; then
            rebuild_completions
        fi
    else
        print_warning "Could not update (may have local changes)"
    fi

    return 0
}

# =============================================================================
# Uninstall Plugin
# =============================================================================
uninstall() {
    print_divider "Uninstall $MODULE_NAME"

    if ! is_installed; then
        print_info "Plugin is not installed"
        return 0
    fi

    print_warning "This will remove zsh-completions from your system"

    if ! confirm "Are you sure you want to uninstall?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove from plugins array
    print_info "Removing from plugins list..."
    remove_plugin_omz "zsh-completions"

    # Remove fpath configuration
    print_info "Removing fpath configuration..."
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"
    remove_from_zshrc "zsh-completions" "pattern"

    # Remove plugin directory
    print_info "Removing plugin directory..."
    rm -rf "$PLUGIN_DIR"

    # Rebuild completions
    print_info "Cleaning up completions cache..."
    rm -f "$HOME"/.zcompdump*

    if [[ ! -d "$PLUGIN_DIR" ]]; then
        print_success "Plugin uninstalled successfully"
    else
        print_error "Failed to remove plugin directory"
        return 1
    fi

    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}zsh-completions Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install zsh-completions (default)"
    echo "  configure   Configure plugin and rebuild cache"
    echo "  update      Update to latest version"
    echo "  rebuild     Rebuild completions cache"
    echo "  status      Show current installation status"
    echo "  uninstall   Remove plugin completely"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Install plugin"
    echo "  $0 status       # Check installation status"
    echo "  $0 rebuild      # Rebuild completions cache"
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
                print_error "Missing dependencies. Please install Oh My ZSH first."
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
        configure)
            if ! is_installed; then
                print_error "Plugin is not installed"
                print_info "Run: $0 install"
                exit 1
            fi
            configure
            ;;
        rebuild)
            if ! is_installed; then
                print_error "Plugin is not installed"
                exit 1
            fi
            rebuild_completions
            ;;
        update)
            update
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
