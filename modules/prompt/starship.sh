#!/usr/bin/env bash
# =============================================================================
# Starship - The Minimal, Blazing-Fast, Cross-Shell Prompt
# DR Custom Terminal
# =============================================================================
# Installs and configures Starship, a minimal, highly customizable prompt
# that works across any shell with consistent functionality.
#
# Features:
#   - Cross-shell compatibility (Zsh, Bash, Fish, PowerShell, etc.)
#   - Blazing-fast performance written in Rust
#   - Highly customizable with TOML configuration
#   - Built-in presets for quick styling
#   - Git status, command timing, and language version display
#   - Minimal and clean design philosophy
#
# Requirements:
#   - Homebrew (for macOS installation)
#   - Nerd Font recommended for full icon support
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/core/colors.sh"
source "${PROJECT_ROOT}/core/ui.sh"
source "${PROJECT_ROOT}/core/validators.sh"
source "${PROJECT_ROOT}/core/installers.sh"
source "${PROJECT_ROOT}/core/shell-config.sh"

# =============================================================================
# Module Configuration
# =============================================================================
MODULE_NAME="Starship"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew")

readonly STARSHIP_CONFIG_DIR="$HOME/.config"
readonly STARSHIP_CONFIG_FILE="$HOME/.config/starship.toml"

# =============================================================================
# ASCII Art Header
# =============================================================================
show_header() {
    echo ""
    echo -e "${BOLD_PURPLE}"
    cat << 'EOF'
       _____ __                  __    _
      / ___// /_____ ___________/ /_  (_)___
      \__ \/ __/ __ `/ ___/ ___/ __ \/ / __ \
     ___/ / /_/ /_/ / /  (__  ) / / / / /_/ /
    /____/\__/\__,_/_/  /____/_/ /_/_/ .___/
                                    /_/
                    *       .
         .                        *
              *                          .
    .              *         .                  *
                                   .
           .            *                .
                  *                           .
       .                    .          *
                      *
EOF
    echo -e "${NC}"
    echo -e "${DIM}    The minimal, blazing-fast, and infinitely customizable prompt for any shell${NC}"
    echo ""
}

# =============================================================================
# Dependency Checks
# =============================================================================
check_dependencies() {
    print_divider "Checking Dependencies"

    local missing=()

    # Check Homebrew (primary installation method for macOS)
    if is_macos; then
        if has_brew; then
            print_success "Homebrew is installed"
        else
            print_error "Homebrew is not installed"
            echo ""
            echo -e "  Install Homebrew first:"
            echo -e "  ${DIM}/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"${NC}"
            missing+=("brew")
        fi
    elif is_linux; then
        # On Linux, we can use the install script
        if command_exists curl || command_exists wget; then
            print_success "Download tools available"
        else
            print_error "Neither curl nor wget is available"
            missing+=("curl or wget")
        fi
    fi

    # Check for Zsh as default shell
    if is_zsh_default_shell; then
        print_success "Zsh is your default shell"
    else
        print_info "Current shell: $(get_current_shell)"
        print_info "Starship works with any shell!"
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo ""
        print_error "Missing required dependencies: ${missing[*]}"
        return 1
    fi

    return 0
}

# =============================================================================
# Nerd Font Check
# =============================================================================
check_nerd_fonts() {
    print_divider "Nerd Font Check"

    local nerd_font_installed=false

    # Check for common Nerd Font installations
    local font_dirs=(
        "$HOME/Library/Fonts"
        "/Library/Fonts"
        "$HOME/.local/share/fonts"
        "/usr/share/fonts"
    )

    for dir in "${font_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            if find "$dir" -type f \( -name "*Nerd*" -o -name "*NF*" \) 2>/dev/null | head -1 | grep -q .; then
                nerd_font_installed=true
                break
            fi
        fi
    done

    if [[ "$nerd_font_installed" == true ]]; then
        print_success "Nerd Font detected"
        return 0
    else
        print_warning "No Nerd Font detected"
        echo ""
        echo -e "${YELLOW}Starship works best with a Nerd Font for icons.${NC}"
        echo ""
        echo "  Recommended fonts:"
        echo -e "  ${PURPLE}${ICON_BULLET}${NC} JetBrainsMono Nerd Font"
        echo -e "  ${PURPLE}${ICON_BULLET}${NC} FiraCode Nerd Font"
        echo -e "  ${PURPLE}${ICON_BULLET}${NC} Hack Nerd Font"
        echo -e "  ${PURPLE}${ICON_BULLET}${NC} MesloLGS Nerd Font"
        echo ""
        echo -e "  Install via: ${DIM}brew install font-jetbrains-mono-nerd-font${NC}"
        echo ""

        # Continue anyway - Starship works without Nerd Fonts
        return 0
    fi
}

# =============================================================================
# Installation Functions
# =============================================================================
install_starship() {
    print_divider "Installing Starship"

    # Check if already installed
    if command_exists starship; then
        local current_version
        current_version=$(starship --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
        print_info "Starship is already installed (v${current_version})"

        if confirm "Upgrade to latest version?" "n"; then
            if is_macos && has_brew; then
                spinner "Upgrading Starship" brew upgrade starship
            else
                install_via_script
            fi
        fi
        return 0
    fi

    # Install based on platform
    if is_macos && has_brew; then
        install_with_brew starship "Starship"
    elif is_linux; then
        install_via_script
    else
        print_error "Unsupported platform for automatic installation"
        echo ""
        echo "  Please install manually from: https://starship.rs"
        return 1
    fi

    # Verify installation
    if command_exists starship; then
        local installed_version
        installed_version=$(starship --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
        print_success "Starship v${installed_version} installed successfully"
        return 0
    else
        print_error "Starship installation failed"
        return 1
    fi
}

install_via_script() {
    print_info "Installing via official install script..."

    if command_exists curl; then
        curl -sS https://starship.rs/install.sh | sh -s -- --yes
    elif command_exists wget; then
        wget -qO- https://starship.rs/install.sh | sh -s -- --yes
    else
        print_error "Neither curl nor wget is available"
        return 1
    fi
}

# =============================================================================
# Shell Configuration
# =============================================================================
configure_shell() {
    print_divider "Configuring Shell"

    local shell_name
    shell_name="$(get_current_shell)"
    local init_line='eval "$(starship init zsh)"'

    case "$shell_name" in
        zsh)
            configure_zsh
            ;;
        bash)
            configure_bash
            ;;
        fish)
            configure_fish
            ;;
        *)
            print_warning "Unknown shell: $shell_name"
            echo ""
            echo "  Add the following to your shell config:"
            echo -e "  ${DIM}eval \"\$(starship init ${shell_name})\"${NC}"
            ;;
    esac
}

configure_zsh() {
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Backup first
    backup_zshrc

    # Check if already configured
    if grep -q 'starship init zsh' "$zshrc_path" 2>/dev/null; then
        print_info "Starship already configured in .zshrc"
        return 0
    fi

    # Disable Oh My ZSH theme if present (Starship replaces it)
    if has_omz; then
        if grep -q '^ZSH_THEME=' "$zshrc_path"; then
            print_info "Disabling Oh My ZSH theme (Starship will replace it)"
            local temp_file
            temp_file="$(mktemp)"
            sed 's/^ZSH_THEME=.*/# ZSH_THEME="" # Disabled - using Starship/' "$zshrc_path" > "$temp_file"
            mv "$temp_file" "$zshrc_path"
        fi
    fi

    # Add Starship init
    add_to_zshrc 'eval "$(starship init zsh)"' "Starship prompt"
    print_success "Starship configured for Zsh"
}

configure_bash() {
    local bashrc_path
    bashrc_path="$(get_bashrc_path)"

    # Create if doesn't exist
    [[ ! -f "$bashrc_path" ]] && touch "$bashrc_path"

    # Check if already configured
    if grep -q 'starship init bash' "$bashrc_path" 2>/dev/null; then
        print_info "Starship already configured in .bashrc"
        return 0
    fi

    # Add Starship init
    echo "" >> "$bashrc_path"
    echo "# Starship prompt" >> "$bashrc_path"
    echo 'eval "$(starship init bash)"' >> "$bashrc_path"

    print_success "Starship configured for Bash"
}

configure_fish() {
    local fish_config="$HOME/.config/fish/config.fish"

    # Create config directory if needed
    mkdir -p "$(dirname "$fish_config")"
    [[ ! -f "$fish_config" ]] && touch "$fish_config"

    # Check if already configured
    if grep -q 'starship init fish' "$fish_config" 2>/dev/null; then
        print_info "Starship already configured in config.fish"
        return 0
    fi

    # Add Starship init
    echo "" >> "$fish_config"
    echo "# Starship prompt" >> "$fish_config"
    echo 'starship init fish | source' >> "$fish_config"

    print_success "Starship configured for Fish"
}

# =============================================================================
# Configuration File
# =============================================================================
create_config() {
    print_divider "Creating Configuration"

    # Create config directory
    mkdir -p "$STARSHIP_CONFIG_DIR"

    # Check if config already exists
    if [[ -f "$STARSHIP_CONFIG_FILE" ]]; then
        print_info "Configuration file already exists: $STARSHIP_CONFIG_FILE"

        if confirm "Create a backup and generate new config?" "n"; then
            local backup_file="${STARSHIP_CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
            cp "$STARSHIP_CONFIG_FILE" "$backup_file"
            print_success "Backup created: $backup_file"
        else
            return 0
        fi
    fi

    # Offer preset selection or custom config
    echo ""
    echo -e "${BOLD}Configuration Options:${NC}"
    echo ""
    echo -e "  ${PURPLE}1)${NC} Minimal - Clean and simple"
    echo -e "  ${PURPLE}2)${NC} Nerd Font Symbols - With icons (requires Nerd Font)"
    echo -e "  ${PURPLE}3)${NC} Plain Text - No special characters"
    echo -e "  ${PURPLE}4)${NC} Custom starter - Customizable template"
    echo ""

    local choice
    choice=$(select_option "Select a configuration preset:" "Minimal" "Nerd Font Symbols" "Plain Text" "Custom Starter")

    case "$choice" in
        1) create_minimal_config ;;
        2) create_nerdfont_config ;;
        3) create_plaintext_config ;;
        4) create_custom_config ;;
    esac

    print_success "Configuration created: $STARSHIP_CONFIG_FILE"
}

create_minimal_config() {
    cat > "$STARSHIP_CONFIG_FILE" << 'EOF'
# Starship Configuration - Minimal
# https://starship.rs/config/

# Disable the blank line at the start of the prompt
add_newline = false

# Configure the format of the prompt
format = """
$directory\
$git_branch\
$git_status\
$character"""

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
format = "[$branch]($style) "
style = "bold purple"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold red"

[character]
success_symbol = "[>](bold green)"
error_symbol = "[x](bold red)"
EOF
}

create_nerdfont_config() {
    cat > "$STARSHIP_CONFIG_FILE" << 'EOF'
# Starship Configuration - Nerd Font Symbols
# https://starship.rs/config/
# Requires a Nerd Font for icons

add_newline = true

format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$rust\
$golang\
$docker_context\
$cmd_duration\
$line_break\
$character"""

[directory]
truncation_length = 4
truncate_to_repo = true
format = "[$path]($style)[$read_only]($read_only_style) "
read_only = " "
style = "bold cyan"

[git_branch]
format = "[$symbol$branch]($style) "
symbol = " "
style = "bold purple"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold red"
ahead = ""
behind = ""
diverged = ""
modified = ""
staged = ""
untracked = ""

[nodejs]
format = "[$symbol($version)]($style) "
symbol = " "
style = "bold green"

[python]
format = "[$symbol$version]($style) "
symbol = " "
style = "bold yellow"

[rust]
format = "[$symbol($version)]($style) "
symbol = " "
style = "bold red"

[golang]
format = "[$symbol($version)]($style) "
symbol = " "
style = "bold cyan"

[docker_context]
format = "[$symbol$context]($style) "
symbol = " "
style = "bold blue"

[cmd_duration]
min_time = 2000
format = "[$duration]($style) "
style = "bold yellow"

[character]
success_symbol = "[](bold green)"
error_symbol = "[](bold red)"
EOF
}

create_plaintext_config() {
    cat > "$STARSHIP_CONFIG_FILE" << 'EOF'
# Starship Configuration - Plain Text
# https://starship.rs/config/
# Works without special fonts

add_newline = false

format = """
$directory\
$git_branch\
$git_status\
$character"""

[directory]
truncation_length = 3
format = "[$path]($style) "
style = "bold blue"

[git_branch]
format = "[($branch)]($style) "
symbol = ""
style = "bold purple"

[git_status]
format = '([$all_status$ahead_behind]($style) )'
style = "bold red"
ahead = "+"
behind = "-"
modified = "*"
staged = "+"
untracked = "?"

[character]
success_symbol = "[>](bold green)"
error_symbol = "[>](bold red)"
EOF
}

create_custom_config() {
    cat > "$STARSHIP_CONFIG_FILE" << 'EOF'
# Starship Configuration - Custom Starter
# https://starship.rs/config/
#
# This is a customizable template. Edit to your liking!
# Run 'starship explain' to see active modules
# Run 'starship print-config' to see all available options

# General settings
add_newline = true
command_timeout = 1000

# Prompt format - customize the order and modules shown
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$package\
$nodejs\
$python\
$rust\
$golang\
$java\
$docker_context\
$aws\
$env_var\
$cmd_duration\
$line_break\
$jobs\
$battery\
$time\
$status\
$character"""

# ===== Module Configurations =====

[username]
disabled = true  # Enable if needed
format = "[$user]($style) "
style_user = "bold dimmed blue"

[hostname]
disabled = true  # Enable for SSH sessions
format = "[@$hostname]($style) "
style = "bold dimmed green"

[directory]
truncation_length = 4
truncate_to_repo = true
format = "[$path]($style)[$read_only]($read_only_style) "
style = "bold cyan"

[git_branch]
format = "[$symbol$branch(:$remote_branch)]($style) "
symbol = ""  # Add icon if using Nerd Font
style = "bold purple"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold red"

[package]
format = "[$symbol$version]($style) "
symbol = ""  # Add icon if using Nerd Font
style = "bold 208"
disabled = true  # Enable if needed

[cmd_duration]
min_time = 2000
format = "took [$duration]($style) "
style = "bold yellow"

[time]
disabled = true  # Enable to show time in prompt
format = "[$time]($style) "
style = "bold dimmed white"

[character]
success_symbol = "[>](bold green)"
error_symbol = "[x](bold red)"
vicmd_symbol = "[<](bold green)"
EOF
}

# =============================================================================
# Usage Instructions
# =============================================================================
show_instructions() {
    print_divider "Setup Complete"

    echo ""
    echo -e "${BOLD_GREEN}Starship has been installed successfully!${NC}"
    echo ""

    echo -e "${BOLD}Next Steps:${NC}"
    echo ""
    echo -e "  ${PURPLE}1.${NC} Restart your terminal or run: ${DIM}source ~/.zshrc${NC}"
    echo -e "  ${PURPLE}2.${NC} Customize your config: ${DIM}$STARSHIP_CONFIG_FILE${NC}"
    echo ""

    echo -e "${BOLD}Useful Commands:${NC}"
    echo ""
    echo -e "  ${PURPLE}${ICON_BULLET}${NC} ${DIM}starship explain${NC}      - Show active modules"
    echo -e "  ${PURPLE}${ICON_BULLET}${NC} ${DIM}starship print-config${NC} - Show full configuration"
    echo -e "  ${PURPLE}${ICON_BULLET}${NC} ${DIM}starship preset${NC}       - List available presets"
    echo -e "  ${PURPLE}${ICON_BULLET}${NC} ${DIM}starship toggle${NC}       - Toggle a module on/off"
    echo ""

    echo -e "${BOLD}Preset Commands:${NC}"
    echo ""
    echo -e "  ${PURPLE}${ICON_BULLET}${NC} ${DIM}starship preset nerd-font-symbols -o ~/.config/starship.toml${NC}"
    echo -e "  ${PURPLE}${ICON_BULLET}${NC} ${DIM}starship preset plain-text-symbols -o ~/.config/starship.toml${NC}"
    echo -e "  ${PURPLE}${ICON_BULLET}${NC} ${DIM}starship preset pure-preset -o ~/.config/starship.toml${NC}"
    echo ""

    echo -e "${BOLD}Configuration:${NC}"
    echo ""
    echo -e "  ${PURPLE}${ICON_BULLET}${NC} Config file: ${DIM}$STARSHIP_CONFIG_FILE${NC}"
    echo -e "  ${PURPLE}${ICON_BULLET}${NC} Documentation: ${DIM}https://starship.rs/config/${NC}"
    echo ""

    echo -e "${DIM}For more information: https://starship.rs${NC}"
    echo ""
}

# =============================================================================
# Uninstallation
# =============================================================================
uninstall() {
    print_header "Uninstall ${MODULE_NAME}"

    if confirm "Remove Starship and its configuration?" "n"; then
        # Uninstall Starship
        if is_macos && has_brew; then
            if brew list starship &>/dev/null; then
                spinner "Uninstalling Starship" brew uninstall starship
                print_success "Starship uninstalled"
            fi
        else
            # Remove binary
            local starship_bin
            starship_bin=$(which starship 2>/dev/null)
            if [[ -n "$starship_bin" ]]; then
                if [[ -w "$starship_bin" ]] || [[ -w "$(dirname "$starship_bin")" ]]; then
                    rm -f "$starship_bin"
                    print_success "Removed: $starship_bin"
                else
                    print_info "Run: sudo rm $starship_bin"
                fi
            fi
        fi

        # Remove configuration
        if [[ -f "$STARSHIP_CONFIG_FILE" ]]; then
            if confirm "Remove $STARSHIP_CONFIG_FILE?" "y"; then
                rm -f "$STARSHIP_CONFIG_FILE"
                print_success "Removed: $STARSHIP_CONFIG_FILE"
            fi
        fi

        # Remove from shell config
        print_info "Remember to remove 'eval \"\$(starship init zsh)\"' from ~/.zshrc"

        print_success "Starship uninstalled"
    else
        print_info "Uninstallation cancelled"
    fi
}

# =============================================================================
# Main Installation Flow
# =============================================================================
main() {
    show_header

    # Parse arguments
    case "${1:-}" in
        --uninstall|-u)
            uninstall
            return $?
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --help, -h       Show this help message"
            echo "  --uninstall, -u  Uninstall Starship"
            echo ""
            return 0
            ;;
    esac

    # Check dependencies
    if ! check_dependencies; then
        return 1
    fi

    # Check for Nerd Fonts (informational only)
    check_nerd_fonts

    # Install Starship
    echo ""
    if ! install_starship; then
        return 1
    fi

    # Configure shell
    configure_shell

    # Create configuration file
    if confirm "Create a Starship configuration file?" "y"; then
        create_config
    fi

    # Show instructions
    show_instructions

    return 0
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
