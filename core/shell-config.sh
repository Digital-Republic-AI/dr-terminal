#!/usr/bin/env bash
# =============================================================================
# shell-config.sh - Shell Configuration Management
# =============================================================================
# Provides functions for safely modifying shell configuration files,
# particularly .zshrc and Oh My ZSH configurations.
#
# Usage:
#   source "$(dirname "${BASH_SOURCE[0]}")/shell-config.sh"
#   backup_zshrc
#   add_to_zshrc "export PATH=\"\$HOME/bin:\$PATH\""
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_SHELL_CONFIG_SH_LOADED:-}" ]] && return 0
readonly _SHELL_CONFIG_SH_LOADED=1

# Source dependencies
CORE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CORE_DIR}/colors.sh"
source "${CORE_DIR}/ui.sh"
source "${CORE_DIR}/validators.sh"

# =============================================================================
# Configuration Paths
# =============================================================================

# Get zshrc path
get_zshrc_path() {
    echo "${ZDOTDIR:-$HOME}/.zshrc"
}

# Get zsh profile path
get_zprofile_path() {
    echo "${ZDOTDIR:-$HOME}/.zprofile"
}

# Get bashrc path
get_bashrc_path() {
    echo "$HOME/.bashrc"
}

# Get bash profile path
get_bash_profile_path() {
    if [[ -f "$HOME/.bash_profile" ]]; then
        echo "$HOME/.bash_profile"
    else
        echo "$HOME/.profile"
    fi
}

# Get Oh My ZSH directory
get_omz_dir() {
    echo "${ZSH:-$HOME/.oh-my-zsh}"
}

# Get Oh My ZSH custom directory
get_omz_custom_dir() {
    echo "${ZSH_CUSTOM:-$(get_omz_dir)/custom}"
}

# =============================================================================
# Backup Functions
# =============================================================================

# Create a timestamped backup of .zshrc
# Arguments:
#   $1 - (optional) Backup directory, defaults to ~/.config/zsh-backups
# Returns: Backup file path via stdout, 0 on success, 1 on failure
backup_zshrc() {
    local backup_dir="${1:-$HOME/.config/zsh-backups}"
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Check if .zshrc exists
    if [[ ! -f "$zshrc_path" ]]; then
        print_warning "No .zshrc file found to backup"
        return 0
    fi

    # Create backup directory
    if ! mkdir -p "$backup_dir"; then
        print_error "Failed to create backup directory: $backup_dir"
        return 1
    fi

    # Generate backup filename with timestamp
    local timestamp
    timestamp="$(date +%Y%m%d_%H%M%S)"
    local backup_file="${backup_dir}/zshrc_${timestamp}.bak"

    # Create backup
    if cp "$zshrc_path" "$backup_file"; then
        print_success "Backup created: $backup_file"
        echo "$backup_file"
        return 0
    else
        print_error "Failed to create backup"
        return 1
    fi
}

# Restore .zshrc from backup
# Arguments:
#   $1 - Backup file path
# Returns: 0 on success, 1 on failure
restore_zshrc() {
    local backup_file="$1"
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if [[ ! -f "$backup_file" ]]; then
        print_error "Backup file not found: $backup_file"
        return 1
    fi

    if cp "$backup_file" "$zshrc_path"; then
        print_success "Restored from: $backup_file"
        return 0
    else
        print_error "Failed to restore backup"
        return 1
    fi
}

# List available backups
# Arguments:
#   $1 - (optional) Backup directory
# Returns: List of backup files via stdout
list_zshrc_backups() {
    local backup_dir="${1:-$HOME/.config/zsh-backups}"

    if [[ ! -d "$backup_dir" ]]; then
        print_info "No backups directory found"
        return 0
    fi

    local backups
    backups=$(find "$backup_dir" -name "zshrc_*.bak" -type f 2>/dev/null | sort -r)

    if [[ -z "$backups" ]]; then
        print_info "No backups found"
        return 0
    fi

    echo "$backups"
}

# =============================================================================
# Line Addition Functions
# =============================================================================

# Check if a line exists in a file (exact or pattern match)
# Arguments:
#   $1 - File path
#   $2 - Line or pattern to search for
#   $3 - (optional) "exact" for exact match, "pattern" for regex (default: exact)
# Returns: 0 if found, 1 if not found
line_exists_in_file() {
    local file="$1"
    local search="$2"
    local match_type="${3:-exact}"

    [[ ! -f "$file" ]] && return 1

    if [[ "$match_type" == "exact" ]]; then
        grep -Fxq "$search" "$file"
    else
        grep -Eq "$search" "$file"
    fi
}

# Add a line to .zshrc idempotently
# Arguments:
#   $1 - Line to add
#   $2 - (optional) Comment describing the line
#   $3 - (optional) Position: "top", "bottom", or "after:pattern" (default: bottom)
# Returns: 0 on success, 1 on failure
add_to_zshrc() {
    local line="$1"
    local comment="${2:-}"
    local position="${3:-bottom}"
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Create .zshrc if it doesn't exist
    if [[ ! -f "$zshrc_path" ]]; then
        touch "$zshrc_path" || {
            print_error "Failed to create .zshrc"
            return 1
        }
    fi

    # Check if line already exists
    if line_exists_in_file "$zshrc_path" "$line" "exact"; then
        print_info "Line already exists in .zshrc"
        return 0
    fi

    # Prepare line with optional comment
    local full_line="$line"
    if [[ -n "$comment" ]]; then
        full_line="# $comment"$'\n'"$line"
    fi

    # Add line based on position
    case "$position" in
        top)
            # Add to top of file
            local temp_file
            temp_file="$(mktemp)"
            echo "$full_line" > "$temp_file"
            echo "" >> "$temp_file"
            cat "$zshrc_path" >> "$temp_file"
            mv "$temp_file" "$zshrc_path"
            ;;
        bottom)
            # Add to bottom of file
            echo "" >> "$zshrc_path"
            echo "$full_line" >> "$zshrc_path"
            ;;
        after:*)
            # Add after a specific pattern
            local pattern="${position#after:}"
            if grep -q "$pattern" "$zshrc_path"; then
                local temp_file
                temp_file="$(mktemp)"
                awk -v line="$full_line" -v pattern="$pattern" '
                    { print }
                    $0 ~ pattern { print ""; print line }
                ' "$zshrc_path" > "$temp_file"
                mv "$temp_file" "$zshrc_path"
            else
                # Pattern not found, add to bottom
                echo "" >> "$zshrc_path"
                echo "$full_line" >> "$zshrc_path"
            fi
            ;;
        *)
            print_error "Invalid position: $position"
            return 1
            ;;
    esac

    print_success "Added to .zshrc: $line"
    return 0
}

# Remove a line from .zshrc
# Arguments:
#   $1 - Line or pattern to remove
#   $2 - (optional) "exact" or "pattern" (default: exact)
# Returns: 0 on success, 1 on failure
remove_from_zshrc() {
    local search="$1"
    local match_type="${2:-exact}"
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if [[ ! -f "$zshrc_path" ]]; then
        print_warning "No .zshrc file found"
        return 0
    fi

    local temp_file
    temp_file="$(mktemp)"

    if [[ "$match_type" == "exact" ]]; then
        grep -Fxv "$search" "$zshrc_path" > "$temp_file"
    else
        grep -Ev "$search" "$zshrc_path" > "$temp_file"
    fi

    mv "$temp_file" "$zshrc_path"
    print_success "Removed from .zshrc"
    return 0
}

# =============================================================================
# Source Statement Functions
# =============================================================================

# Add a source statement to .zshrc
# Arguments:
#   $1 - File path to source
#   $2 - (optional) Comment/description
# Returns: 0 on success, 1 on failure
source_in_zshrc() {
    local file_path="$1"
    local comment="${2:-}"

    # Validate file exists
    if [[ ! -f "$file_path" ]]; then
        print_warning "File to source does not exist: $file_path"
    fi

    # Create source line with existence check
    local source_line="[[ -f \"$file_path\" ]] && source \"$file_path\""

    add_to_zshrc "$source_line" "$comment"
}

# Add a source statement with lazy loading
# Arguments:
#   $1 - File path to source
#   $2 - Trigger commands (space-separated)
#   $3 - (optional) Comment/description
# Returns: 0 on success, 1 on failure
source_lazy_in_zshrc() {
    local file_path="$1"
    local triggers="$2"
    local comment="${3:-Lazy load: $file_path}"

    # Create lazy loading function
    local lazy_block="# $comment
_lazy_load_${triggers// /_}() {
    unfunction \"\$0\" 2>/dev/null
    [[ -f \"$file_path\" ]] && source \"$file_path\"
}
for cmd in $triggers; do
    eval \"\$cmd() { _lazy_load_${triggers// /_}; \$cmd \\\"\\\$@\\\"; }\"
done"

    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Check if already present
    if grep -q "_lazy_load_${triggers// /_}" "$zshrc_path" 2>/dev/null; then
        print_info "Lazy loading already configured for: $triggers"
        return 0
    fi

    echo "" >> "$zshrc_path"
    echo "$lazy_block" >> "$zshrc_path"

    print_success "Added lazy loading for: $triggers"
    return 0
}

# =============================================================================
# Oh My ZSH Plugin Functions
# =============================================================================

# Add a plugin to Oh My ZSH plugins array
# Arguments:
#   $1 - Plugin name
# Returns: 0 on success, 1 on failure
add_plugin_omz() {
    local plugin="$1"
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if [[ ! -f "$zshrc_path" ]]; then
        print_error "No .zshrc file found"
        return 1
    fi

    # Check if plugins line exists
    if ! grep -q "^plugins=(" "$zshrc_path"; then
        print_error "Could not find plugins=(...) in .zshrc"
        print_info "Please add the plugin manually: plugins=(...  $plugin)"
        return 1
    fi

    # Check if plugin is already in the list
    if grep -E "^plugins=\(.*\b${plugin}\b" "$zshrc_path" &>/dev/null; then
        print_info "Plugin '$plugin' is already enabled"
        return 0
    fi

    # Add plugin to the array
    # Handle both single-line and multi-line plugin arrays
    local temp_file
    temp_file="$(mktemp)"

    if grep -q "^plugins=(" "$zshrc_path" | grep -q ")"; then
        # Single-line format: plugins=(git docker)
        sed "s/^plugins=(\(.*\))/plugins=(\1 $plugin)/" "$zshrc_path" > "$temp_file"
    else
        # Multi-line format: add before closing )
        awk -v plugin="$plugin" '
            /^plugins=\(/ { in_plugins=1 }
            in_plugins && /\)/ {
                sub(/\)/, plugin " )")
                in_plugins=0
            }
            { print }
        ' "$zshrc_path" > "$temp_file"
    fi

    mv "$temp_file" "$zshrc_path"

    print_success "Added plugin: $plugin"
    return 0
}

# Remove a plugin from Oh My ZSH plugins array
# Arguments:
#   $1 - Plugin name
# Returns: 0 on success, 1 on failure
remove_plugin_omz() {
    local plugin="$1"
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if [[ ! -f "$zshrc_path" ]]; then
        print_error "No .zshrc file found"
        return 1
    fi

    local temp_file
    temp_file="$(mktemp)"

    # Remove plugin from the array (handles various spacing)
    sed -E "s/([[:space:]]|^)${plugin}([[:space:]]|$)/\1\2/g" "$zshrc_path" | \
    sed 's/  */ /g' > "$temp_file"

    mv "$temp_file" "$zshrc_path"

    print_success "Removed plugin: $plugin"
    return 0
}

# List currently enabled Oh My ZSH plugins
# Returns: Space-separated list of plugins via stdout
list_plugins_omz() {
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if [[ ! -f "$zshrc_path" ]]; then
        return 1
    fi

    # Extract plugins from the array
    grep -oE "^plugins=\([^)]+\)" "$zshrc_path" | \
    sed 's/plugins=(//' | sed 's/)//' | tr '\n' ' ' | tr -s ' '
}

# Install an Oh My ZSH custom plugin from GitHub
# Arguments:
#   $1 - GitHub repository (user/repo format)
#   $2 - (optional) Plugin name (defaults to repo name)
# Returns: 0 on success, 1 on failure
install_omz_plugin() {
    local repo="$1"
    local plugin_name="${2:-$(basename "$repo")}"

    if ! has_omz; then
        print_error "Oh My ZSH is not installed"
        return 1
    fi

    local custom_dir
    custom_dir="$(get_omz_custom_dir)"
    local plugin_dir="${custom_dir}/plugins/${plugin_name}"

    # Check if already installed
    if [[ -d "$plugin_dir" ]]; then
        print_info "Plugin '$plugin_name' is already installed"
        return 0
    fi

    # Clone the plugin
    if clone_repo "https://github.com/${repo}.git" "$plugin_dir"; then
        print_success "Plugin '$plugin_name' installed"

        # Prompt to add to plugins list
        if confirm "Add '$plugin_name' to plugins list?" "y"; then
            add_plugin_omz "$plugin_name"
        fi

        return 0
    else
        print_error "Failed to install plugin: $plugin_name"
        return 1
    fi
}

# =============================================================================
# Oh My ZSH Theme Functions
# =============================================================================

# Set Oh My ZSH theme
# Arguments:
#   $1 - Theme name
# Returns: 0 on success, 1 on failure
set_omz_theme() {
    local theme="$1"
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if [[ ! -f "$zshrc_path" ]]; then
        print_error "No .zshrc file found"
        return 1
    fi

    local temp_file
    temp_file="$(mktemp)"

    # Replace or add ZSH_THEME line
    if grep -q "^ZSH_THEME=" "$zshrc_path"; then
        sed "s/^ZSH_THEME=.*/ZSH_THEME=\"$theme\"/" "$zshrc_path" > "$temp_file"
        mv "$temp_file" "$zshrc_path"
    else
        add_to_zshrc "ZSH_THEME=\"$theme\"" "Oh My ZSH theme" "top"
    fi

    print_success "Theme set to: $theme"
    return 0
}

# Install an Oh My ZSH custom theme from GitHub
# Arguments:
#   $1 - GitHub repository (user/repo format)
#   $2 - Theme file name (without .zsh-theme extension)
# Returns: 0 on success, 1 on failure
install_omz_theme() {
    local repo="$1"
    local theme_name="$2"

    if ! has_omz; then
        print_error "Oh My ZSH is not installed"
        return 1
    fi

    local custom_dir
    custom_dir="$(get_omz_custom_dir)"
    local themes_dir="${custom_dir}/themes"

    # Create themes directory if needed
    mkdir -p "$themes_dir"

    # Clone to temp and copy theme file
    local temp_dir
    temp_dir="$(mktemp -d)"

    if clone_repo "https://github.com/${repo}.git" "$temp_dir"; then
        # Find theme file
        local theme_file
        theme_file=$(find "$temp_dir" -name "${theme_name}.zsh-theme" -type f | head -n1)

        if [[ -n "$theme_file" ]]; then
            cp "$theme_file" "${themes_dir}/${theme_name}.zsh-theme"
            print_success "Theme '$theme_name' installed"

            # Prompt to set as active theme
            if confirm "Set '$theme_name' as active theme?" "y"; then
                set_omz_theme "$theme_name"
            fi
        else
            print_error "Theme file not found in repository"
            rm -rf "$temp_dir"
            return 1
        fi

        rm -rf "$temp_dir"
        return 0
    else
        rm -rf "$temp_dir"
        return 1
    fi
}

# =============================================================================
# Environment Variable Functions
# =============================================================================

# Add or update an environment variable in .zshrc
# Arguments:
#   $1 - Variable name
#   $2 - Variable value
#   $3 - (optional) Comment
# Returns: 0 on success, 1 on failure
set_env_var_zshrc() {
    local var_name="$1"
    local var_value="$2"
    local comment="${3:-}"
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    # Create .zshrc if needed
    [[ ! -f "$zshrc_path" ]] && touch "$zshrc_path"

    # Check if variable already exists
    if grep -q "^export ${var_name}=" "$zshrc_path"; then
        # Update existing
        local temp_file
        temp_file="$(mktemp)"
        sed "s|^export ${var_name}=.*|export ${var_name}=\"${var_value}\"|" "$zshrc_path" > "$temp_file"
        mv "$temp_file" "$zshrc_path"
        print_success "Updated: $var_name"
    else
        # Add new
        add_to_zshrc "export ${var_name}=\"${var_value}\"" "$comment"
    fi

    return 0
}

# Add to PATH in .zshrc
# Arguments:
#   $1 - Path to add
#   $2 - (optional) Position: "prepend" or "append" (default: prepend)
# Returns: 0 on success, 1 on failure
add_to_path_zshrc() {
    local new_path="$1"
    local position="${2:-prepend}"

    local path_line
    if [[ "$position" == "prepend" ]]; then
        path_line="export PATH=\"${new_path}:\$PATH\""
    else
        path_line="export PATH=\"\$PATH:${new_path}\""
    fi

    # Check if this path is already in .zshrc
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if grep -q "${new_path}" "$zshrc_path" 2>/dev/null; then
        print_info "Path already configured: $new_path"
        return 0
    fi

    add_to_zshrc "$path_line" "Added to PATH"
}

# =============================================================================
# Alias Functions
# =============================================================================

# Add an alias to .zshrc
# Arguments:
#   $1 - Alias name
#   $2 - Alias command
#   $3 - (optional) Comment
# Returns: 0 on success, 1 on failure
add_alias_zshrc() {
    local alias_name="$1"
    local alias_cmd="$2"
    local comment="${3:-}"

    local alias_line="alias ${alias_name}='${alias_cmd}'"

    add_to_zshrc "$alias_line" "$comment"
}

# =============================================================================
# Reload Functions
# =============================================================================

# Source/reload .zshrc in current shell
# Note: This only works when called from an interactive zsh session
reload_zshrc() {
    local zshrc_path
    zshrc_path="$(get_zshrc_path)"

    if [[ -n "${ZSH_VERSION:-}" ]]; then
        # In zsh, source the file
        # shellcheck disable=SC1090
        source "$zshrc_path"
        print_success "Configuration reloaded"
    else
        print_info "Run 'source ~/.zshrc' or start a new terminal to apply changes"
    fi
}

# =============================================================================
# Export Functions
# =============================================================================
export -f get_zshrc_path get_zprofile_path get_bashrc_path get_bash_profile_path
export -f get_omz_dir get_omz_custom_dir
export -f backup_zshrc restore_zshrc list_zshrc_backups
export -f line_exists_in_file add_to_zshrc remove_from_zshrc
export -f source_in_zshrc source_lazy_in_zshrc
export -f add_plugin_omz remove_plugin_omz list_plugins_omz install_omz_plugin
export -f set_omz_theme install_omz_theme
export -f set_env_var_zshrc add_to_path_zshrc add_alias_zshrc
export -f reload_zshrc
