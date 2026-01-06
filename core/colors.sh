#!/usr/bin/env bash
# =============================================================================
# colors.sh - Terminal Color Definitions
# =============================================================================
# Provides ANSI color codes and modifiers for consistent terminal output
# across all modules in the terminal-customization gallery.
#
# Usage:
#   source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"
#   echo -e "${GREEN}Success!${NC}"
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_COLORS_SH_LOADED:-}" ]] && return 0
readonly _COLORS_SH_LOADED=1

# =============================================================================
# Regular Colors
# =============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
ORANGE='\033[0;38;5;208m'

# =============================================================================
# Bold Colors
# =============================================================================
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_PURPLE='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

# =============================================================================
# Modifiers
# =============================================================================
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'
HIDDEN='\033[8m'
STRIKETHROUGH='\033[9m'

# Reset / No Color
NC='\033[0m'
RESET='\033[0m'

# =============================================================================
# Status Aliases (Semantic Colors)
# =============================================================================
SUCCESS="${GREEN}"
ERROR="${RED}"
WARNING="${YELLOW}"
INFO="${CYAN}"
DEBUG="${DIM}"
HIGHLIGHT="${BOLD_WHITE}"

# =============================================================================
# Background Colors
# =============================================================================
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# =============================================================================
# Utility Functions
# =============================================================================

# Check if terminal supports colors
# Returns: 0 if colors supported, 1 otherwise
colors_supported() {
    [[ -t 1 ]] && [[ "${TERM:-dumb}" != "dumb" ]] && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]
}

# Disable colors if terminal doesn't support them
disable_colors_if_needed() {
    if ! colors_supported; then
        # Unset color variables by redefining as empty
        RED=''
        GREEN=''
        YELLOW=''
        BLUE=''
        PURPLE=''
        CYAN=''
        WHITE=''
        ORANGE=''
        BOLD=''
        DIM=''
        NC=''
        RESET=''
        SUCCESS=''
        ERROR=''
        WARNING=''
        INFO=''
    fi
}

# Export all color variables for subshells
export RED GREEN YELLOW BLUE PURPLE CYAN WHITE ORANGE
export BOLD_RED BOLD_GREEN BOLD_YELLOW BOLD_BLUE BOLD_PURPLE BOLD_CYAN BOLD_WHITE
export BOLD DIM ITALIC UNDERLINE BLINK REVERSE HIDDEN STRIKETHROUGH
export NC RESET
export SUCCESS ERROR WARNING INFO DEBUG HIGHLIGHT
export BG_RED BG_GREEN BG_YELLOW BG_BLUE BG_PURPLE BG_CYAN BG_WHITE
