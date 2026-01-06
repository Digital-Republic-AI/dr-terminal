#!/usr/bin/env bash
# =============================================================================
# Nord Color Scheme
# =============================================================================
# Official Nord Theme: https://www.nordtheme.com/
# An arctic, north-bluish color palette
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_NORD_THEME_LOADED:-}" ]] && return 0
readonly _NORD_THEME_LOADED=1

# =============================================================================
# Theme Metadata
# =============================================================================

readonly NORD_THEME_NAME="Nord"
readonly NORD_THEME_VERSION="1.0.0"
readonly NORD_THEME_AUTHOR="Arctic Ice Studio & Sven Greb"
readonly NORD_THEME_URL="https://www.nordtheme.com/"

# =============================================================================
# Nord Color Palette (Hex Values)
# =============================================================================

# Polar Night - Dark colors for backgrounds
readonly NORD_HEX_NORD0="#2e3440"   # Background
readonly NORD_HEX_NORD1="#3b4252"   # Elevated surface
readonly NORD_HEX_NORD2="#434c5e"   # Selection, highlights
readonly NORD_HEX_NORD3="#4c566a"   # Comments, invisibles

# Snow Storm - Bright colors for foreground
readonly NORD_HEX_NORD4="#d8dee9"   # Main foreground
readonly NORD_HEX_NORD5="#e5e9f0"   # Lighter foreground
readonly NORD_HEX_NORD6="#eceff4"   # Brightest foreground

# Frost - Cool accent colors
readonly NORD_HEX_NORD7="#8fbcbb"   # Teal - frozen polar water
readonly NORD_HEX_NORD8="#88c0d0"   # Light blue - pure ice
readonly NORD_HEX_NORD9="#81a1c1"   # Blue - dark cold water
readonly NORD_HEX_NORD10="#5e81ac"  # Deep blue - ocean

# Aurora - Vibrant accent colors
readonly NORD_HEX_NORD11="#bf616a"  # Red - error/danger
readonly NORD_HEX_NORD12="#d08770"  # Orange - warning
readonly NORD_HEX_NORD13="#ebcb8b"  # Yellow - caution
readonly NORD_HEX_NORD14="#a3be8c"  # Green - success
readonly NORD_HEX_NORD15="#b48ead"  # Purple - special

# =============================================================================
# Nord RGB Values
# =============================================================================

readonly NORD_RGB_NORD0="46,52,64"
readonly NORD_RGB_NORD1="59,66,82"
readonly NORD_RGB_NORD2="67,76,94"
readonly NORD_RGB_NORD3="76,86,106"
readonly NORD_RGB_NORD4="216,222,233"
readonly NORD_RGB_NORD5="229,233,240"
readonly NORD_RGB_NORD6="236,239,244"
readonly NORD_RGB_NORD7="143,188,187"
readonly NORD_RGB_NORD8="136,192,208"
readonly NORD_RGB_NORD9="129,161,193"
readonly NORD_RGB_NORD10="94,129,172"
readonly NORD_RGB_NORD11="191,97,106"
readonly NORD_RGB_NORD12="208,135,112"
readonly NORD_RGB_NORD13="235,203,139"
readonly NORD_RGB_NORD14="163,190,140"
readonly NORD_RGB_NORD15="180,142,173"

# =============================================================================
# ANSI Escape Sequences (True Color)
# =============================================================================

# Reset
readonly NORD_RESET='\033[0m'

# Polar Night (Foreground Colors)
readonly NORD_FG_NORD0='\033[38;2;46;52;64m'
readonly NORD_FG_NORD1='\033[38;2;59;66;82m'
readonly NORD_FG_NORD2='\033[38;2;67;76;94m'
readonly NORD_FG_NORD3='\033[38;2;76;86;106m'

# Snow Storm (Foreground Colors)
readonly NORD_FG_NORD4='\033[38;2;216;222;233m'
readonly NORD_FG_NORD5='\033[38;2;229;233;240m'
readonly NORD_FG_NORD6='\033[38;2;236;239;244m'

# Frost (Foreground Colors)
readonly NORD_FG_NORD7='\033[38;2;143;188;187m'
readonly NORD_FG_NORD8='\033[38;2;136;192;208m'
readonly NORD_FG_NORD9='\033[38;2;129;161;193m'
readonly NORD_FG_NORD10='\033[38;2;94;129;172m'

# Aurora (Foreground Colors)
readonly NORD_FG_NORD11='\033[38;2;191;97;106m'
readonly NORD_FG_NORD12='\033[38;2;208;135;112m'
readonly NORD_FG_NORD13='\033[38;2;235;203;139m'
readonly NORD_FG_NORD14='\033[38;2;163;190;140m'
readonly NORD_FG_NORD15='\033[38;2;180;142;173m'

# Polar Night (Background Colors)
readonly NORD_BG_NORD0='\033[48;2;46;52;64m'
readonly NORD_BG_NORD1='\033[48;2;59;66;82m'
readonly NORD_BG_NORD2='\033[48;2;67;76;94m'
readonly NORD_BG_NORD3='\033[48;2;76;86;106m'

# Snow Storm (Background Colors)
readonly NORD_BG_NORD4='\033[48;2;216;222;233m'
readonly NORD_BG_NORD5='\033[48;2;229;233;240m'
readonly NORD_BG_NORD6='\033[48;2;236;239;244m'

# Frost (Background Colors)
readonly NORD_BG_NORD7='\033[48;2;143;188;187m'
readonly NORD_BG_NORD8='\033[48;2;136;192;208m'
readonly NORD_BG_NORD9='\033[48;2;129;161;193m'
readonly NORD_BG_NORD10='\033[48;2;94;129;172m'

# Aurora (Background Colors)
readonly NORD_BG_NORD11='\033[48;2;191;97;106m'
readonly NORD_BG_NORD12='\033[48;2;208;135;112m'
readonly NORD_BG_NORD13='\033[48;2;235;203;139m'
readonly NORD_BG_NORD14='\033[48;2;163;190;140m'
readonly NORD_BG_NORD15='\033[48;2;180;142;173m'

# Bold Foreground Colors
readonly NORD_BOLD_NORD4='\033[1;38;2;216;222;233m'
readonly NORD_BOLD_NORD5='\033[1;38;2;229;233;240m'
readonly NORD_BOLD_NORD6='\033[1;38;2;236;239;244m'
readonly NORD_BOLD_NORD7='\033[1;38;2;143;188;187m'
readonly NORD_BOLD_NORD8='\033[1;38;2;136;192;208m'
readonly NORD_BOLD_NORD9='\033[1;38;2;129;161;193m'
readonly NORD_BOLD_NORD10='\033[1;38;2;94;129;172m'
readonly NORD_BOLD_NORD11='\033[1;38;2;191;97;106m'
readonly NORD_BOLD_NORD12='\033[1;38;2;208;135;112m'
readonly NORD_BOLD_NORD13='\033[1;38;2;235;203;139m'
readonly NORD_BOLD_NORD14='\033[1;38;2;163;190;140m'
readonly NORD_BOLD_NORD15='\033[1;38;2;180;142;173m'

# =============================================================================
# Semantic Color Aliases
# =============================================================================

# Named Aliases (Semantic Naming)
readonly NORD_FG_BACKGROUND="${NORD_FG_NORD0}"
readonly NORD_FG_ELEVATED="${NORD_FG_NORD1}"
readonly NORD_FG_SELECTION="${NORD_FG_NORD2}"
readonly NORD_FG_COMMENT="${NORD_FG_NORD3}"
readonly NORD_FG_TEXT="${NORD_FG_NORD4}"
readonly NORD_FG_TEXT_LIGHT="${NORD_FG_NORD5}"
readonly NORD_FG_TEXT_BRIGHT="${NORD_FG_NORD6}"
readonly NORD_FG_TEAL="${NORD_FG_NORD7}"
readonly NORD_FG_CYAN="${NORD_FG_NORD8}"
readonly NORD_FG_BLUE="${NORD_FG_NORD9}"
readonly NORD_FG_BLUE_DARK="${NORD_FG_NORD10}"
readonly NORD_FG_RED="${NORD_FG_NORD11}"
readonly NORD_FG_ORANGE="${NORD_FG_NORD12}"
readonly NORD_FG_YELLOW="${NORD_FG_NORD13}"
readonly NORD_FG_GREEN="${NORD_FG_NORD14}"
readonly NORD_FG_PURPLE="${NORD_FG_NORD15}"

# Status Colors
readonly NORD_SUCCESS="${NORD_FG_NORD14}"
readonly NORD_ERROR="${NORD_FG_NORD11}"
readonly NORD_WARNING="${NORD_FG_NORD13}"
readonly NORD_INFO="${NORD_FG_NORD8}"
readonly NORD_MUTED="${NORD_FG_NORD3}"
readonly NORD_ACCENT="${NORD_FG_NORD9}"
readonly NORD_HIGHLIGHT="${NORD_FG_NORD7}"

# =============================================================================
# Theme Application Functions
# =============================================================================

# Apply Nord theme colors to current session
nord_apply() {
    export TERM_THEME="nord"

    # Set terminal colors using OSC escape sequences
    # Background (Nord0)
    printf '\033]11;rgb:2e/34/40\007'
    # Foreground (Nord4)
    printf '\033]10;rgb:d8/de/e9\007'
    # Cursor (Nord4)
    printf '\033]12;rgb:d8/de/e9\007'

    echo -e "${NORD_FG_NORD14}Nord theme applied to current session${NORD_RESET}"
}

# Display theme information
nord_info() {
    echo -e "${NORD_BOLD_NORD8}"
    echo "    _   _               _ "
    echo "   | \\ | |             | |"
    echo "   |  \\| | ___  _ __ __| |"
    echo "   | . \` |/ _ \\| '__/ _\` |"
    echo "   | |\\  | (_) | | | (_| |"
    echo "   |_| \\_|\\___/|_|  \\__,_|"
    echo -e "${NORD_RESET}"
    echo ""
    echo -e "${NORD_FG_NORD4}Theme:${NORD_RESET}   ${NORD_THEME_NAME}"
    echo -e "${NORD_FG_NORD4}Version:${NORD_RESET} ${NORD_THEME_VERSION}"
    echo -e "${NORD_FG_NORD4}Author:${NORD_RESET}  ${NORD_THEME_AUTHOR}"
    echo -e "${NORD_FG_NORD4}URL:${NORD_RESET}     ${NORD_FG_NORD8}${NORD_THEME_URL}${NORD_RESET}"
}

# Display color palette
nord_palette() {
    echo ""
    echo -e "${NORD_BOLD_NORD6}Nord Color Palette${NORD_RESET}"
    echo ""
    echo -e "${NORD_BOLD_NORD8}Polar Night:${NORD_RESET}"
    echo -e "  ${NORD_BG_NORD0}  ${NORD_RESET} nord0       ${NORD_FG_NORD3}${NORD_HEX_NORD0}${NORD_RESET}  Background"
    echo -e "  ${NORD_BG_NORD1}  ${NORD_RESET} nord1       ${NORD_FG_NORD3}${NORD_HEX_NORD1}${NORD_RESET}  Elevated surface"
    echo -e "  ${NORD_BG_NORD2}  ${NORD_RESET} nord2       ${NORD_FG_NORD3}${NORD_HEX_NORD2}${NORD_RESET}  Selection"
    echo -e "  ${NORD_BG_NORD3}  ${NORD_RESET} nord3       ${NORD_FG_NORD3}${NORD_HEX_NORD3}${NORD_RESET}  Comments"
    echo ""
    echo -e "${NORD_BOLD_NORD8}Snow Storm:${NORD_RESET}"
    echo -e "  ${NORD_FG_NORD4}██${NORD_RESET} nord4       ${NORD_FG_NORD3}${NORD_HEX_NORD4}${NORD_RESET}  Main text"
    echo -e "  ${NORD_FG_NORD5}██${NORD_RESET} nord5       ${NORD_FG_NORD3}${NORD_HEX_NORD5}${NORD_RESET}  Light text"
    echo -e "  ${NORD_FG_NORD6}██${NORD_RESET} nord6       ${NORD_FG_NORD3}${NORD_HEX_NORD6}${NORD_RESET}  Bright text"
    echo ""
    echo -e "${NORD_BOLD_NORD8}Frost:${NORD_RESET}"
    echo -e "  ${NORD_FG_NORD7}██${NORD_RESET} nord7       ${NORD_FG_NORD3}${NORD_HEX_NORD7}${NORD_RESET}  Teal (frozen water)"
    echo -e "  ${NORD_FG_NORD8}██${NORD_RESET} nord8       ${NORD_FG_NORD3}${NORD_HEX_NORD8}${NORD_RESET}  Cyan (pure ice)"
    echo -e "  ${NORD_FG_NORD9}██${NORD_RESET} nord9       ${NORD_FG_NORD3}${NORD_HEX_NORD9}${NORD_RESET}  Blue (cold water)"
    echo -e "  ${NORD_FG_NORD10}██${NORD_RESET} nord10      ${NORD_FG_NORD3}${NORD_HEX_NORD10}${NORD_RESET}  Deep blue (ocean)"
    echo ""
    echo -e "${NORD_BOLD_NORD8}Aurora:${NORD_RESET}"
    echo -e "  ${NORD_FG_NORD11}██${NORD_RESET} nord11      ${NORD_FG_NORD3}${NORD_HEX_NORD11}${NORD_RESET}  Red (error)"
    echo -e "  ${NORD_FG_NORD12}██${NORD_RESET} nord12      ${NORD_FG_NORD3}${NORD_HEX_NORD12}${NORD_RESET}  Orange (warning)"
    echo -e "  ${NORD_FG_NORD13}██${NORD_RESET} nord13      ${NORD_FG_NORD3}${NORD_HEX_NORD13}${NORD_RESET}  Yellow (caution)"
    echo -e "  ${NORD_FG_NORD14}██${NORD_RESET} nord14      ${NORD_FG_NORD3}${NORD_HEX_NORD14}${NORD_RESET}  Green (success)"
    echo -e "  ${NORD_FG_NORD15}██${NORD_RESET} nord15      ${NORD_FG_NORD3}${NORD_HEX_NORD15}${NORD_RESET}  Purple (special)"
    echo ""
}

# Generate iTerm2 color scheme XML
nord_iterm2_export() {
    local output_file="${1:-Nord.itermcolors}"

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
        <real>0.32156862745098042</real>
        <key>Green Component</key>
        <real>0.25882352941176473</real>
        <key>Red Component</key>
        <real>0.23137254901960785</real>
    </dict>
    <key>Ansi 1 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.41568627450980394</real>
        <key>Green Component</key>
        <real>0.38039215686274508</real>
        <key>Red Component</key>
        <real>0.74901960784313726</real>
    </dict>
    <key>Ansi 2 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.5490196078431373</real>
        <key>Green Component</key>
        <real>0.74509803921568629</real>
        <key>Red Component</key>
        <real>0.63921568627450975</real>
    </dict>
    <key>Ansi 3 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.54509803921568623</real>
        <key>Green Component</key>
        <real>0.79607843137254897</real>
        <key>Red Component</key>
        <real>0.92156862745098034</real>
    </dict>
    <key>Ansi 4 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.75686274509803919</real>
        <key>Green Component</key>
        <real>0.63137254901960782</real>
        <key>Red Component</key>
        <real>0.50588235294117645</real>
    </dict>
    <key>Ansi 5 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.67843137254901964</real>
        <key>Green Component</key>
        <real>0.55686274509803924</real>
        <key>Red Component</key>
        <real>0.70588235294117652</real>
    </dict>
    <key>Ansi 6 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.81568627450980391</real>
        <key>Green Component</key>
        <real>0.75294117647058822</real>
        <key>Red Component</key>
        <real>0.53333333333333333</real>
    </dict>
    <key>Ansi 7 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.95686274509803926</real>
        <key>Green Component</key>
        <real>0.93725490196078431</real>
        <key>Red Component</key>
        <real>0.92549019607843142</real>
    </dict>
    <key>Ansi 8 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.41568627450980394</real>
        <key>Green Component</key>
        <real>0.33725490196078434</real>
        <key>Red Component</key>
        <real>0.29803921568627451</real>
    </dict>
    <key>Ansi 9 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.41568627450980394</real>
        <key>Green Component</key>
        <real>0.38039215686274508</real>
        <key>Red Component</key>
        <real>0.74901960784313726</real>
    </dict>
    <key>Ansi 10 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.5490196078431373</real>
        <key>Green Component</key>
        <real>0.74509803921568629</real>
        <key>Red Component</key>
        <real>0.63921568627450975</real>
    </dict>
    <key>Ansi 11 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.54509803921568623</real>
        <key>Green Component</key>
        <real>0.79607843137254897</real>
        <key>Red Component</key>
        <real>0.92156862745098034</real>
    </dict>
    <key>Ansi 12 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.75686274509803919</real>
        <key>Green Component</key>
        <real>0.63137254901960782</real>
        <key>Red Component</key>
        <real>0.50588235294117645</real>
    </dict>
    <key>Ansi 13 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.67843137254901964</real>
        <key>Green Component</key>
        <real>0.55686274509803924</real>
        <key>Red Component</key>
        <real>0.70588235294117652</real>
    </dict>
    <key>Ansi 14 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.73333333333333328</real>
        <key>Green Component</key>
        <real>0.73725490196078436</real>
        <key>Red Component</key>
        <real>0.5607843137254902</real>
    </dict>
    <key>Ansi 15 Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.95686274509803926</real>
        <key>Green Component</key>
        <real>0.93725490196078431</real>
        <key>Red Component</key>
        <real>0.92549019607843142</real>
    </dict>
    <key>Background Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.25098039215686274</real>
        <key>Green Component</key>
        <real>0.20392156862745098</real>
        <key>Red Component</key>
        <real>0.18039215686274511</real>
    </dict>
    <key>Foreground Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.9137254901960784</real>
        <key>Green Component</key>
        <real>0.87058823529411766</real>
        <key>Red Component</key>
        <real>0.84705882352941175</real>
    </dict>
    <key>Cursor Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.9137254901960784</real>
        <key>Green Component</key>
        <real>0.87058823529411766</real>
        <key>Red Component</key>
        <real>0.84705882352941175</real>
    </dict>
    <key>Cursor Text Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.25098039215686274</real>
        <key>Green Component</key>
        <real>0.20392156862745098</real>
        <key>Red Component</key>
        <real>0.18039215686274511</real>
    </dict>
    <key>Selection Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.36862745098039218</real>
        <key>Green Component</key>
        <real>0.29803921568627451</real>
        <key>Red Component</key>
        <real>0.2627450980392157</real>
    </dict>
    <key>Selected Text Color</key>
    <dict>
        <key>Color Space</key>
        <string>sRGB</string>
        <key>Blue Component</key>
        <real>0.9137254901960784</real>
        <key>Green Component</key>
        <real>0.87058823529411766</real>
        <key>Red Component</key>
        <real>0.84705882352941175</real>
    </dict>
</dict>
</plist>
ITERM_EOF

    echo -e "${NORD_FG_NORD14}Exported iTerm2 color scheme to: ${output_file}${NORD_RESET}"
}

# Demo the color scheme
nord_demo() {
    echo ""
    nord_info
    echo ""
    nord_palette
    echo ""
    echo -e "${NORD_BOLD_NORD6}Sample Output:${NORD_RESET}"
    echo ""
    echo -e "  ${NORD_SUCCESS}[SUCCESS]${NORD_RESET} Operation completed successfully"
    echo -e "  ${NORD_ERROR}[ERROR]${NORD_RESET}   Something went wrong"
    echo -e "  ${NORD_WARNING}[WARNING]${NORD_RESET} Please check your configuration"
    echo -e "  ${NORD_INFO}[INFO]${NORD_RESET}    Processing your request..."
    echo -e "  ${NORD_MUTED}[DEBUG]${NORD_RESET}   Internal debug information"
    echo ""
    echo -e "${NORD_FG_NORD15}const${NORD_RESET} ${NORD_FG_NORD4}greeting${NORD_RESET} ${NORD_FG_NORD9}=${NORD_RESET} ${NORD_FG_NORD14}\"Hello, Nord!\"${NORD_RESET}${NORD_FG_NORD4};${NORD_RESET}"
    echo -e "${NORD_FG_NORD9}function${NORD_RESET} ${NORD_FG_NORD8}welcome${NORD_RESET}${NORD_FG_NORD4}() {${NORD_RESET}"
    echo -e "    ${NORD_FG_NORD7}console${NORD_RESET}${NORD_FG_NORD4}.${NORD_RESET}${NORD_FG_NORD8}log${NORD_RESET}${NORD_FG_NORD4}(greeting);${NORD_RESET}"
    echo -e "${NORD_FG_NORD4}}${NORD_RESET}"
    echo ""
}

# =============================================================================
# Export Functions
# =============================================================================

export -f nord_apply
export -f nord_info
export -f nord_palette
export -f nord_iterm2_export
export -f nord_demo
