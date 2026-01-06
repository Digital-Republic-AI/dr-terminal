#!/usr/bin/env bash
# =============================================================================
# DR Custom Terminal - ASCII Art Library
# =============================================================================
# A comprehensive collection of ASCII art logos for terminal branding
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_ASCII_ART_LOADED:-}" ]] && return 0
readonly _ASCII_ART_LOADED=1

# =============================================================================
# Color Definitions for ASCII Art
# =============================================================================

# Reset
readonly ASCII_RESET='\033[0m'

# Regular Colors
readonly ASCII_BLACK='\033[0;30m'
readonly ASCII_RED='\033[0;31m'
readonly ASCII_GREEN='\033[0;32m'
readonly ASCII_YELLOW='\033[0;33m'
readonly ASCII_BLUE='\033[0;34m'
readonly ASCII_PURPLE='\033[0;35m'
readonly ASCII_CYAN='\033[0;36m'
readonly ASCII_WHITE='\033[0;37m'

# Bold Colors
readonly ASCII_BOLD_BLACK='\033[1;30m'
readonly ASCII_BOLD_RED='\033[1;31m'
readonly ASCII_BOLD_GREEN='\033[1;32m'
readonly ASCII_BOLD_YELLOW='\033[1;33m'
readonly ASCII_BOLD_BLUE='\033[1;34m'
readonly ASCII_BOLD_PURPLE='\033[1;35m'
readonly ASCII_BOLD_CYAN='\033[1;36m'
readonly ASCII_BOLD_WHITE='\033[1;37m'

# High Intensity Colors
readonly ASCII_BRIGHT_BLACK='\033[0;90m'
readonly ASCII_BRIGHT_RED='\033[0;91m'
readonly ASCII_BRIGHT_GREEN='\033[0;92m'
readonly ASCII_BRIGHT_YELLOW='\033[0;93m'
readonly ASCII_BRIGHT_BLUE='\033[0;94m'
readonly ASCII_BRIGHT_PURPLE='\033[0;95m'
readonly ASCII_BRIGHT_CYAN='\033[0;96m'
readonly ASCII_BRIGHT_WHITE='\033[0;97m'

# Box Drawing Characters
readonly BOX_TL='╔'
readonly BOX_TR='╗'
readonly BOX_BL='╚'
readonly BOX_BR='╝'
readonly BOX_H='═'
readonly BOX_V='║'

# =============================================================================
# Main Project Logo
# =============================================================================

ascii_logo_main() {
    local color="${1:-$ASCII_BOLD_CYAN}"
    local accent="${2:-$ASCII_BOLD_PURPLE}"
    local dim="${3:-$ASCII_BRIGHT_BLACK}"

    echo -e "${dim}${BOX_TL}$(printf '%0.s═' {1..66})${BOX_TR}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}  ${color} _____  _____  ____   __  __  ___  _   _    _    _             ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}  ${color}|_   _|| ____||  _ \\ |  \\/  ||_ _|| \\ | |  / \\  | |            ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}  ${color}  | |  |  _|  | |_) || |\\/| | | | |  \\| | / _ \\ | |            ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}  ${color}  | |  | |___ |  _ < | |  | | | | | |\\  |/ ___ \\| |___         ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}  ${color}  |_|  |_____||_| \\_\\|_|  |_||___||_| \\_/_/   \\_\\_____|        ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}                                                                    ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}  ${accent} ____  _   _  ____  _____  ___   __  __  ___  _____  _____      ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}  ${accent}/ ___|| | | |/ ___||_   _|/ _ \\ |  \\/  ||_ _||__  / | ____|     ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}  ${accent}| |   | | | |\\___ \\  | | | | | || |\\/| | | |   / /  |  _|       ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}  ${accent}| |___| |_| | ___) | | | | |_| || |  | | | |  / /_  | |___      ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}  ${accent} \\____|\\___/ |____/  |_|  \\___/ |_|  |_||___|/____| |_____|     ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}                                                                    ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}        ${ASCII_BRIGHT_WHITE}DR Custom Terminal${ASCII_RESET} ${ASCII_BRIGHT_GREEN}v1.0.0${ASCII_RESET}                    ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_V}${ASCII_RESET}        ${ASCII_BRIGHT_BLACK}Your complete macOS terminal setup solution${ASCII_RESET}               ${dim}${BOX_V}${ASCII_RESET}"
    echo -e "${dim}${BOX_BL}$(printf '%0.s═' {1..66})${BOX_BR}${ASCII_RESET}"
}

# Compact version for smaller displays
ascii_logo_main_compact() {
    local color="${1:-$ASCII_BOLD_CYAN}"

    echo -e "${color}"
    echo -e "  ╭─────────────────────────────────────────╮"
    echo -e "  │  TERMINAL CUSTOMIZATION GALLERY  v1.0  │"
    echo -e "  ╰─────────────────────────────────────────╯"
    echo -e "${ASCII_RESET}"
}

# =============================================================================
# iTerm2 Logo
# =============================================================================

ascii_logo_iterm2() {
    local color="${1:-$ASCII_BOLD_GREEN}"
    local accent="${2:-$ASCII_BRIGHT_GREEN}"

    echo -e "${color}"
    echo -e "     ██╗████████╗███████╗██████╗ ███╗   ███╗██████╗ "
    echo -e "     ██║╚══██╔══╝██╔════╝██╔══██╗████╗ ████║╚════██╗"
    echo -e "     ██║   ██║   █████╗  ██████╔╝██╔████╔██║ █████╔╝"
    echo -e "     ██║   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██╔═══╝ "
    echo -e "     ██║   ██║   ███████╗██║  ██║██║ ╚═╝ ██║███████╗"
    echo -e "     ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝"
    echo -e "${accent}           The macOS Terminal Replacement${ASCII_RESET}"
    echo -e ""
}

ascii_logo_iterm2_small() {
    local color="${1:-$ASCII_BOLD_GREEN}"

    echo -e "${color}  ┌─────────────────┐${ASCII_RESET}"
    echo -e "${color}  │    ${ASCII_BOLD_WHITE}iTerm2${color}       │${ASCII_RESET}"
    echo -e "${color}  │  ${ASCII_BRIGHT_GREEN}Terminal Pro${color}   │${ASCII_RESET}"
    echo -e "${color}  └─────────────────┘${ASCII_RESET}"
}

# =============================================================================
# ZSH Logo
# =============================================================================

ascii_logo_zsh() {
    local color="${1:-$ASCII_BOLD_YELLOW}"
    local accent="${2:-$ASCII_BRIGHT_YELLOW}"

    echo -e "${color}"
    echo -e "    ███████╗███████╗██╗  ██╗"
    echo -e "    ╚══███╔╝██╔════╝██║  ██║"
    echo -e "      ███╔╝ ███████╗███████║"
    echo -e "     ███╔╝  ╚════██║██╔══██║"
    echo -e "    ███████╗███████║██║  ██║"
    echo -e "    ╚══════╝╚══════╝╚═╝  ╚═╝"
    echo -e "${accent}    Z Shell - The Power User's Shell${ASCII_RESET}"
    echo -e ""
}

ascii_logo_zsh_fancy() {
    local z="${1:-$ASCII_BOLD_YELLOW}"
    local s="${2:-$ASCII_BOLD_GREEN}"
    local h="${3:-$ASCII_BOLD_CYAN}"

    echo -e ""
    echo -e "    ${z}╔════════╗${s}╔════════╗${h}╔════════╗${ASCII_RESET}"
    echo -e "    ${z}║   ███  ║${s}║   ███  ║${h}║  ██ ██ ║${ASCII_RESET}"
    echo -e "    ${z}║  ███   ║${s}║ ██     ║${h}║  █████ ║${ASCII_RESET}"
    echo -e "    ${z}║ ███    ║${s}║  ████  ║${h}║  ██ ██ ║${ASCII_RESET}"
    echo -e "    ${z}║ ██████ ║${s}║     ██ ║${h}║  ██ ██ ║${ASCII_RESET}"
    echo -e "    ${z}║ ██████ ║${s}║ █████  ║${h}║  ██ ██ ║${ASCII_RESET}"
    echo -e "    ${z}╚════════╝${s}╚════════╝${h}╚════════╝${ASCII_RESET}"
    echo -e ""
}

# =============================================================================
# Homebrew Logo
# =============================================================================

ascii_logo_homebrew() {
    local color="${1:-$ASCII_BOLD_YELLOW}"
    local accent="${2:-$ASCII_BRIGHT_YELLOW}"

    echo -e "${color}"
    echo -e "    ██╗  ██╗ ██████╗ ███╗   ███╗███████╗██████╗ ██████╗ ███████╗██╗    ██╗"
    echo -e "    ██║  ██║██╔═══██╗████╗ ████║██╔════╝██╔══██╗██╔══██╗██╔════╝██║    ██║"
    echo -e "    ███████║██║   ██║██╔████╔██║█████╗  ██████╔╝██████╔╝█████╗  ██║ █╗ ██║"
    echo -e "    ██╔══██║██║   ██║██║╚██╔╝██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██║███╗██║"
    echo -e "    ██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗██████╔╝██║  ██║███████╗╚███╔███╔╝"
    echo -e "    ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚══╝╚══╝"
    echo -e "${accent}                   The Missing Package Manager for macOS${ASCII_RESET}"
    echo -e ""
}

ascii_logo_homebrew_bottle() {
    local color="${1:-$ASCII_BOLD_YELLOW}"
    local liquid="${2:-$ASCII_BOLD_RED}"

    echo -e "${color}"
    echo -e "              ╭───╮"
    echo -e "              │   │"
    echo -e "            ╭─┴───┴─╮"
    echo -e "            │       │"
    echo -e "            │${liquid}▓▓▓▓▓▓▓${color}│"
    echo -e "            │${liquid}▓▓▓▓▓▓▓${color}│"
    echo -e "            │${liquid}▓▓▓▓▓▓▓${color}│"
    echo -e "            │${liquid}▓▓▓▓▓▓▓${color}│"
    echo -e "            ╰───────╯"
    echo -e "           ${ASCII_BOLD_WHITE}Homebrew${ASCII_RESET}"
    echo -e ""
}

# =============================================================================
# Oh My Zsh Logo
# =============================================================================

ascii_logo_ohmyzsh() {
    local color="${1:-$ASCII_BOLD_BLUE}"
    local accent="${2:-$ASCII_BRIGHT_BLUE}"

    echo -e "${color}"
    echo -e "     ██████╗ ██╗  ██╗    ███╗   ███╗██╗   ██╗    ███████╗███████╗██╗  ██╗"
    echo -e "    ██╔═══██╗██║  ██║    ████╗ ████║╚██╗ ██╔╝    ╚══███╔╝██╔════╝██║  ██║"
    echo -e "    ██║   ██║███████║    ██╔████╔██║ ╚████╔╝       ███╔╝ ███████╗███████║"
    echo -e "    ██║   ██║██╔══██║    ██║╚██╔╝██║  ╚██╔╝       ███╔╝  ╚════██║██╔══██║"
    echo -e "    ╚██████╔╝██║  ██║    ██║ ╚═╝ ██║   ██║       ███████╗███████║██║  ██║"
    echo -e "     ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝   ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝"
    echo -e "${accent}              Your terminal never felt this good before${ASCII_RESET}"
    echo -e ""
}

# =============================================================================
# Powerlevel10k Logo
# =============================================================================

ascii_logo_p10k() {
    local color="${1:-$ASCII_BOLD_PURPLE}"
    local accent="${2:-$ASCII_BRIGHT_PURPLE}"

    echo -e "${color}"
    echo -e "    ██████╗  ██╗ ██████╗ ██╗  ██╗"
    echo -e "    ██╔══██╗███║██╔═████╗██║ ██╔╝"
    echo -e "    ██████╔╝╚██║██║██╔██║█████╔╝ "
    echo -e "    ██╔═══╝  ██║████╔╝██║██╔═██╗ "
    echo -e "    ██║      ██║╚██████╔╝██║  ██╗"
    echo -e "    ╚═╝      ╚═╝ ╚═════╝ ╚═╝  ╚═╝"
    echo -e "${accent}     Powerlevel10k - A ZSH Theme${ASCII_RESET}"
    echo -e ""
}

# =============================================================================
# Starship Logo
# =============================================================================

ascii_logo_starship() {
    local color="${1:-$ASCII_BOLD_YELLOW}"
    local accent="${2:-$ASCII_BRIGHT_CYAN}"

    echo -e "${color}"
    echo -e "    ███████╗████████╗ █████╗ ██████╗ ███████╗██╗  ██╗██╗██████╗ "
    echo -e "    ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██║  ██║██║██╔══██╗"
    echo -e "    ███████╗   ██║   ███████║██████╔╝███████╗███████║██║██████╔╝"
    echo -e "    ╚════██║   ██║   ██╔══██║██╔══██╗╚════██║██╔══██║██║██╔═══╝ "
    echo -e "    ███████║   ██║   ██║  ██║██║  ██║███████║██║  ██║██║██║     "
    echo -e "    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝     "
    echo -e "${accent}      The minimal, blazing-fast, and customizable prompt${ASCII_RESET}"
    echo -e ""
}

ascii_logo_starship_rocket() {
    local color="${1:-$ASCII_BOLD_YELLOW}"
    local flame="${2:-$ASCII_BOLD_RED}"

    echo -e "${color}"
    echo -e "              /\\"
    echo -e "             /  \\"
    echo -e "            |    |"
    echo -e "            |    |"
    echo -e "            | [] |"
    echo -e "            |    |"
    echo -e "           /|    |\\"
    echo -e "          / |    | \\"
    echo -e "         |  |    |  |"
    echo -e "         |  |    |  |"
    echo -e "          \\  \\  /  /"
    echo -e "           \\  \\/  /"
    echo -e "           ${flame} \\/${ASCII_RESET}${flame}\\/${ASCII_RESET}${flame}\\/${ASCII_RESET}"
    echo -e "            ${flame}\\/${ASCII_RESET}  ${flame}\\/${ASCII_RESET}"
    echo -e ""
    echo -e "         ${ASCII_BOLD_WHITE}STARSHIP${ASCII_RESET}"
    echo -e ""
}

# =============================================================================
# Decorative Elements
# =============================================================================

ascii_divider() {
    local width="${1:-60}"
    local char="${2:-─}"
    local color="${3:-$ASCII_BRIGHT_BLACK}"

    echo -e "${color}$(printf "%${width}s" | tr ' ' "$char")${ASCII_RESET}"
}

ascii_divider_fancy() {
    local width="${1:-60}"
    local color="${2:-$ASCII_BRIGHT_CYAN}"

    local half=$((width / 2 - 3))
    echo -e "${color}$(printf "%${half}s" | tr ' ' '─')◆◆◆$(printf "%${half}s" | tr ' ' '─')${ASCII_RESET}"
}

ascii_section_header() {
    local title="$1"
    local width="${2:-60}"
    local color="${3:-$ASCII_BOLD_WHITE}"
    local border_color="${4:-$ASCII_BRIGHT_BLACK}"

    local title_len=${#title}
    local padding=$(( (width - title_len - 4) / 2 ))
    local extra=$(( (width - title_len - 4) % 2 ))

    echo -e "${border_color}╭$(printf '%0.s─' $(seq 1 $((width - 2))))╮${ASCII_RESET}"
    echo -e "${border_color}│${ASCII_RESET}$(printf '%*s' $padding '')${color}${title}${ASCII_RESET}$(printf '%*s' $((padding + extra)) '')${border_color}│${ASCII_RESET}"
    echo -e "${border_color}╰$(printf '%0.s─' $(seq 1 $((width - 2))))╯${ASCII_RESET}"
}

ascii_box() {
    local text="$1"
    local color="${2:-$ASCII_BOLD_WHITE}"
    local border="${3:-$ASCII_BRIGHT_BLACK}"

    local len=${#text}
    local width=$((len + 4))

    echo -e "${border}╭$(printf '%0.s─' $(seq 1 $((width - 2))))╮${ASCII_RESET}"
    echo -e "${border}│${ASCII_RESET} ${color}${text}${ASCII_RESET} ${border}│${ASCII_RESET}"
    echo -e "${border}╰$(printf '%0.s─' $(seq 1 $((width - 2))))╯${ASCII_RESET}"
}

# =============================================================================
# Status Indicators
# =============================================================================

ascii_checkmark() {
    local color="${1:-$ASCII_BOLD_GREEN}"
    echo -e "${color}✓${ASCII_RESET}"
}

ascii_cross() {
    local color="${1:-$ASCII_BOLD_RED}"
    echo -e "${color}✗${ASCII_RESET}"
}

ascii_warning() {
    local color="${1:-$ASCII_BOLD_YELLOW}"
    echo -e "${color}⚠${ASCII_RESET}"
}

ascii_info() {
    local color="${1:-$ASCII_BOLD_BLUE}"
    echo -e "${color}ℹ${ASCII_RESET}"
}

ascii_arrow() {
    local color="${1:-$ASCII_BOLD_CYAN}"
    echo -e "${color}→${ASCII_RESET}"
}

ascii_bullet() {
    local color="${1:-$ASCII_BOLD_WHITE}"
    echo -e "${color}•${ASCII_RESET}"
}

# =============================================================================
# Progress Indicators
# =============================================================================

ascii_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local color="${2:-$ASCII_BOLD_CYAN}"

    while kill -0 "$pid" 2>/dev/null; do
        for (( i=0; i<${#spinstr}; i++ )); do
            printf "\r${color}${spinstr:$i:1}${ASCII_RESET} "
            sleep $delay
        done
    done
    printf "\r"
}

ascii_progress_bar() {
    local current=$1
    local total=$2
    local width="${3:-40}"
    local color="${4:-$ASCII_BOLD_GREEN}"
    local bg="${5:-$ASCII_BRIGHT_BLACK}"

    local percent=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    printf "\r${color}"
    printf "["
    printf "%0.s█" $(seq 1 $filled) 2>/dev/null || true
    printf "${bg}"
    printf "%0.s░" $(seq 1 $empty) 2>/dev/null || true
    printf "${color}]"
    printf " %3d%%" $percent
    printf "${ASCII_RESET}"
}

# =============================================================================
# Logo Display Function
# =============================================================================

# Display any logo by name
# Usage: display_logo <logo_name> [color1] [color2] [color3]
display_logo() {
    local logo_name="${1:-main}"
    shift

    case "$logo_name" in
        main|terminal)
            ascii_logo_main "$@"
            ;;
        main-compact|compact)
            ascii_logo_main_compact "$@"
            ;;
        iterm2|iterm)
            ascii_logo_iterm2 "$@"
            ;;
        iterm2-small|iterm-small)
            ascii_logo_iterm2_small "$@"
            ;;
        zsh)
            ascii_logo_zsh "$@"
            ;;
        zsh-fancy)
            ascii_logo_zsh_fancy "$@"
            ;;
        homebrew|brew)
            ascii_logo_homebrew "$@"
            ;;
        homebrew-bottle|brew-bottle)
            ascii_logo_homebrew_bottle "$@"
            ;;
        ohmyzsh|omz)
            ascii_logo_ohmyzsh "$@"
            ;;
        p10k|powerlevel10k)
            ascii_logo_p10k "$@"
            ;;
        starship)
            ascii_logo_starship "$@"
            ;;
        starship-rocket|rocket)
            ascii_logo_starship_rocket "$@"
            ;;
        *)
            echo -e "${ASCII_BOLD_RED}Unknown logo: ${logo_name}${ASCII_RESET}"
            echo "Available logos:"
            echo "  main, main-compact, iterm2, iterm2-small, zsh, zsh-fancy"
            echo "  homebrew, homebrew-bottle, ohmyzsh, p10k, starship, starship-rocket"
            return 1
            ;;
    esac
}

# List all available logos
list_logos() {
    echo -e "${ASCII_BOLD_WHITE}Available ASCII Art Logos:${ASCII_RESET}"
    echo ""
    echo -e "  ${ASCII_BOLD_CYAN}main${ASCII_RESET}             - Main project banner"
    echo -e "  ${ASCII_BOLD_CYAN}main-compact${ASCII_RESET}     - Compact project banner"
    echo -e "  ${ASCII_BOLD_CYAN}iterm2${ASCII_RESET}           - iTerm2 logo"
    echo -e "  ${ASCII_BOLD_CYAN}iterm2-small${ASCII_RESET}     - Small iTerm2 box"
    echo -e "  ${ASCII_BOLD_CYAN}zsh${ASCII_RESET}              - ZSH logo"
    echo -e "  ${ASCII_BOLD_CYAN}zsh-fancy${ASCII_RESET}        - Colorful ZSH logo"
    echo -e "  ${ASCII_BOLD_CYAN}homebrew${ASCII_RESET}         - Homebrew text logo"
    echo -e "  ${ASCII_BOLD_CYAN}homebrew-bottle${ASCII_RESET}  - Homebrew bottle art"
    echo -e "  ${ASCII_BOLD_CYAN}ohmyzsh${ASCII_RESET}          - Oh My Zsh logo"
    echo -e "  ${ASCII_BOLD_CYAN}p10k${ASCII_RESET}             - Powerlevel10k logo"
    echo -e "  ${ASCII_BOLD_CYAN}starship${ASCII_RESET}         - Starship prompt logo"
    echo -e "  ${ASCII_BOLD_CYAN}starship-rocket${ASCII_RESET}  - Starship rocket art"
}

# =============================================================================
# Welcome Message Generator
# =============================================================================

welcome_message() {
    local user="${1:-$USER}"
    local color="${2:-$ASCII_BOLD_CYAN}"

    clear
    ascii_logo_main
    echo ""
    echo -e "  ${ASCII_BOLD_WHITE}Welcome, ${color}${user}${ASCII_BOLD_WHITE}!${ASCII_RESET}"
    echo ""
    ascii_divider_fancy 60
    echo ""
}

# =============================================================================
# Export all functions
# =============================================================================

export -f ascii_logo_main
export -f ascii_logo_main_compact
export -f ascii_logo_iterm2
export -f ascii_logo_iterm2_small
export -f ascii_logo_zsh
export -f ascii_logo_zsh_fancy
export -f ascii_logo_homebrew
export -f ascii_logo_homebrew_bottle
export -f ascii_logo_ohmyzsh
export -f ascii_logo_p10k
export -f ascii_logo_starship
export -f ascii_logo_starship_rocket
export -f ascii_divider
export -f ascii_divider_fancy
export -f ascii_section_header
export -f ascii_box
export -f ascii_checkmark
export -f ascii_cross
export -f ascii_warning
export -f ascii_info
export -f ascii_arrow
export -f ascii_bullet
export -f ascii_spinner
export -f ascii_progress_bar
export -f display_logo
export -f list_logos
export -f welcome_message
