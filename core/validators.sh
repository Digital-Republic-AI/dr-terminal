#!/usr/bin/env bash
# =============================================================================
# validators.sh - System and Environment Validators
# =============================================================================
# Provides validation functions for checking system requirements, installed
# software, and environment conditions.
#
# Usage:
#   source "$(dirname "${BASH_SOURCE[0]}")/validators.sh"
#   if command_exists git; then
#       echo "Git is installed"
#   fi
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_VALIDATORS_SH_LOADED:-}" ]] && return 0
readonly _VALIDATORS_SH_LOADED=1

# Source dependencies
CORE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CORE_DIR}/colors.sh"

# =============================================================================
# Command Existence Validators
# =============================================================================

# Check if a command exists in PATH
# Arguments:
#   $1 - Command name to check
# Returns: 0 if command exists, 1 otherwise
command_exists() {
    local cmd="$1"
    command -v "$cmd" &>/dev/null
}

# Check if multiple commands exist
# Arguments:
#   $@ - Command names to check
# Returns: 0 if all commands exist, 1 if any is missing
commands_exist() {
    local missing=()

    for cmd in "$@"; do
        if ! command_exists "$cmd"; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "${missing[*]}"
        return 1
    fi

    return 0
}

# =============================================================================
# Operating System Detection
# =============================================================================

# Check if running on macOS
# Returns: 0 if macOS, 1 otherwise
is_macos() {
    [[ "$(uname -s)" == "Darwin" ]]
}

# Check if running on Linux
# Returns: 0 if Linux, 1 otherwise
is_linux() {
    [[ "$(uname -s)" == "Linux" ]]
}

# Check if running on Windows (WSL, Git Bash, Cygwin)
# Returns: 0 if Windows environment, 1 otherwise
is_windows() {
    [[ "$(uname -s)" =~ ^(MINGW|MSYS|CYGWIN) ]] || [[ -n "${WSL_DISTRO_NAME:-}" ]]
}

# Get the current OS name
# Returns: 'macos', 'linux', 'windows', or 'unknown'
get_os() {
    if is_macos; then
        echo "macos"
    elif is_linux; then
        echo "linux"
    elif is_windows; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Get Linux distribution name
# Returns: Distribution name (ubuntu, debian, fedora, arch, etc.) or 'unknown'
get_linux_distro() {
    if [[ -f /etc/os-release ]]; then
        # shellcheck source=/dev/null
        source /etc/os-release
        echo "${ID:-unknown}"
    elif command_exists lsb_release; then
        lsb_release -is | tr '[:upper:]' '[:lower:]'
    else
        echo "unknown"
    fi
}

# =============================================================================
# macOS Version Checking
# =============================================================================

# Get macOS version as a comparable number
# Returns: Version number (e.g., 140000 for 14.0.0)
get_macos_version_number() {
    if ! is_macos; then
        echo "0"
        return 1
    fi

    local version
    version=$(sw_vers -productVersion 2>/dev/null)

    # Parse version components
    local major minor patch
    IFS='.' read -r major minor patch <<< "$version"

    # Default minor and patch to 0 if not present
    minor="${minor:-0}"
    patch="${patch:-0}"

    # Create comparable version number (major * 10000 + minor * 100 + patch)
    echo $((major * 10000 + minor * 100 + patch))
}

# Get macOS version string
# Returns: Version string (e.g., "14.0.0")
get_macos_version() {
    if ! is_macos; then
        echo ""
        return 1
    fi

    sw_vers -productVersion 2>/dev/null
}

# Get macOS codename
# Returns: Codename (e.g., "Sonoma", "Ventura")
get_macos_codename() {
    if ! is_macos; then
        echo ""
        return 1
    fi

    local version
    version=$(get_macos_version_number)

    case $((version / 10000)) in
        15) echo "Sequoia" ;;
        14) echo "Sonoma" ;;
        13) echo "Ventura" ;;
        12) echo "Monterey" ;;
        11) echo "Big Sur" ;;
        10)
            case $(( (version % 10000) / 100 )) in
                15) echo "Catalina" ;;
                14) echo "Mojave" ;;
                13) echo "High Sierra" ;;
                12) echo "Sierra" ;;
                11) echo "El Capitan" ;;
                *) echo "OS X" ;;
            esac
            ;;
        *) echo "Unknown" ;;
    esac
}

# Check if macOS version meets minimum requirement
# Arguments:
#   $1 - Minimum version (e.g., "12.0" or "12.0.0")
# Returns: 0 if current version >= minimum, 1 otherwise
check_macos_version() {
    local required="$1"

    if ! is_macos; then
        echo "Not running on macOS" >&2
        return 1
    fi

    local current_version
    current_version=$(get_macos_version_number)

    # Parse required version
    local major minor patch
    IFS='.' read -r major minor patch <<< "$required"
    minor="${minor:-0}"
    patch="${patch:-0}"

    local required_version=$((major * 10000 + minor * 100 + patch))

    [[ $current_version -ge $required_version ]]
}

# =============================================================================
# Package Manager Detection
# =============================================================================

# Check if Homebrew is installed
# Returns: 0 if Homebrew is installed, 1 otherwise
has_brew() {
    command_exists brew
}

# Check if Homebrew is installed and configured
# Returns: 0 if Homebrew is ready to use, 1 otherwise
check_brew() {
    if ! has_brew; then
        return 1
    fi

    # Verify brew is functional
    brew --version &>/dev/null
}

# Get Homebrew prefix
# Returns: Homebrew installation prefix path
get_brew_prefix() {
    if has_brew; then
        brew --prefix 2>/dev/null
    else
        # Return default paths based on architecture
        if [[ "$(uname -m)" == "arm64" ]]; then
            echo "/opt/homebrew"
        else
            echo "/usr/local"
        fi
    fi
}

# Check if apt is available (Debian/Ubuntu)
# Returns: 0 if apt is available, 1 otherwise
has_apt() {
    command_exists apt-get
}

# Check if dnf/yum is available (Fedora/RHEL)
# Returns: 0 if dnf or yum is available, 1 otherwise
has_dnf() {
    command_exists dnf || command_exists yum
}

# Check if pacman is available (Arch)
# Returns: 0 if pacman is available, 1 otherwise
has_pacman() {
    command_exists pacman
}

# =============================================================================
# Shell Environment Detection
# =============================================================================

# Check if Oh My ZSH is installed
# Returns: 0 if Oh My ZSH is installed, 1 otherwise
has_omz() {
    [[ -d "${ZSH:-$HOME/.oh-my-zsh}" ]]
}

# Check if Zsh is the current shell
# Returns: 0 if Zsh, 1 otherwise
is_zsh() {
    [[ -n "${ZSH_VERSION:-}" ]]
}

# Check if Bash is the current shell
# Returns: 0 if Bash, 1 otherwise
is_bash() {
    [[ -n "${BASH_VERSION:-}" ]]
}

# Get current shell name
# Returns: 'zsh', 'bash', 'fish', or 'unknown'
get_current_shell() {
    local shell_path="${SHELL:-}"

    case "$shell_path" in
        */zsh) echo "zsh" ;;
        */bash) echo "bash" ;;
        */fish) echo "fish" ;;
        *) echo "unknown" ;;
    esac
}

# Check if Zsh is the default shell
# Returns: 0 if Zsh is default, 1 otherwise
is_zsh_default_shell() {
    [[ "${SHELL:-}" == *"/zsh" ]]
}

# =============================================================================
# File and Directory Validators
# =============================================================================

# Check if a file exists and is readable
# Arguments:
#   $1 - File path
# Returns: 0 if file exists and is readable, 1 otherwise
file_exists() {
    [[ -f "$1" && -r "$1" ]]
}

# Check if a directory exists and is accessible
# Arguments:
#   $1 - Directory path
# Returns: 0 if directory exists and is accessible, 1 otherwise
dir_exists() {
    [[ -d "$1" && -x "$1" ]]
}

# Check if path is writable
# Arguments:
#   $1 - Path to check
# Returns: 0 if writable, 1 otherwise
is_writable() {
    [[ -w "$1" ]]
}

# =============================================================================
# Network Validators
# =============================================================================

# Check if we have internet connectivity
# Arguments:
#   $1 - (optional) Timeout in seconds, defaults to 5
# Returns: 0 if connected, 1 otherwise
has_internet() {
    local timeout="${1:-5}"

    # Try multiple reliable hosts
    local hosts=("github.com" "google.com" "cloudflare.com")

    for host in "${hosts[@]}"; do
        if ping -c 1 -W "$timeout" "$host" &>/dev/null; then
            return 0
        fi
    done

    # Fallback to curl check
    if command_exists curl; then
        curl --silent --head --max-time "$timeout" "https://github.com" &>/dev/null && return 0
    fi

    return 1
}

# Check if a URL is accessible
# Arguments:
#   $1 - URL to check
#   $2 - (optional) Timeout in seconds, defaults to 10
# Returns: 0 if accessible, 1 otherwise
url_accessible() {
    local url="$1"
    local timeout="${2:-10}"

    if command_exists curl; then
        curl --silent --head --max-time "$timeout" --fail "$url" &>/dev/null
    elif command_exists wget; then
        wget --spider --timeout="$timeout" --quiet "$url" &>/dev/null
    else
        return 1
    fi
}

# =============================================================================
# Version Comparison Utilities
# =============================================================================

# Compare two semantic versions
# Arguments:
#   $1 - First version
#   $2 - Second version
# Returns: 0 if v1 >= v2, 1 if v1 < v2
version_gte() {
    local v1="$1"
    local v2="$2"

    # Use sort -V for version comparison
    if [[ "$(printf '%s\n%s' "$v1" "$v2" | sort -V | head -n1)" == "$v2" ]]; then
        return 0
    else
        return 1
    fi
}

# Check if installed version meets minimum requirement
# Arguments:
#   $1 - Command to check
#   $2 - Minimum version required
#   $3 - (optional) Version extraction pattern, defaults to extracting first semver
# Returns: 0 if version meets requirement, 1 otherwise
check_version() {
    local cmd="$1"
    local min_version="$2"
    local pattern="${3:-}"

    if ! command_exists "$cmd"; then
        return 1
    fi

    local installed_version

    # Get version from command
    local version_output
    version_output=$("$cmd" --version 2>&1 | head -n1) || return 1

    # Extract version number
    if [[ -n "$pattern" ]]; then
        installed_version=$(echo "$version_output" | grep -oE "$pattern" | head -n1)
    else
        # Default: extract first semver-like pattern
        installed_version=$(echo "$version_output" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1)
    fi

    if [[ -z "$installed_version" ]]; then
        return 1
    fi

    version_gte "$installed_version" "$min_version"
}

# =============================================================================
# Requirement Checking
# =============================================================================

# Check all requirements and report status
# Arguments:
#   $1... - Requirements in format "type:value" (e.g., "cmd:git", "os:macos")
# Returns: 0 if all requirements met, 1 otherwise
check_requirements() {
    local requirements=("$@")
    local failed=0

    for req in "${requirements[@]}"; do
        local type="${req%%:*}"
        local value="${req#*:}"

        case "$type" in
            cmd)
                if ! command_exists "$value"; then
                    echo -e "${ERROR}${ICON_ERROR}${NC} Missing command: $value" >&2
                    ((failed++))
                fi
                ;;
            os)
                case "$value" in
                    macos)
                        if ! is_macos; then
                            echo -e "${ERROR}${ICON_ERROR}${NC} Requires macOS" >&2
                            ((failed++))
                        fi
                        ;;
                    linux)
                        if ! is_linux; then
                            echo -e "${ERROR}${ICON_ERROR}${NC} Requires Linux" >&2
                            ((failed++))
                        fi
                        ;;
                esac
                ;;
            brew)
                if ! has_brew; then
                    echo -e "${ERROR}${ICON_ERROR}${NC} Requires Homebrew" >&2
                    ((failed++))
                fi
                ;;
            omz)
                if ! has_omz; then
                    echo -e "${ERROR}${ICON_ERROR}${NC} Requires Oh My ZSH" >&2
                    ((failed++))
                fi
                ;;
            macos_version)
                if ! check_macos_version "$value"; then
                    echo -e "${ERROR}${ICON_ERROR}${NC} Requires macOS $value or later" >&2
                    ((failed++))
                fi
                ;;
            *)
                echo -e "${WARNING}${ICON_WARNING}${NC} Unknown requirement type: $type" >&2
                ;;
        esac
    done

    return $((failed > 0 ? 1 : 0))
}

# =============================================================================
# Export Functions
# =============================================================================
export -f command_exists commands_exist
export -f is_macos is_linux is_windows get_os get_linux_distro
export -f get_macos_version get_macos_version_number get_macos_codename check_macos_version
export -f has_brew check_brew get_brew_prefix has_apt has_dnf has_pacman
export -f has_omz is_zsh is_bash get_current_shell is_zsh_default_shell
export -f file_exists dir_exists is_writable
export -f has_internet url_accessible
export -f version_gte check_version
export -f check_requirements
