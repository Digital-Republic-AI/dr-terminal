#!/usr/bin/env bash
# =============================================================================
# installers.sh - Installation Wrapper Functions
# =============================================================================
# Provides consistent installation functions with error handling, progress
# indicators, and logging for various package managers and tools.
#
# Usage:
#   source "$(dirname "${BASH_SOURCE[0]}")/installers.sh"
#   install_with_brew git
#   clone_repo "https://github.com/user/repo" "$HOME/repo"
# =============================================================================

set -e

# Prevent multiple sourcing
[[ -n "${_INSTALLERS_SH_LOADED:-}" ]] && return 0
readonly _INSTALLERS_SH_LOADED=1

# Source dependencies
CORE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CORE_DIR}/colors.sh"
source "${CORE_DIR}/ui.sh"
source "${CORE_DIR}/validators.sh"

# =============================================================================
# Homebrew Installation Functions
# =============================================================================

# Install a package using Homebrew
# Arguments:
#   $1 - Package/formula name
#   $2 - (optional) Display name for status messages
# Returns: 0 on success, 1 on failure
install_with_brew() {
    local package="$1"
    local display_name="${2:-$package}"

    # Check if Homebrew is available
    if ! has_brew; then
        print_error "Homebrew is not installed"
        return 1
    fi

    # Check if already installed
    if brew list "$package" &>/dev/null; then
        print_info "$display_name is already installed"
        return 0
    fi

    # Install with spinner
    if spinner "Installing $display_name" brew install "$package"; then
        print_success "$display_name installed successfully"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

# Install multiple packages using Homebrew
# Arguments:
#   $@ - Package names to install
# Returns: 0 if all succeed, 1 if any fails
install_with_brew_multiple() {
    local packages=("$@")
    local failed=0

    for package in "${packages[@]}"; do
        if ! install_with_brew "$package"; then
            ((failed++))
        fi
    done

    return $((failed > 0 ? 1 : 0))
}

# Install an application using Homebrew Cask
# Arguments:
#   $1 - Cask name
#   $2 - (optional) Display name for status messages
# Returns: 0 on success, 1 on failure
install_with_cask() {
    local cask="$1"
    local display_name="${2:-$cask}"

    # Check if Homebrew is available
    if ! has_brew; then
        print_error "Homebrew is not installed"
        return 1
    fi

    # Check if already installed
    if brew list --cask "$cask" &>/dev/null; then
        print_info "$display_name is already installed"
        return 0
    fi

    # Install with spinner
    if spinner "Installing $display_name" brew install --cask "$cask"; then
        print_success "$display_name installed successfully"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

# Update Homebrew and upgrade all packages
# Returns: 0 on success, 1 on failure
update_brew() {
    if ! has_brew; then
        print_error "Homebrew is not installed"
        return 1
    fi

    print_info "Updating Homebrew..."

    if spinner "Updating Homebrew" brew update; then
        print_success "Homebrew updated"
    else
        print_warning "Homebrew update had issues (continuing anyway)"
    fi

    return 0
}

# Check if a brew formula is installed
# Arguments:
#   $1 - Formula name
# Returns: 0 if installed, 1 otherwise
brew_formula_installed() {
    local formula="$1"
    brew list "$formula" &>/dev/null
}

# Check if a brew cask is installed
# Arguments:
#   $1 - Cask name
# Returns: 0 if installed, 1 otherwise
brew_cask_installed() {
    local cask="$1"
    brew list --cask "$cask" &>/dev/null
}

# =============================================================================
# Git Clone Functions
# =============================================================================

# Clone a git repository with error handling
# Arguments:
#   $1 - Repository URL
#   $2 - Destination directory
#   $3 - (optional) Branch name
#   $4 - (optional) Depth for shallow clone
# Returns: 0 on success, 1 on failure
clone_repo() {
    local url="$1"
    local destination="$2"
    local branch="${3:-}"
    local depth="${4:-}"

    # Check if git is available
    if ! command_exists git; then
        print_error "Git is not installed"
        return 1
    fi

    # Check if destination already exists
    if [[ -d "$destination" ]]; then
        if [[ -d "$destination/.git" ]]; then
            print_info "Repository already exists at $destination"
            # Optionally update
            if confirm "Update existing repository?" "n"; then
                print_info "Updating repository..."
                if git -C "$destination" pull --ff-only &>/dev/null; then
                    print_success "Repository updated"
                    return 0
                else
                    print_warning "Could not update (may have local changes)"
                    return 0
                fi
            fi
            return 0
        else
            print_error "Destination exists but is not a git repository: $destination"
            return 1
        fi
    fi

    # Create parent directory if needed
    local parent_dir
    parent_dir="$(dirname "$destination")"
    if [[ ! -d "$parent_dir" ]]; then
        mkdir -p "$parent_dir" || {
            print_error "Failed to create directory: $parent_dir"
            return 1
        }
    fi

    # Build clone command
    local clone_cmd=(git clone)

    [[ -n "$branch" ]] && clone_cmd+=(--branch "$branch")
    [[ -n "$depth" ]] && clone_cmd+=(--depth "$depth")

    clone_cmd+=("$url" "$destination")

    # Clone with spinner
    local repo_name
    repo_name="$(basename "$url" .git)"

    if spinner "Cloning $repo_name" "${clone_cmd[@]}"; then
        print_success "Repository cloned to $destination"
        return 0
    else
        print_error "Failed to clone repository"
        return 1
    fi
}

# Clone a repository (shallow clone, single branch)
# Arguments:
#   $1 - Repository URL
#   $2 - Destination directory
# Returns: 0 on success, 1 on failure
clone_repo_shallow() {
    clone_repo "$1" "$2" "" 1
}

# =============================================================================
# Download Functions
# =============================================================================

# Download a file with progress indication
# Arguments:
#   $1 - URL to download
#   $2 - Destination file path
#   $3 - (optional) Display name for status messages
# Returns: 0 on success, 1 on failure
download_file() {
    local url="$1"
    local destination="$2"
    local display_name="${3:-$(basename "$destination")}"

    # Create parent directory if needed
    local parent_dir
    parent_dir="$(dirname "$destination")"
    if [[ ! -d "$parent_dir" ]]; then
        mkdir -p "$parent_dir" || {
            print_error "Failed to create directory: $parent_dir"
            return 1
        }
    fi

    # Check for download tool
    if command_exists curl; then
        if spinner "Downloading $display_name" curl -fsSL -o "$destination" "$url"; then
            print_success "$display_name downloaded"
            return 0
        fi
    elif command_exists wget; then
        if spinner "Downloading $display_name" wget -q -O "$destination" "$url"; then
            print_success "$display_name downloaded"
            return 0
        fi
    else
        print_error "Neither curl nor wget is available"
        return 1
    fi

    print_error "Failed to download $display_name"
    return 1
}

# Download and extract a tarball
# Arguments:
#   $1 - URL to download
#   $2 - Destination directory for extraction
#   $3 - (optional) Strip components count
# Returns: 0 on success, 1 on failure
download_and_extract_tar() {
    local url="$1"
    local destination="$2"
    local strip="${3:-0}"

    # Create destination directory
    mkdir -p "$destination" || {
        print_error "Failed to create directory: $destination"
        return 1
    }

    local display_name
    display_name="$(basename "$url")"

    print_info "Downloading and extracting $display_name..."

    if command_exists curl; then
        if curl -fsSL "$url" | tar -xz -C "$destination" --strip-components="$strip"; then
            print_success "Extracted to $destination"
            return 0
        fi
    elif command_exists wget; then
        if wget -qO- "$url" | tar -xz -C "$destination" --strip-components="$strip"; then
            print_success "Extracted to $destination"
            return 0
        fi
    else
        print_error "Neither curl nor wget is available"
        return 1
    fi

    print_error "Failed to download and extract $display_name"
    return 1
}

# Download and extract a zip file
# Arguments:
#   $1 - URL to download
#   $2 - Destination directory for extraction
# Returns: 0 on success, 1 on failure
download_and_extract_zip() {
    local url="$1"
    local destination="$2"

    # Check for unzip
    if ! command_exists unzip; then
        print_error "unzip is not installed"
        return 1
    fi

    # Create temp file
    local temp_file
    temp_file="$(mktemp)"

    # Download
    if ! download_file "$url" "$temp_file" "archive"; then
        rm -f "$temp_file"
        return 1
    fi

    # Extract
    mkdir -p "$destination" || {
        print_error "Failed to create directory: $destination"
        rm -f "$temp_file"
        return 1
    }

    if unzip -q -o "$temp_file" -d "$destination"; then
        print_success "Extracted to $destination"
        rm -f "$temp_file"
        return 0
    else
        print_error "Failed to extract archive"
        rm -f "$temp_file"
        return 1
    fi
}

# =============================================================================
# Script Installation Functions
# =============================================================================

# Download and run an installation script
# Arguments:
#   $1 - Script URL
#   $2 - (optional) Arguments to pass to script
# Returns: Script exit code
run_install_script() {
    local url="$1"
    shift
    local args=("$@")

    if ! has_internet; then
        print_error "No internet connection"
        return 1
    fi

    local script_name
    script_name="$(basename "$url")"

    print_info "Running $script_name..."

    if command_exists curl; then
        bash -c "$(curl -fsSL "$url")" -- "${args[@]}"
    elif command_exists wget; then
        bash -c "$(wget -qO- "$url")" -- "${args[@]}"
    else
        print_error "Neither curl nor wget is available"
        return 1
    fi
}

# =============================================================================
# Linux Package Manager Functions
# =============================================================================

# Install package using apt (Debian/Ubuntu)
# Arguments:
#   $1 - Package name
#   $2 - (optional) Display name
# Returns: 0 on success, 1 on failure
install_with_apt() {
    local package="$1"
    local display_name="${2:-$package}"

    if ! has_apt; then
        print_error "apt is not available"
        return 1
    fi

    # Check if already installed
    if dpkg -l "$package" &>/dev/null; then
        print_info "$display_name is already installed"
        return 0
    fi

    # Install (may need sudo)
    if spinner "Installing $display_name" sudo apt-get install -y "$package"; then
        print_success "$display_name installed successfully"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

# Install package using dnf/yum (Fedora/RHEL)
# Arguments:
#   $1 - Package name
#   $2 - (optional) Display name
# Returns: 0 on success, 1 on failure
install_with_dnf() {
    local package="$1"
    local display_name="${2:-$package}"

    local pkg_manager
    if command_exists dnf; then
        pkg_manager="dnf"
    elif command_exists yum; then
        pkg_manager="yum"
    else
        print_error "Neither dnf nor yum is available"
        return 1
    fi

    # Install
    if spinner "Installing $display_name" sudo "$pkg_manager" install -y "$package"; then
        print_success "$display_name installed successfully"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

# Install package using pacman (Arch Linux)
# Arguments:
#   $1 - Package name
#   $2 - (optional) Display name
# Returns: 0 on success, 1 on failure
install_with_pacman() {
    local package="$1"
    local display_name="${2:-$package}"

    if ! has_pacman; then
        print_error "pacman is not available"
        return 1
    fi

    # Install
    if spinner "Installing $display_name" sudo pacman -S --noconfirm "$package"; then
        print_success "$display_name installed successfully"
        return 0
    else
        print_error "Failed to install $display_name"
        return 1
    fi
}

# Install package using the appropriate package manager for current OS
# Arguments:
#   $1 - Package name (or comma-separated: brew_name,apt_name,dnf_name)
#   $2 - (optional) Display name
# Returns: 0 on success, 1 on failure
install_package() {
    local package="$1"
    local display_name="${2:-$package}"

    # Handle platform-specific package names
    local brew_name apt_name dnf_name pacman_name
    if [[ "$package" == *","* ]]; then
        IFS=',' read -r brew_name apt_name dnf_name pacman_name <<< "$package"
    else
        brew_name="$package"
        apt_name="$package"
        dnf_name="$package"
        pacman_name="$package"
    fi

    if is_macos && has_brew; then
        install_with_brew "$brew_name" "$display_name"
    elif has_apt; then
        install_with_apt "$apt_name" "$display_name"
    elif has_dnf; then
        install_with_dnf "$dnf_name" "$display_name"
    elif has_pacman; then
        install_with_pacman "$pacman_name" "$display_name"
    else
        print_error "No supported package manager found"
        return 1
    fi
}

# =============================================================================
# Cleanup Functions
# =============================================================================

# Remove a Homebrew package
# Arguments:
#   $1 - Package name
# Returns: 0 on success, 1 on failure
uninstall_brew() {
    local package="$1"

    if ! has_brew; then
        print_error "Homebrew is not installed"
        return 1
    fi

    if ! brew list "$package" &>/dev/null; then
        print_info "$package is not installed"
        return 0
    fi

    if spinner "Uninstalling $package" brew uninstall "$package"; then
        print_success "$package uninstalled"
        return 0
    else
        print_error "Failed to uninstall $package"
        return 1
    fi
}

# =============================================================================
# Export Functions
# =============================================================================
export -f install_with_brew install_with_brew_multiple install_with_cask
export -f update_brew brew_formula_installed brew_cask_installed
export -f clone_repo clone_repo_shallow
export -f download_file download_and_extract_tar download_and_extract_zip
export -f run_install_script
export -f install_with_apt install_with_dnf install_with_pacman install_package
export -f uninstall_brew
