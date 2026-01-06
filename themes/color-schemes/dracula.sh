#!/usr/bin/env bash
# =============================================================================
# Dracula Color Scheme
# =============================================================================
# Official Dracula Theme: https://draculatheme.com/
# A dark theme for iTerm2 and terminal applications
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_DRACULA_THEME_LOADED:-}" ]] && return 0
readonly _DRACULA_THEME_LOADED=1

# =============================================================================
# Theme Metadata
# =============================================================================

readonly DRACULA_THEME_NAME="Dracula"
readonly DRACULA_THEME_VERSION="1.0.0"
readonly DRACULA_THEME_AUTHOR="Zeno Rocha"
readonly DRACULA_THEME_URL="https://draculatheme.com/"

# =============================================================================
# Dracula Color Palette (Hex Values)
# =============================================================================

# Background Colors
readonly DRACULA_HEX_BACKGROUND="#282a36"
readonly DRACULA_HEX_CURRENT_LINE="#44475a"
readonly DRACULA_HEX_SELECTION="#44475a"

# Foreground Colors
readonly DRACULA_HEX_FOREGROUND="#f8f8f2"
readonly DRACULA_HEX_COMMENT="#6272a4"

# Accent Colors
readonly DRACULA_HEX_CYAN="#8be9fd"
readonly DRACULA_HEX_GREEN="#50fa7b"
readonly DRACULA_HEX_ORANGE="#ffb86c"
readonly DRACULA_HEX_PINK="#ff79c6"
readonly DRACULA_HEX_PURPLE="#bd93f9"
readonly DRACULA_HEX_RED="#ff5555"
readonly DRACULA_HEX_YELLOW="#f1fa8c"

# =============================================================================
# Dracula RGB Values
# =============================================================================

readonly DRACULA_RGB_BACKGROUND="40,42,54"
readonly DRACULA_RGB_CURRENT_LINE="68,71,90"
readonly DRACULA_RGB_SELECTION="68,71,90"
readonly DRACULA_RGB_FOREGROUND="248,248,242"
readonly DRACULA_RGB_COMMENT="98,114,164"
readonly DRACULA_RGB_CYAN="139,233,253"
readonly DRACULA_RGB_GREEN="80,250,123"
readonly DRACULA_RGB_ORANGE="255,184,108"
readonly DRACULA_RGB_PINK="255,121,198"
readonly DRACULA_RGB_PURPLE="189,147,249"
readonly DRACULA_RGB_RED="255,85,85"
readonly DRACULA_RGB_YELLOW="241,250,140"

# =============================================================================
# ANSI Escape Sequences (256 Color Approximations)
# =============================================================================

# Reset
readonly DRACULA_RESET='\033[0m'

# Regular Foreground Colors (Dracula Palette)
readonly DRACULA_FG_BACKGROUND='\033[38;2;40;42;54m'
readonly DRACULA_FG_CURRENT_LINE='\033[38;2;68;71;90m'
readonly DRACULA_FG_FOREGROUND='\033[38;2;248;248;242m'
readonly DRACULA_FG_COMMENT='\033[38;2;98;114;164m'
readonly DRACULA_FG_CYAN='\033[38;2;139;233;253m'
readonly DRACULA_FG_GREEN='\033[38;2;80;250;123m'
readonly DRACULA_FG_ORANGE='\033[38;2;255;184;108m'
readonly DRACULA_FG_PINK='\033[38;2;255;121;198m'
readonly DRACULA_FG_PURPLE='\033[38;2;189;147;249m'
readonly DRACULA_FG_RED='\033[38;2;255;85;85m'
readonly DRACULA_FG_YELLOW='\033[38;2;241;250;140m'

# Background Colors (Dracula Palette)
readonly DRACULA_BG_BACKGROUND='\033[48;2;40;42;54m'
readonly DRACULA_BG_CURRENT_LINE='\033[48;2;68;71;90m'
readonly DRACULA_BG_SELECTION='\033[48;2;68;71;90m'
readonly DRACULA_BG_CYAN='\033[48;2;139;233;253m'
readonly DRACULA_BG_GREEN='\033[48;2;80;250;123m'
readonly DRACULA_BG_ORANGE='\033[48;2;255;184;108m'
readonly DRACULA_BG_PINK='\033[48;2;255;121;198m'
readonly DRACULA_BG_PURPLE='\033[48;2;189;147;249m'
readonly DRACULA_BG_RED='\033[48;2;255;85;85m'
readonly DRACULA_BG_YELLOW='\033[48;2;241;250;140m'

# Bold Foreground Colors
readonly DRACULA_BOLD_CYAN='\033[1;38;2;139;233;253m'
readonly DRACULA_BOLD_GREEN='\033[1;38;2;80;250;123m'
readonly DRACULA_BOLD_ORANGE='\033[1;38;2;255;184;108m'
readonly DRACULA_BOLD_PINK='\033[1;38;2;255;121;198m'
readonly DRACULA_BOLD_PURPLE='\033[1;38;2;189;147;249m'
readonly DRACULA_BOLD_RED='\033[1;38;2;255;85;85m'
readonly DRACULA_BOLD_YELLOW='\033[1;38;2;241;250;140m'
readonly DRACULA_BOLD_FOREGROUND='\033[1;38;2;248;248;242m'

# =============================================================================
# Semantic Color Aliases
# =============================================================================

# Status Colors
readonly DRACULA_SUCCESS="${DRACULA_FG_GREEN}"
readonly DRACULA_ERROR="${DRACULA_FG_RED}"
readonly DRACULA_WARNING="${DRACULA_FG_YELLOW}"
readonly DRACULA_INFO="${DRACULA_FG_CYAN}"
readonly DRACULA_MUTED="${DRACULA_FG_COMMENT}"
readonly DRACULA_ACCENT="${DRACULA_FG_PURPLE}"
readonly DRACULA_HIGHLIGHT="${DRACULA_FG_PINK}"

# =============================================================================
# Theme Application Functions
# =============================================================================

# Apply Dracula theme colors to current session
dracula_apply() {
    export TERM_THEME="dracula"

    # Set terminal colors using OSC escape sequences
    # These work in iTerm2 and other modern terminal emulators

    # Background
    printf '\033]11;rgb:28/2a/36\007'
    # Foreground
    printf '\033]10;rgb:f8/f8/f2\007'
    # Cursor
    printf '\033]12;rgb:f8/f8/f2\007'

    echo -e "${DRACULA_FG_GREEN}Dracula theme applied to current session${DRACULA_RESET}"
}

# Display theme information
dracula_info() {
    echo -e "${DRACULA_BOLD_PURPLE}"
    echo "  ____                       _       "
    echo " |  _ \\ _ __ __ _  ___ _   _| | __ _ "
    echo " | | | | '__/ _\` |/ __| | | | |/ _\` |"
    echo " | |_| | | | (_| | (__| |_| | | (_| |"
    echo " |____/|_|  \\__,_|\\___|\\__,_|_|\\__,_|"
    echo -e "${DRACULA_RESET}"
    echo ""
    echo -e "${DRACULA_FG_FOREGROUND}Theme:${DRACULA_RESET}   ${DRACULA_THEME_NAME}"
    echo -e "${DRACULA_FG_FOREGROUND}Version:${DRACULA_RESET} ${DRACULA_THEME_VERSION}"
    echo -e "${DRACULA_FG_FOREGROUND}Author:${DRACULA_RESET}  ${DRACULA_THEME_AUTHOR}"
    echo -e "${DRACULA_FG_FOREGROUND}URL:${DRACULA_RESET}     ${DRACULA_FG_CYAN}${DRACULA_THEME_URL}${DRACULA_RESET}"
}

# Display color palette
dracula_palette() {
    echo ""
    echo -e "${DRACULA_BOLD_FOREGROUND}Dracula Color Palette${DRACULA_RESET}"
    echo ""
    echo -e "  ${DRACULA_BG_BACKGROUND}  ${DRACULA_RESET} Background    ${DRACULA_FG_COMMENT}${DRACULA_HEX_BACKGROUND}${DRACULA_RESET}"
    echo -e "  ${DRACULA_BG_CURRENT_LINE}  ${DRACULA_RESET} Current Line ${DRACULA_FG_COMMENT}${DRACULA_HEX_CURRENT_LINE}${DRACULA_RESET}"
    echo -e "  ${DRACULA_FG_FOREGROUND}██${DRACULA_RESET} Foreground   ${DRACULA_FG_COMMENT}${DRACULA_HEX_FOREGROUND}${DRACULA_RESET}"
    echo -e "  ${DRACULA_FG_COMMENT}██${DRACULA_RESET} Comment      ${DRACULA_FG_COMMENT}${DRACULA_HEX_COMMENT}${DRACULA_RESET}"
    echo -e "  ${DRACULA_FG_CYAN}██${DRACULA_RESET} Cyan         ${DRACULA_FG_COMMENT}${DRACULA_HEX_CYAN}${DRACULA_RESET}"
    echo -e "  ${DRACULA_FG_GREEN}██${DRACULA_RESET} Green        ${DRACULA_FG_COMMENT}${DRACULA_HEX_GREEN}${DRACULA_RESET}"
    echo -e "  ${DRACULA_FG_ORANGE}██${DRACULA_RESET} Orange       ${DRACULA_FG_COMMENT}${DRACULA_HEX_ORANGE}${DRACULA_RESET}"
    echo -e "  ${DRACULA_FG_PINK}██${DRACULA_RESET} Pink         ${DRACULA_FG_COMMENT}${DRACULA_HEX_PINK}${DRACULA_RESET}"
    echo -e "  ${DRACULA_FG_PURPLE}██${DRACULA_RESET} Purple       ${DRACULA_FG_COMMENT}${DRACULA_HEX_PURPLE}${DRACULA_RESET}"
    echo -e "  ${DRACULA_FG_RED}██${DRACULA_RESET} Red          ${DRACULA_FG_COMMENT}${DRACULA_HEX_RED}${DRACULA_RESET}"
    echo -e "  ${DRACULA_FG_YELLOW}██${DRACULA_RESET} Yellow       ${DRACULA_FG_COMMENT}${DRACULA_HEX_YELLOW}${DRACULA_RESET}"
    echo ""
}

# Generate iTerm2 color scheme XML
dracula_iterm2_export() {
    local output_file="${1:-Dracula.itermcolors}"

    cat > "$output_file" << 'ITERM_EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Ansi 0 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.21176470588235294</real>
        <key>Green Component</key>
        <real>0.16470588235294117</real>
        <key>Red Component</key>
        <real>0.15686274509803921</real>
    </dict>
    <key>Ansi 1 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.33333333333333331</real>
        <key>Green Component</key>
        <real>0.33333333333333331</real>
        <key>Red Component</key>
        <real>1</real>
    </dict>
    <key>Ansi 2 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.4823529411764706</real>
        <key>Green Component</key>
        <real>0.98039215686274506</real>
        <key>Red Component</key>
        <real>0.31372549019607843</real>
    </dict>
    <key>Ansi 3 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.5490196078431373</real>
        <key>Green Component</key>
        <real>0.98039215686274506</real>
        <key>Red Component</key>
        <real>0.94509803921568625</real>
    </dict>
    <key>Ansi 4 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.97647058823529409</real>
        <key>Green Component</key>
        <real>0.57647058823529407</real>
        <key>Red Component</key>
        <real>0.74117647058823533</real>
    </dict>
    <key>Ansi 5 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.77647058823529413</real>
        <key>Green Component</key>
        <real>0.47450980392156861</real>
        <key>Red Component</key>
        <real>1</real>
    </dict>
    <key>Ansi 6 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.99215686274509807</real>
        <key>Green Component</key>
        <real>0.9137254901960784</real>
        <key>Red Component</key>
        <real>0.54509803921568623</real>
    </dict>
    <key>Ansi 7 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.94901960784313721</real>
        <key>Green Component</key>
        <real>0.94901960784313721</real>
        <key>Red Component</key>
        <real>0.97254901960784312</real>
    </dict>
    <key>Background Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.21176470588235294</real>
        <key>Green Component</key>
        <real>0.16470588235294117</real>
        <key>Red Component</key>
        <real>0.15686274509803921</real>
    </dict>
    <key>Foreground Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.94901960784313721</real>
        <key>Green Component</key>
        <real>0.94901960784313721</real>
        <key>Red Component</key>
        <real>0.97254901960784312</real>
    </dict>
    <key>Cursor Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.94901960784313721</real>
        <key>Green Component</key>
        <real>0.94901960784313721</real>
        <key>Red Component</key>
        <real>0.97254901960784312</real>
    </dict>
    <key>Cursor Text Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.21176470588235294</real>
        <key>Green Component</key>
        <real>0.16470588235294117</real>
        <key>Red Component</key>
        <real>0.15686274509803921</real>
    </dict>
    <key>Selection Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.35294117647058826</real>
        <key>Green Component</key>
        <real>0.27843137254901962</real>
        <key>Red Component</key>
        <real>0.26666666666666666</real>
    </dict>
</dict>
</plist>
ITERM_EOF

    echo -e "${DRACULA_FG_GREEN}Exported iTerm2 color scheme to: ${output_file}${DRACULA_RESET}"
}

# Demo the color scheme
dracula_demo() {
    echo ""
    dracula_info
    echo ""
    dracula_palette
    echo ""
    echo -e "${DRACULA_BOLD_FOREGROUND}Sample Output:${DRACULA_RESET}"
    echo ""
    echo -e "  ${DRACULA_SUCCESS}[SUCCESS]${DRACULA_RESET} Operation completed successfully"
    echo -e "  ${DRACULA_ERROR}[ERROR]${DRACULA_RESET}   Something went wrong"
    echo -e "  ${DRACULA_WARNING}[WARNING]${DRACULA_RESET} Please check your configuration"
    echo -e "  ${DRACULA_INFO}[INFO]${DRACULA_RESET}    Processing your request..."
    echo -e "  ${DRACULA_MUTED}[DEBUG]${DRACULA_RESET}   Internal debug information"
    echo ""
    echo -e "${DRACULA_FG_PURPLE}const${DRACULA_RESET} ${DRACULA_FG_FOREGROUND}greeting${DRACULA_RESET} ${DRACULA_FG_PINK}=${DRACULA_RESET} ${DRACULA_FG_YELLOW}\"Hello, Dracula!\"${DRACULA_RESET}${DRACULA_FG_FOREGROUND};${DRACULA_RESET}"
    echo -e "${DRACULA_FG_PINK}function${DRACULA_RESET} ${DRACULA_FG_GREEN}welcome${DRACULA_RESET}${DRACULA_FG_FOREGROUND}() {${DRACULA_RESET}"
    echo -e "    ${DRACULA_FG_CYAN}console${DRACULA_RESET}${DRACULA_FG_FOREGROUND}.${DRACULA_RESET}${DRACULA_FG_GREEN}log${DRACULA_RESET}${DRACULA_FG_FOREGROUND}(greeting);${DRACULA_RESET}"
    echo -e "${DRACULA_FG_FOREGROUND}}${DRACULA_RESET}"
    echo ""
}

# =============================================================================
# Export Functions
# =============================================================================

export -f dracula_apply
export -f dracula_info
export -f dracula_palette
export -f dracula_iterm2_export
export -f dracula_demo
