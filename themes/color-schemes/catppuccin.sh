#!/usr/bin/env bash
# =============================================================================
# Catppuccin Color Scheme (Mocha Variant)
# =============================================================================
# Official Catppuccin Theme: https://catppuccin.com/
# Soothing pastel theme for the high-spirited
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_CATPPUCCIN_THEME_LOADED:-}" ]] && return 0
readonly _CATPPUCCIN_THEME_LOADED=1

# =============================================================================
# Theme Metadata
# =============================================================================

readonly CATPPUCCIN_THEME_NAME="Catppuccin Mocha"
readonly CATPPUCCIN_THEME_VERSION="1.0.0"
readonly CATPPUCCIN_THEME_AUTHOR="Catppuccin Org"
readonly CATPPUCCIN_THEME_URL="https://catppuccin.com/"

# =============================================================================
# Catppuccin Mocha Color Palette (Hex Values)
# =============================================================================

# Base Colors
readonly CATPPUCCIN_HEX_ROSEWATER="#f5e0dc"
readonly CATPPUCCIN_HEX_FLAMINGO="#f2cdcd"
readonly CATPPUCCIN_HEX_PINK="#f5c2e7"
readonly CATPPUCCIN_HEX_MAUVE="#cba6f7"
readonly CATPPUCCIN_HEX_RED="#f38ba8"
readonly CATPPUCCIN_HEX_MAROON="#eba0ac"
readonly CATPPUCCIN_HEX_PEACH="#fab387"
readonly CATPPUCCIN_HEX_YELLOW="#f9e2af"
readonly CATPPUCCIN_HEX_GREEN="#a6e3a1"
readonly CATPPUCCIN_HEX_TEAL="#94e2d5"
readonly CATPPUCCIN_HEX_SKY="#89dceb"
readonly CATPPUCCIN_HEX_SAPPHIRE="#74c7ec"
readonly CATPPUCCIN_HEX_BLUE="#89b4fa"
readonly CATPPUCCIN_HEX_LAVENDER="#b4befe"

# Surface Colors
readonly CATPPUCCIN_HEX_TEXT="#cdd6f4"
readonly CATPPUCCIN_HEX_SUBTEXT1="#bac2de"
readonly CATPPUCCIN_HEX_SUBTEXT0="#a6adc8"
readonly CATPPUCCIN_HEX_OVERLAY2="#9399b2"
readonly CATPPUCCIN_HEX_OVERLAY1="#7f849c"
readonly CATPPUCCIN_HEX_OVERLAY0="#6c7086"
readonly CATPPUCCIN_HEX_SURFACE2="#585b70"
readonly CATPPUCCIN_HEX_SURFACE1="#45475a"
readonly CATPPUCCIN_HEX_SURFACE0="#313244"
readonly CATPPUCCIN_HEX_BASE="#1e1e2e"
readonly CATPPUCCIN_HEX_MANTLE="#181825"
readonly CATPPUCCIN_HEX_CRUST="#11111b"

# =============================================================================
# Catppuccin RGB Values
# =============================================================================

readonly CATPPUCCIN_RGB_ROSEWATER="245,224,220"
readonly CATPPUCCIN_RGB_FLAMINGO="242,205,205"
readonly CATPPUCCIN_RGB_PINK="245,194,231"
readonly CATPPUCCIN_RGB_MAUVE="203,166,247"
readonly CATPPUCCIN_RGB_RED="243,139,168"
readonly CATPPUCCIN_RGB_MAROON="235,160,172"
readonly CATPPUCCIN_RGB_PEACH="250,179,135"
readonly CATPPUCCIN_RGB_YELLOW="249,226,175"
readonly CATPPUCCIN_RGB_GREEN="166,227,161"
readonly CATPPUCCIN_RGB_TEAL="148,226,213"
readonly CATPPUCCIN_RGB_SKY="137,220,235"
readonly CATPPUCCIN_RGB_SAPPHIRE="116,199,236"
readonly CATPPUCCIN_RGB_BLUE="137,180,250"
readonly CATPPUCCIN_RGB_LAVENDER="180,190,254"
readonly CATPPUCCIN_RGB_TEXT="205,214,244"
readonly CATPPUCCIN_RGB_SUBTEXT1="186,194,222"
readonly CATPPUCCIN_RGB_SUBTEXT0="166,173,200"
readonly CATPPUCCIN_RGB_OVERLAY2="147,153,178"
readonly CATPPUCCIN_RGB_OVERLAY1="127,132,156"
readonly CATPPUCCIN_RGB_OVERLAY0="108,112,134"
readonly CATPPUCCIN_RGB_SURFACE2="88,91,112"
readonly CATPPUCCIN_RGB_SURFACE1="69,71,90"
readonly CATPPUCCIN_RGB_SURFACE0="49,50,68"
readonly CATPPUCCIN_RGB_BASE="30,30,46"
readonly CATPPUCCIN_RGB_MANTLE="24,24,37"
readonly CATPPUCCIN_RGB_CRUST="17,17,27"

# =============================================================================
# ANSI Escape Sequences (True Color)
# =============================================================================

# Reset
readonly CATPPUCCIN_RESET='\033[0m'

# Foreground Colors
readonly CATPPUCCIN_FG_ROSEWATER='\033[38;2;245;224;220m'
readonly CATPPUCCIN_FG_FLAMINGO='\033[38;2;242;205;205m'
readonly CATPPUCCIN_FG_PINK='\033[38;2;245;194;231m'
readonly CATPPUCCIN_FG_MAUVE='\033[38;2;203;166;247m'
readonly CATPPUCCIN_FG_RED='\033[38;2;243;139;168m'
readonly CATPPUCCIN_FG_MAROON='\033[38;2;235;160;172m'
readonly CATPPUCCIN_FG_PEACH='\033[38;2;250;179;135m'
readonly CATPPUCCIN_FG_YELLOW='\033[38;2;249;226;175m'
readonly CATPPUCCIN_FG_GREEN='\033[38;2;166;227;161m'
readonly CATPPUCCIN_FG_TEAL='\033[38;2;148;226;213m'
readonly CATPPUCCIN_FG_SKY='\033[38;2;137;220;235m'
readonly CATPPUCCIN_FG_SAPPHIRE='\033[38;2;116;199;236m'
readonly CATPPUCCIN_FG_BLUE='\033[38;2;137;180;250m'
readonly CATPPUCCIN_FG_LAVENDER='\033[38;2;180;190;254m'
readonly CATPPUCCIN_FG_TEXT='\033[38;2;205;214;244m'
readonly CATPPUCCIN_FG_SUBTEXT1='\033[38;2;186;194;222m'
readonly CATPPUCCIN_FG_SUBTEXT0='\033[38;2;166;173;200m'
readonly CATPPUCCIN_FG_OVERLAY2='\033[38;2;147;153;178m'
readonly CATPPUCCIN_FG_OVERLAY1='\033[38;2;127;132;156m'
readonly CATPPUCCIN_FG_OVERLAY0='\033[38;2;108;112;134m'
readonly CATPPUCCIN_FG_SURFACE2='\033[38;2;88;91;112m'
readonly CATPPUCCIN_FG_SURFACE1='\033[38;2;69;71;90m'
readonly CATPPUCCIN_FG_SURFACE0='\033[38;2;49;50;68m'
readonly CATPPUCCIN_FG_BASE='\033[38;2;30;30;46m'
readonly CATPPUCCIN_FG_MANTLE='\033[38;2;24;24;37m'
readonly CATPPUCCIN_FG_CRUST='\033[38;2;17;17;27m'

# Background Colors
readonly CATPPUCCIN_BG_ROSEWATER='\033[48;2;245;224;220m'
readonly CATPPUCCIN_BG_FLAMINGO='\033[48;2;242;205;205m'
readonly CATPPUCCIN_BG_PINK='\033[48;2;245;194;231m'
readonly CATPPUCCIN_BG_MAUVE='\033[48;2;203;166;247m'
readonly CATPPUCCIN_BG_RED='\033[48;2;243;139;168m'
readonly CATPPUCCIN_BG_MAROON='\033[48;2;235;160;172m'
readonly CATPPUCCIN_BG_PEACH='\033[48;2;250;179;135m'
readonly CATPPUCCIN_BG_YELLOW='\033[48;2;249;226;175m'
readonly CATPPUCCIN_BG_GREEN='\033[48;2;166;227;161m'
readonly CATPPUCCIN_BG_TEAL='\033[48;2;148;226;213m'
readonly CATPPUCCIN_BG_SKY='\033[48;2;137;220;235m'
readonly CATPPUCCIN_BG_SAPPHIRE='\033[48;2;116;199;236m'
readonly CATPPUCCIN_BG_BLUE='\033[48;2;137;180;250m'
readonly CATPPUCCIN_BG_LAVENDER='\033[48;2;180;190;254m'
readonly CATPPUCCIN_BG_TEXT='\033[48;2;205;214;244m'
readonly CATPPUCCIN_BG_SURFACE2='\033[48;2;88;91;112m'
readonly CATPPUCCIN_BG_SURFACE1='\033[48;2;69;71;90m'
readonly CATPPUCCIN_BG_SURFACE0='\033[48;2;49;50;68m'
readonly CATPPUCCIN_BG_BASE='\033[48;2;30;30;46m'
readonly CATPPUCCIN_BG_MANTLE='\033[48;2;24;24;37m'
readonly CATPPUCCIN_BG_CRUST='\033[48;2;17;17;27m'

# Bold Foreground Colors
readonly CATPPUCCIN_BOLD_ROSEWATER='\033[1;38;2;245;224;220m'
readonly CATPPUCCIN_BOLD_FLAMINGO='\033[1;38;2;242;205;205m'
readonly CATPPUCCIN_BOLD_PINK='\033[1;38;2;245;194;231m'
readonly CATPPUCCIN_BOLD_MAUVE='\033[1;38;2;203;166;247m'
readonly CATPPUCCIN_BOLD_RED='\033[1;38;2;243;139;168m'
readonly CATPPUCCIN_BOLD_PEACH='\033[1;38;2;250;179;135m'
readonly CATPPUCCIN_BOLD_YELLOW='\033[1;38;2;249;226;175m'
readonly CATPPUCCIN_BOLD_GREEN='\033[1;38;2;166;227;161m'
readonly CATPPUCCIN_BOLD_TEAL='\033[1;38;2;148;226;213m'
readonly CATPPUCCIN_BOLD_SKY='\033[1;38;2;137;220;235m'
readonly CATPPUCCIN_BOLD_SAPPHIRE='\033[1;38;2;116;199;236m'
readonly CATPPUCCIN_BOLD_BLUE='\033[1;38;2;137;180;250m'
readonly CATPPUCCIN_BOLD_LAVENDER='\033[1;38;2;180;190;254m'
readonly CATPPUCCIN_BOLD_TEXT='\033[1;38;2;205;214;244m'

# =============================================================================
# Semantic Color Aliases
# =============================================================================

# Status Colors
readonly CATPPUCCIN_SUCCESS="${CATPPUCCIN_FG_GREEN}"
readonly CATPPUCCIN_ERROR="${CATPPUCCIN_FG_RED}"
readonly CATPPUCCIN_WARNING="${CATPPUCCIN_FG_YELLOW}"
readonly CATPPUCCIN_INFO="${CATPPUCCIN_FG_BLUE}"
readonly CATPPUCCIN_MUTED="${CATPPUCCIN_FG_OVERLAY1}"
readonly CATPPUCCIN_ACCENT="${CATPPUCCIN_FG_MAUVE}"
readonly CATPPUCCIN_HIGHLIGHT="${CATPPUCCIN_FG_PINK}"

# =============================================================================
# Theme Application Functions
# =============================================================================

# Apply Catppuccin theme colors to current session
catppuccin_apply() {
    export TERM_THEME="catppuccin-mocha"

    # Set terminal colors using OSC escape sequences
    # Background
    printf '\033]11;rgb:1e/1e/2e\007'
    # Foreground
    printf '\033]10;rgb:cd/d6/f4\007'
    # Cursor
    printf '\033]12;rgb:f5/e0/dc\007'

    echo -e "${CATPPUCCIN_FG_GREEN}Catppuccin Mocha theme applied to current session${CATPPUCCIN_RESET}"
}

# Display theme information
catppuccin_info() {
    echo -e "${CATPPUCCIN_BOLD_MAUVE}"
    echo "   ____      _                              _       "
    echo "  / ___|__ _| |_ _ __  _ __  _   _  ___ ___(_)_ __  "
    echo " | |   / _\` | __| '_ \\| '_ \\| | | |/ __/ __| | '_ \\ "
    echo " | |__| (_| | |_| |_) | |_) | |_| | (_| (__| | | | |"
    echo "  \\____\\__,_|\\__| .__/| .__/ \\__,_|\\___\\___|_|_| |_|"
    echo "                |_|   |_|                           "
    echo -e "${CATPPUCCIN_RESET}"
    echo ""
    echo -e "${CATPPUCCIN_FG_TEXT}Theme:${CATPPUCCIN_RESET}   ${CATPPUCCIN_THEME_NAME}"
    echo -e "${CATPPUCCIN_FG_TEXT}Version:${CATPPUCCIN_RESET} ${CATPPUCCIN_THEME_VERSION}"
    echo -e "${CATPPUCCIN_FG_TEXT}Author:${CATPPUCCIN_RESET}  ${CATPPUCCIN_THEME_AUTHOR}"
    echo -e "${CATPPUCCIN_FG_TEXT}URL:${CATPPUCCIN_RESET}     ${CATPPUCCIN_FG_SAPPHIRE}${CATPPUCCIN_THEME_URL}${CATPPUCCIN_RESET}"
}

# Display color palette
catppuccin_palette() {
    echo ""
    echo -e "${CATPPUCCIN_BOLD_TEXT}Catppuccin Mocha Color Palette${CATPPUCCIN_RESET}"
    echo ""
    echo -e "${CATPPUCCIN_BOLD_LAVENDER}Accent Colors:${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_ROSEWATER}██${CATPPUCCIN_RESET} Rosewater   ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_ROSEWATER}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_FLAMINGO}██${CATPPUCCIN_RESET} Flamingo    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_FLAMINGO}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_PINK}██${CATPPUCCIN_RESET} Pink        ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_PINK}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_MAUVE}██${CATPPUCCIN_RESET} Mauve       ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_MAUVE}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_RED}██${CATPPUCCIN_RESET} Red         ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_RED}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_MAROON}██${CATPPUCCIN_RESET} Maroon      ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_MAROON}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_PEACH}██${CATPPUCCIN_RESET} Peach       ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_PEACH}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_YELLOW}██${CATPPUCCIN_RESET} Yellow      ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_YELLOW}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_GREEN}██${CATPPUCCIN_RESET} Green       ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_GREEN}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_TEAL}██${CATPPUCCIN_RESET} Teal        ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_TEAL}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_SKY}██${CATPPUCCIN_RESET} Sky         ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_SKY}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_SAPPHIRE}██${CATPPUCCIN_RESET} Sapphire    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_SAPPHIRE}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_BLUE}██${CATPPUCCIN_RESET} Blue        ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_BLUE}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_LAVENDER}██${CATPPUCCIN_RESET} Lavender    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_LAVENDER}${CATPPUCCIN_RESET}"
    echo ""
    echo -e "${CATPPUCCIN_BOLD_LAVENDER}Surface Colors:${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_TEXT}██${CATPPUCCIN_RESET} Text        ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_TEXT}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_SUBTEXT1}██${CATPPUCCIN_RESET} Subtext1    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_SUBTEXT1}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_SUBTEXT0}██${CATPPUCCIN_RESET} Subtext0    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_SUBTEXT0}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_OVERLAY2}██${CATPPUCCIN_RESET} Overlay2    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_OVERLAY2}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_OVERLAY1}██${CATPPUCCIN_RESET} Overlay1    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_OVERLAY1}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_FG_OVERLAY0}██${CATPPUCCIN_RESET} Overlay0    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_OVERLAY0}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_BG_SURFACE2}  ${CATPPUCCIN_RESET} Surface2    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_SURFACE2}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_BG_SURFACE1}  ${CATPPUCCIN_RESET} Surface1    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_SURFACE1}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_BG_SURFACE0}  ${CATPPUCCIN_RESET} Surface0    ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_SURFACE0}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_BG_BASE}  ${CATPPUCCIN_RESET} Base        ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_BASE}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_BG_MANTLE}  ${CATPPUCCIN_RESET} Mantle      ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_MANTLE}${CATPPUCCIN_RESET}"
    echo -e "  ${CATPPUCCIN_BG_CRUST}  ${CATPPUCCIN_RESET} Crust       ${CATPPUCCIN_FG_OVERLAY1}${CATPPUCCIN_HEX_CRUST}${CATPPUCCIN_RESET}"
    echo ""
}

# Generate iTerm2 color scheme XML
catppuccin_iterm2_export() {
    local output_file="${1:-Catppuccin-Mocha.itermcolors}"

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
        <real>0.26666666666666666</real>
        <key>Green Component</key>
        <real>0.19607843137254902</real>
        <key>Red Component</key>
        <real>0.19215686274509805</real>
    </dict>
    <key>Ansi 1 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.6588235294117647</real>
        <key>Green Component</key>
        <real>0.5450980392156862</real>
        <key>Red Component</key>
        <real>0.9529411764705882</real>
    </dict>
    <key>Ansi 2 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.6313725490196078</real>
        <key>Green Component</key>
        <real>0.8901960784313725</real>
        <key>Red Component</key>
        <real>0.6509803921568628</real>
    </dict>
    <key>Ansi 3 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.6862745098039216</real>
        <key>Green Component</key>
        <real>0.8862745098039215</real>
        <key>Red Component</key>
        <real>0.9764705882352941</real>
    </dict>
    <key>Ansi 4 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.9803921568627451</real>
        <key>Green Component</key>
        <real>0.7058823529411765</real>
        <key>Red Component</key>
        <real>0.5372549019607843</real>
    </dict>
    <key>Ansi 5 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.9058823529411765</real>
        <key>Green Component</key>
        <real>0.7607843137254902</real>
        <key>Red Component</key>
        <real>0.9607843137254902</real>
    </dict>
    <key>Ansi 6 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.8352941176470589</real>
        <key>Green Component</key>
        <real>0.8862745098039215</real>
        <key>Red Component</key>
        <real>0.5803921568627451</real>
    </dict>
    <key>Ansi 7 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.9568627450980393</real>
        <key>Green Component</key>
        <real>0.8392156862745098</real>
        <key>Red Component</key>
        <real>0.803921568627451</real>
    </dict>
    <key>Background Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.1803921568627451</real>
        <key>Green Component</key>
        <real>0.11764705882352941</real>
        <key>Red Component</key>
        <real>0.11764705882352941</real>
    </dict>
    <key>Foreground Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.9568627450980393</real>
        <key>Green Component</key>
        <real>0.8392156862745098</real>
        <key>Red Component</key>
        <real>0.803921568627451</real>
    </dict>
    <key>Cursor Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.8627450980392157</real>
        <key>Green Component</key>
        <real>0.8784313725490196</real>
        <key>Red Component</key>
        <real>0.9607843137254902</real>
    </dict>
    <key>Selection Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.35294117647058826</real>
        <key>Green Component</key>
        <real>0.2784313725490196</real>
        <key>Red Component</key>
        <real>0.27058823529411763</real>
    </dict>
</dict>
</plist>
ITERM_EOF

    echo -e "${CATPPUCCIN_FG_GREEN}Exported iTerm2 color scheme to: ${output_file}${CATPPUCCIN_RESET}"
}

# Demo the color scheme
catppuccin_demo() {
    echo ""
    catppuccin_info
    echo ""
    catppuccin_palette
    echo ""
    echo -e "${CATPPUCCIN_BOLD_TEXT}Sample Output:${CATPPUCCIN_RESET}"
    echo ""
    echo -e "  ${CATPPUCCIN_SUCCESS}[SUCCESS]${CATPPUCCIN_RESET} Operation completed successfully"
    echo -e "  ${CATPPUCCIN_ERROR}[ERROR]${CATPPUCCIN_RESET}   Something went wrong"
    echo -e "  ${CATPPUCCIN_WARNING}[WARNING]${CATPPUCCIN_RESET} Please check your configuration"
    echo -e "  ${CATPPUCCIN_INFO}[INFO]${CATPPUCCIN_RESET}    Processing your request..."
    echo -e "  ${CATPPUCCIN_MUTED}[DEBUG]${CATPPUCCIN_RESET}   Internal debug information"
    echo ""
    echo -e "${CATPPUCCIN_FG_MAUVE}const${CATPPUCCIN_RESET} ${CATPPUCCIN_FG_TEXT}greeting${CATPPUCCIN_RESET} ${CATPPUCCIN_FG_SKY}=${CATPPUCCIN_RESET} ${CATPPUCCIN_FG_GREEN}\"Hello, Catppuccin!\"${CATPPUCCIN_RESET}${CATPPUCCIN_FG_TEXT};${CATPPUCCIN_RESET}"
    echo -e "${CATPPUCCIN_FG_MAUVE}function${CATPPUCCIN_RESET} ${CATPPUCCIN_FG_BLUE}welcome${CATPPUCCIN_RESET}${CATPPUCCIN_FG_TEXT}() {${CATPPUCCIN_RESET}"
    echo -e "    ${CATPPUCCIN_FG_TEAL}console${CATPPUCCIN_RESET}${CATPPUCCIN_FG_TEXT}.${CATPPUCCIN_RESET}${CATPPUCCIN_FG_BLUE}log${CATPPUCCIN_RESET}${CATPPUCCIN_FG_TEXT}(greeting);${CATPPUCCIN_RESET}"
    echo -e "${CATPPUCCIN_FG_TEXT}}${CATPPUCCIN_RESET}"
    echo ""
}

# =============================================================================
# Export Functions
# =============================================================================

export -f catppuccin_apply
export -f catppuccin_info
export -f catppuccin_palette
export -f catppuccin_iterm2_export
export -f catppuccin_demo
