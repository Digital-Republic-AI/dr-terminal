#!/usr/bin/env bash
# =============================================================================
# Gruvbox Color Scheme (Dark Variant)
# =============================================================================
# Official Gruvbox Theme: https://github.com/morhetz/gruvbox
# Retro groove color scheme with warm earthy tones
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_GRUVBOX_THEME_LOADED:-}" ]] && return 0
readonly _GRUVBOX_THEME_LOADED=1

# =============================================================================
# Theme Metadata
# =============================================================================

readonly GRUVBOX_THEME_NAME="Gruvbox Dark"
readonly GRUVBOX_THEME_VERSION="1.0.0"
readonly GRUVBOX_THEME_AUTHOR="Pavel Pertsev (morhetz)"
readonly GRUVBOX_THEME_URL="https://github.com/morhetz/gruvbox"

# =============================================================================
# Gruvbox Dark Color Palette (Hex Values)
# =============================================================================

# Background Colors
readonly GRUVBOX_HEX_BG="#282828"
readonly GRUVBOX_HEX_BG0_H="#1d2021"
readonly GRUVBOX_HEX_BG0="#282828"
readonly GRUVBOX_HEX_BG0_S="#32302f"
readonly GRUVBOX_HEX_BG1="#3c3836"
readonly GRUVBOX_HEX_BG2="#504945"
readonly GRUVBOX_HEX_BG3="#665c54"
readonly GRUVBOX_HEX_BG4="#7c6f64"

# Foreground Colors
readonly GRUVBOX_HEX_FG="#ebdbb2"
readonly GRUVBOX_HEX_FG0="#fbf1c7"
readonly GRUVBOX_HEX_FG1="#ebdbb2"
readonly GRUVBOX_HEX_FG2="#d5c4a1"
readonly GRUVBOX_HEX_FG3="#bdae93"
readonly GRUVBOX_HEX_FG4="#a89984"

# Accent Colors (Bright)
readonly GRUVBOX_HEX_RED="#fb4934"
readonly GRUVBOX_HEX_GREEN="#b8bb26"
readonly GRUVBOX_HEX_YELLOW="#fabd2f"
readonly GRUVBOX_HEX_BLUE="#83a598"
readonly GRUVBOX_HEX_PURPLE="#d3869b"
readonly GRUVBOX_HEX_AQUA="#8ec07c"
readonly GRUVBOX_HEX_ORANGE="#fe8019"
readonly GRUVBOX_HEX_GRAY="#928374"

# Accent Colors (Neutral - for normal use)
readonly GRUVBOX_HEX_NEUTRAL_RED="#cc241d"
readonly GRUVBOX_HEX_NEUTRAL_GREEN="#98971a"
readonly GRUVBOX_HEX_NEUTRAL_YELLOW="#d79921"
readonly GRUVBOX_HEX_NEUTRAL_BLUE="#458588"
readonly GRUVBOX_HEX_NEUTRAL_PURPLE="#b16286"
readonly GRUVBOX_HEX_NEUTRAL_AQUA="#689d6a"
readonly GRUVBOX_HEX_NEUTRAL_ORANGE="#d65d0e"

# =============================================================================
# Gruvbox RGB Values
# =============================================================================

readonly GRUVBOX_RGB_BG="40,40,40"
readonly GRUVBOX_RGB_BG0_H="29,32,33"
readonly GRUVBOX_RGB_BG1="60,56,54"
readonly GRUVBOX_RGB_BG2="80,73,69"
readonly GRUVBOX_RGB_BG3="102,92,84"
readonly GRUVBOX_RGB_BG4="124,111,100"
readonly GRUVBOX_RGB_FG="235,219,178"
readonly GRUVBOX_RGB_FG0="251,241,199"
readonly GRUVBOX_RGB_FG2="213,196,161"
readonly GRUVBOX_RGB_FG3="189,174,147"
readonly GRUVBOX_RGB_FG4="168,153,132"
readonly GRUVBOX_RGB_RED="251,73,52"
readonly GRUVBOX_RGB_GREEN="184,187,38"
readonly GRUVBOX_RGB_YELLOW="250,189,47"
readonly GRUVBOX_RGB_BLUE="131,165,152"
readonly GRUVBOX_RGB_PURPLE="211,134,155"
readonly GRUVBOX_RGB_AQUA="142,192,124"
readonly GRUVBOX_RGB_ORANGE="254,128,25"
readonly GRUVBOX_RGB_GRAY="146,131,116"

# =============================================================================
# ANSI Escape Sequences (True Color)
# =============================================================================

# Reset
readonly GRUVBOX_RESET='\033[0m'

# Background Colors
readonly GRUVBOX_FG_BG='\033[38;2;40;40;40m'
readonly GRUVBOX_FG_BG0_H='\033[38;2;29;32;33m'
readonly GRUVBOX_FG_BG1='\033[38;2;60;56;54m'
readonly GRUVBOX_FG_BG2='\033[38;2;80;73;69m'
readonly GRUVBOX_FG_BG3='\033[38;2;102;92;84m'
readonly GRUVBOX_FG_BG4='\033[38;2;124;111;100m'

# Foreground Colors
readonly GRUVBOX_FG_FG='\033[38;2;235;219;178m'
readonly GRUVBOX_FG_FG0='\033[38;2;251;241;199m'
readonly GRUVBOX_FG_FG1='\033[38;2;235;219;178m'
readonly GRUVBOX_FG_FG2='\033[38;2;213;196;161m'
readonly GRUVBOX_FG_FG3='\033[38;2;189;174;147m'
readonly GRUVBOX_FG_FG4='\033[38;2;168;153;132m'

# Bright Accent Foreground Colors
readonly GRUVBOX_FG_RED='\033[38;2;251;73;52m'
readonly GRUVBOX_FG_GREEN='\033[38;2;184;187;38m'
readonly GRUVBOX_FG_YELLOW='\033[38;2;250;189;47m'
readonly GRUVBOX_FG_BLUE='\033[38;2;131;165;152m'
readonly GRUVBOX_FG_PURPLE='\033[38;2;211;134;155m'
readonly GRUVBOX_FG_AQUA='\033[38;2;142;192;124m'
readonly GRUVBOX_FG_ORANGE='\033[38;2;254;128;25m'
readonly GRUVBOX_FG_GRAY='\033[38;2;146;131;116m'

# Neutral Accent Foreground Colors
readonly GRUVBOX_FG_NEUTRAL_RED='\033[38;2;204;36;29m'
readonly GRUVBOX_FG_NEUTRAL_GREEN='\033[38;2;152;151;26m'
readonly GRUVBOX_FG_NEUTRAL_YELLOW='\033[38;2;215;153;33m'
readonly GRUVBOX_FG_NEUTRAL_BLUE='\033[38;2;69;133;136m'
readonly GRUVBOX_FG_NEUTRAL_PURPLE='\033[38;2;177;98;134m'
readonly GRUVBOX_FG_NEUTRAL_AQUA='\033[38;2;104;157;106m'
readonly GRUVBOX_FG_NEUTRAL_ORANGE='\033[38;2;214;93;14m'

# Background Colors (as backgrounds)
readonly GRUVBOX_BG_BG='\033[48;2;40;40;40m'
readonly GRUVBOX_BG_BG0_H='\033[48;2;29;32;33m'
readonly GRUVBOX_BG_BG1='\033[48;2;60;56;54m'
readonly GRUVBOX_BG_BG2='\033[48;2;80;73;69m'
readonly GRUVBOX_BG_BG3='\033[48;2;102;92;84m'
readonly GRUVBOX_BG_BG4='\033[48;2;124;111;100m'
readonly GRUVBOX_BG_RED='\033[48;2;251;73;52m'
readonly GRUVBOX_BG_GREEN='\033[48;2;184;187;38m'
readonly GRUVBOX_BG_YELLOW='\033[48;2;250;189;47m'
readonly GRUVBOX_BG_BLUE='\033[48;2;131;165;152m'
readonly GRUVBOX_BG_PURPLE='\033[48;2;211;134;155m'
readonly GRUVBOX_BG_AQUA='\033[48;2;142;192;124m'
readonly GRUVBOX_BG_ORANGE='\033[48;2;254;128;25m'

# Bold Foreground Colors
readonly GRUVBOX_BOLD_FG='\033[1;38;2;235;219;178m'
readonly GRUVBOX_BOLD_FG0='\033[1;38;2;251;241;199m'
readonly GRUVBOX_BOLD_RED='\033[1;38;2;251;73;52m'
readonly GRUVBOX_BOLD_GREEN='\033[1;38;2;184;187;38m'
readonly GRUVBOX_BOLD_YELLOW='\033[1;38;2;250;189;47m'
readonly GRUVBOX_BOLD_BLUE='\033[1;38;2;131;165;152m'
readonly GRUVBOX_BOLD_PURPLE='\033[1;38;2;211;134;155m'
readonly GRUVBOX_BOLD_AQUA='\033[1;38;2;142;192;124m'
readonly GRUVBOX_BOLD_ORANGE='\033[1;38;2;254;128;25m'

# =============================================================================
# Semantic Color Aliases
# =============================================================================

# Status Colors
readonly GRUVBOX_SUCCESS="${GRUVBOX_FG_GREEN}"
readonly GRUVBOX_ERROR="${GRUVBOX_FG_RED}"
readonly GRUVBOX_WARNING="${GRUVBOX_FG_YELLOW}"
readonly GRUVBOX_INFO="${GRUVBOX_FG_BLUE}"
readonly GRUVBOX_MUTED="${GRUVBOX_FG_GRAY}"
readonly GRUVBOX_ACCENT="${GRUVBOX_FG_ORANGE}"
readonly GRUVBOX_HIGHLIGHT="${GRUVBOX_FG_AQUA}"

# =============================================================================
# Theme Application Functions
# =============================================================================

# Apply Gruvbox theme colors to current session
gruvbox_apply() {
    export TERM_THEME="gruvbox-dark"

    # Set terminal colors using OSC escape sequences
    # Background
    printf '\033]11;rgb:28/28/28\007'
    # Foreground
    printf '\033]10;rgb:eb/db/b2\007'
    # Cursor
    printf '\033]12;rgb:eb/db/b2\007'

    echo -e "${GRUVBOX_FG_GREEN}Gruvbox Dark theme applied to current session${GRUVBOX_RESET}"
}

# Display theme information
gruvbox_info() {
    echo -e "${GRUVBOX_BOLD_ORANGE}"
    echo "   ____                 _               "
    echo "  / ___|_ __ _   ___   _| |__   _____  __"
    echo " | |  _| '__| | | \\ \\ / / '_ \\ / _ \\ \\/ /"
    echo " | |_| | |  | |_| |\\ V /| |_) | (_) >  < "
    echo "  \\____|_|   \\__,_| \\_/ |_.__/ \\___/_/\\_\\"
    echo -e "${GRUVBOX_RESET}"
    echo ""
    echo -e "${GRUVBOX_FG_FG}Theme:${GRUVBOX_RESET}   ${GRUVBOX_THEME_NAME}"
    echo -e "${GRUVBOX_FG_FG}Version:${GRUVBOX_RESET} ${GRUVBOX_THEME_VERSION}"
    echo -e "${GRUVBOX_FG_FG}Author:${GRUVBOX_RESET}  ${GRUVBOX_THEME_AUTHOR}"
    echo -e "${GRUVBOX_FG_FG}URL:${GRUVBOX_RESET}     ${GRUVBOX_FG_BLUE}${GRUVBOX_THEME_URL}${GRUVBOX_RESET}"
}

# Display color palette
gruvbox_palette() {
    echo ""
    echo -e "${GRUVBOX_BOLD_FG}Gruvbox Dark Color Palette${GRUVBOX_RESET}"
    echo ""
    echo -e "${GRUVBOX_BOLD_YELLOW}Background Colors:${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_BG_BG0_H}  ${GRUVBOX_RESET} bg0_h       ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_BG0_H}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_BG_BG}  ${GRUVBOX_RESET} bg0         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_BG0}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_BG_BG1}  ${GRUVBOX_RESET} bg1         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_BG1}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_BG_BG2}  ${GRUVBOX_RESET} bg2         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_BG2}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_BG_BG3}  ${GRUVBOX_RESET} bg3         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_BG3}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_BG_BG4}  ${GRUVBOX_RESET} bg4         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_BG4}${GRUVBOX_RESET}"
    echo ""
    echo -e "${GRUVBOX_BOLD_YELLOW}Foreground Colors:${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_FG0}██${GRUVBOX_RESET} fg0         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_FG0}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_FG}██${GRUVBOX_RESET} fg1         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_FG1}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_FG2}██${GRUVBOX_RESET} fg2         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_FG2}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_FG3}██${GRUVBOX_RESET} fg3         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_FG3}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_FG4}██${GRUVBOX_RESET} fg4         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_FG4}${GRUVBOX_RESET}"
    echo ""
    echo -e "${GRUVBOX_BOLD_YELLOW}Bright Accent Colors:${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_RED}██${GRUVBOX_RESET} Red         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_RED}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_GREEN}██${GRUVBOX_RESET} Green       ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_GREEN}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_YELLOW}██${GRUVBOX_RESET} Yellow      ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_YELLOW}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_BLUE}██${GRUVBOX_RESET} Blue        ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_BLUE}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_PURPLE}██${GRUVBOX_RESET} Purple      ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_PURPLE}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_AQUA}██${GRUVBOX_RESET} Aqua        ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_AQUA}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_ORANGE}██${GRUVBOX_RESET} Orange      ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_ORANGE}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_GRAY}██${GRUVBOX_RESET} Gray        ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_GRAY}${GRUVBOX_RESET}"
    echo ""
    echo -e "${GRUVBOX_BOLD_YELLOW}Neutral Accent Colors:${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_NEUTRAL_RED}██${GRUVBOX_RESET} Red         ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_NEUTRAL_RED}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_NEUTRAL_GREEN}██${GRUVBOX_RESET} Green       ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_NEUTRAL_GREEN}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_NEUTRAL_YELLOW}██${GRUVBOX_RESET} Yellow      ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_NEUTRAL_YELLOW}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_NEUTRAL_BLUE}██${GRUVBOX_RESET} Blue        ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_NEUTRAL_BLUE}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_NEUTRAL_PURPLE}██${GRUVBOX_RESET} Purple      ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_NEUTRAL_PURPLE}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_NEUTRAL_AQUA}██${GRUVBOX_RESET} Aqua        ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_NEUTRAL_AQUA}${GRUVBOX_RESET}"
    echo -e "  ${GRUVBOX_FG_NEUTRAL_ORANGE}██${GRUVBOX_RESET} Orange      ${GRUVBOX_FG_GRAY}${GRUVBOX_HEX_NEUTRAL_ORANGE}${GRUVBOX_RESET}"
    echo ""
}

# Generate iTerm2 color scheme XML
gruvbox_iterm2_export() {
    local output_file="${1:-Gruvbox-Dark.itermcolors}"

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
        <real>0.15686274509803921</real>
        <key>Green Component</key>
        <real>0.15686274509803921</real>
        <key>Red Component</key>
        <real>0.15686274509803921</real>
    </dict>
    <key>Ansi 1 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.11372549019607843</real>
        <key>Green Component</key>
        <real>0.14117647058823529</real>
        <key>Red Component</key>
        <real>0.8</real>
    </dict>
    <key>Ansi 2 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.10196078431372549</real>
        <key>Green Component</key>
        <real>0.59215686274509804</real>
        <key>Red Component</key>
        <real>0.59607843137254901</real>
    </dict>
    <key>Ansi 3 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.12941176470588237</real>
        <key>Green Component</key>
        <real>0.6</real>
        <key>Red Component</key>
        <real>0.84313725490196079</real>
    </dict>
    <key>Ansi 4 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.53333333333333333</real>
        <key>Green Component</key>
        <real>0.52156862745098043</real>
        <key>Red Component</key>
        <real>0.27058823529411763</real>
    </dict>
    <key>Ansi 5 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.52549019607843139</real>
        <key>Green Component</key>
        <real>0.3843137254901961</real>
        <key>Red Component</key>
        <real>0.69411764705882351</real>
    </dict>
    <key>Ansi 6 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.41568627450980394</real>
        <key>Green Component</key>
        <real>0.61568627450980395</real>
        <key>Red Component</key>
        <real>0.40784313725490196</real>
    </dict>
    <key>Ansi 7 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.69803921568627447</real>
        <key>Green Component</key>
        <real>0.85882352941176465</real>
        <key>Red Component</key>
        <real>0.92156862745098034</real>
    </dict>
    <key>Background Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.15686274509803921</real>
        <key>Green Component</key>
        <real>0.15686274509803921</real>
        <key>Red Component</key>
        <real>0.15686274509803921</real>
    </dict>
    <key>Foreground Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.69803921568627447</real>
        <key>Green Component</key>
        <real>0.85882352941176465</real>
        <key>Red Component</key>
        <real>0.92156862745098034</real>
    </dict>
    <key>Cursor Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.69803921568627447</real>
        <key>Green Component</key>
        <real>0.85882352941176465</real>
        <key>Red Component</key>
        <real>0.92156862745098034</real>
    </dict>
    <key>Selection Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.21176470588235294</real>
        <key>Green Component</key>
        <real>0.2196078431372549</real>
        <key>Red Component</key>
        <real>0.23529411764705882</real>
    </dict>
</dict>
</plist>
ITERM_EOF

    echo -e "${GRUVBOX_FG_GREEN}Exported iTerm2 color scheme to: ${output_file}${GRUVBOX_RESET}"
}

# Demo the color scheme
gruvbox_demo() {
    echo ""
    gruvbox_info
    echo ""
    gruvbox_palette
    echo ""
    echo -e "${GRUVBOX_BOLD_FG}Sample Output:${GRUVBOX_RESET}"
    echo ""
    echo -e "  ${GRUVBOX_SUCCESS}[SUCCESS]${GRUVBOX_RESET} Operation completed successfully"
    echo -e "  ${GRUVBOX_ERROR}[ERROR]${GRUVBOX_RESET}   Something went wrong"
    echo -e "  ${GRUVBOX_WARNING}[WARNING]${GRUVBOX_RESET} Please check your configuration"
    echo -e "  ${GRUVBOX_INFO}[INFO]${GRUVBOX_RESET}    Processing your request..."
    echo -e "  ${GRUVBOX_MUTED}[DEBUG]${GRUVBOX_RESET}   Internal debug information"
    echo ""
    echo -e "${GRUVBOX_FG_ORANGE}const${GRUVBOX_RESET} ${GRUVBOX_FG_FG}greeting${GRUVBOX_RESET} ${GRUVBOX_FG_AQUA}=${GRUVBOX_RESET} ${GRUVBOX_FG_GREEN}\"Hello, Gruvbox!\"${GRUVBOX_RESET}${GRUVBOX_FG_FG};${GRUVBOX_RESET}"
    echo -e "${GRUVBOX_FG_ORANGE}function${GRUVBOX_RESET} ${GRUVBOX_FG_YELLOW}welcome${GRUVBOX_RESET}${GRUVBOX_FG_FG}() {${GRUVBOX_RESET}"
    echo -e "    ${GRUVBOX_FG_BLUE}console${GRUVBOX_RESET}${GRUVBOX_FG_FG}.${GRUVBOX_RESET}${GRUVBOX_FG_YELLOW}log${GRUVBOX_RESET}${GRUVBOX_FG_FG}(greeting);${GRUVBOX_RESET}"
    echo -e "${GRUVBOX_FG_FG}}${GRUVBOX_RESET}"
    echo ""
}

# =============================================================================
# Export Functions
# =============================================================================

export -f gruvbox_apply
export -f gruvbox_info
export -f gruvbox_palette
export -f gruvbox_iterm2_export
export -f gruvbox_demo
