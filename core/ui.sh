#!/usr/bin/env bash
# =============================================================================
# ui.sh - User Interface Components
# =============================================================================
# Provides consistent UI elements for terminal output including headers,
# status messages, spinners, confirmations, and selection menus.
#
# Usage:
#   source "$(dirname "${BASH_SOURCE[0]}")/ui.sh"
#   print_header "Installation"
#   print_success "Done!"
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_UI_SH_LOADED:-}" ]] && return 0
readonly _UI_SH_LOADED=1

# Source dependencies
CORE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${CORE_DIR}/colors.sh"

# =============================================================================
# Unicode Box Drawing Characters
# =============================================================================
readonly BOX_TOP_LEFT='╭'
readonly BOX_TOP_RIGHT='╮'
readonly BOX_BOTTOM_LEFT='╰'
readonly BOX_BOTTOM_RIGHT='╯'
readonly BOX_HORIZONTAL='─'
readonly BOX_VERTICAL='│'

# =============================================================================
# Status Icons
# =============================================================================
readonly ICON_SUCCESS='✓'
readonly ICON_ERROR='✗'
readonly ICON_WARNING='!'
readonly ICON_INFO='→'
readonly ICON_ARROW='▸'
readonly ICON_BULLET='•'

# =============================================================================
# Spinner Frames
# =============================================================================
readonly SPINNER_FRAMES=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

# =============================================================================
# Header Functions
# =============================================================================

# Print a boxed header with centered title
# Arguments:
#   $1 - Title text
#   $2 - (optional) Box width, defaults to terminal width or 60
print_header() {
    local title="$1"
    local width="${2:-60}"
    local term_width

    # Get terminal width if available
    if command -v tput &>/dev/null; then
        term_width=$(tput cols 2>/dev/null || echo 60)
        [[ $width -gt $term_width ]] && width=$term_width
    fi

    # Ensure minimum width for title
    local title_len=${#title}
    [[ $width -lt $((title_len + 4)) ]] && width=$((title_len + 4))

    # Calculate padding for centered title
    local padding=$(( (width - title_len - 2) / 2 ))
    local padding_extra=$(( (width - title_len - 2) % 2 ))

    # Build horizontal line
    local horizontal_line=""
    for ((i = 0; i < width - 2; i++)); do
        horizontal_line+="${BOX_HORIZONTAL}"
    done

    # Build padding strings
    local left_pad=""
    local right_pad=""
    for ((i = 0; i < padding; i++)); do
        left_pad+=" "
    done
    for ((i = 0; i < padding + padding_extra; i++)); do
        right_pad+=" "
    done

    echo ""
    echo -e "${CYAN}${BOX_TOP_LEFT}${horizontal_line}${BOX_TOP_RIGHT}${NC}"
    echo -e "${CYAN}${BOX_VERTICAL}${NC}${left_pad}${BOLD}${title}${NC}${right_pad}${CYAN}${BOX_VERTICAL}${NC}"
    echo -e "${CYAN}${BOX_BOTTOM_LEFT}${horizontal_line}${BOX_BOTTOM_RIGHT}${NC}"
    echo ""
}

# Print a simple section divider
# Arguments:
#   $1 - (optional) Section title
print_divider() {
    local title="${1:-}"
    local width=60

    if [[ -n "$title" ]]; then
        echo -e "\n${DIM}── ${NC}${BOLD}${title}${NC}${DIM} ──${NC}\n"
    else
        local line=""
        for ((i = 0; i < width; i++)); do
            line+="${BOX_HORIZONTAL}"
        done
        echo -e "${DIM}${line}${NC}"
    fi
}

# =============================================================================
# Status Message Functions
# =============================================================================

# Print success message with checkmark icon
# Arguments:
#   $1 - Message text
print_success() {
    echo -e "${SUCCESS}${ICON_SUCCESS}${NC} $1"
}

# Print error message with X icon
# Arguments:
#   $1 - Message text
print_error() {
    echo -e "${ERROR}${ICON_ERROR}${NC} $1" >&2
}

# Print warning message with exclamation icon
# Arguments:
#   $1 - Message text
print_warning() {
    echo -e "${WARNING}${ICON_WARNING}${NC} $1"
}

# Print info message with arrow icon
# Arguments:
#   $1 - Message text
print_info() {
    echo -e "${INFO}${ICON_INFO}${NC} $1"
}

# Print debug message (only if DEBUG is set)
# Arguments:
#   $1 - Message text
print_debug() {
    [[ "${DEBUG_MODE:-0}" == "1" ]] && echo -e "${DIM}[DEBUG] $1${NC}" >&2
}

# =============================================================================
# Progress Indicator Functions
# =============================================================================

# Print step progress indicator
# Arguments:
#   $1 - Current step number
#   $2 - Total steps
#   $3 - Step description
print_step() {
    local current="$1"
    local total="$2"
    local description="$3"

    echo -e "${CYAN}[${current}/${total}]${NC} ${description}"
}

# Display animated spinner while a command runs
# Arguments:
#   $1 - Message to display
#   $2... - Command and arguments to execute
# Returns: Exit code of the executed command
spinner() {
    local message="$1"
    shift
    local command=("$@")

    # If not in a terminal, just run the command
    if [[ ! -t 1 ]]; then
        "${command[@]}"
        return $?
    fi

    # Hide cursor
    tput civis 2>/dev/null || true

    # Run command in background
    "${command[@]}" &
    local pid=$!

    local frame_index=0
    local frame_count=${#SPINNER_FRAMES[@]}

    # Animate spinner while command runs
    while kill -0 "$pid" 2>/dev/null; do
        local frame="${SPINNER_FRAMES[$frame_index]}"
        printf "\r${CYAN}%s${NC} %s" "$frame" "$message"
        frame_index=$(( (frame_index + 1) % frame_count ))
        sleep 0.1
    done

    # Wait for command to finish and get exit code
    wait "$pid"
    local exit_code=$?

    # Clear spinner line
    printf "\r\033[K"

    # Show cursor
    tput cnorm 2>/dev/null || true

    # Print result
    if [[ $exit_code -eq 0 ]]; then
        print_success "$message"
    else
        print_error "$message"
    fi

    return $exit_code
}

# Display a progress bar
# Arguments:
#   $1 - Current value
#   $2 - Maximum value
#   $3 - (optional) Bar width, defaults to 40
print_progress_bar() {
    local current="$1"
    local maximum="$2"
    local width="${3:-40}"

    local percentage=$((current * 100 / maximum))
    local filled=$((current * width / maximum))
    local empty=$((width - filled))

    local bar=""
    for ((i = 0; i < filled; i++)); do bar+="█"; done
    for ((i = 0; i < empty; i++)); do bar+="░"; done

    printf "\r${CYAN}[%s]${NC} %3d%%" "$bar" "$percentage"

    [[ $current -eq $maximum ]] && echo ""
}

# =============================================================================
# User Input Functions
# =============================================================================

# Prompt for Y/N confirmation
# Arguments:
#   $1 - Question to ask
#   $2 - (optional) Default answer: 'y' or 'n', defaults to 'n'
# Returns: 0 for yes, 1 for no
confirm() {
    local question="$1"
    local default="${2:-n}"
    local prompt
    local response

    if [[ "${default,,}" == "y" ]]; then
        prompt="${question} [Y/n]: "
    else
        prompt="${question} [y/N]: "
    fi

    while true; do
        read -r -p "$(echo -e "${YELLOW}?${NC} ${prompt}")" response
        response="${response:-$default}"

        case "${response,,}" in
            y|yes)
                return 0
                ;;
            n|no)
                return 1
                ;;
            *)
                print_warning "Please answer 'y' or 'n'"
                ;;
        esac
    done
}

# Display a selection menu and get user choice
# Arguments:
#   $1 - Prompt message
#   $2... - Menu options
# Returns: Selected option index (1-based) via stdout
# Exit code: 0 on success, 1 on invalid input
select_option() {
    local prompt="$1"
    shift
    local options=("$@")
    local num_options=${#options[@]}

    echo -e "\n${BOLD}${prompt}${NC}\n"

    # Display numbered options
    for i in "${!options[@]}"; do
        local num=$((i + 1))
        echo -e "  ${CYAN}${num})${NC} ${options[$i]}"
    done

    echo ""

    while true; do
        read -r -p "$(echo -e "${YELLOW}?${NC} Enter choice [1-${num_options}]: ")" choice

        # Validate input is a number
        if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
            print_warning "Please enter a number"
            continue
        fi

        # Validate range
        if [[ $choice -lt 1 || $choice -gt $num_options ]]; then
            print_warning "Please enter a number between 1 and ${num_options}"
            continue
        fi

        echo "$choice"
        return 0
    done
}

# Display a multi-select menu (checkboxes)
# Arguments:
#   $1 - Prompt message
#   $2... - Menu options
# Returns: Space-separated list of selected indices (1-based) via stdout
select_multiple() {
    local prompt="$1"
    shift
    local options=("$@")
    local num_options=${#options[@]}
    local selected=()

    echo -e "\n${BOLD}${prompt}${NC}"
    echo -e "${DIM}(Enter numbers separated by spaces, or 'all' for all options)${NC}\n"

    # Display numbered options
    for i in "${!options[@]}"; do
        local num=$((i + 1))
        echo -e "  ${CYAN}${num})${NC} ${options[$i]}"
    done

    echo ""

    while true; do
        read -r -p "$(echo -e "${YELLOW}?${NC} Enter choices: ")" input

        # Handle 'all' selection
        if [[ "${input,,}" == "all" ]]; then
            for ((i = 1; i <= num_options; i++)); do
                selected+=("$i")
            done
            echo "${selected[*]}"
            return 0
        fi

        # Parse and validate selections
        local valid=true
        selected=()

        for choice in $input; do
            if [[ ! "$choice" =~ ^[0-9]+$ ]]; then
                print_warning "'$choice' is not a valid number"
                valid=false
                break
            fi

            if [[ $choice -lt 1 || $choice -gt $num_options ]]; then
                print_warning "'$choice' is out of range (1-${num_options})"
                valid=false
                break
            fi

            selected+=("$choice")
        done

        if [[ "$valid" == true && ${#selected[@]} -gt 0 ]]; then
            echo "${selected[*]}"
            return 0
        fi

        [[ ${#selected[@]} -eq 0 ]] && print_warning "Please select at least one option"
    done
}

# Read text input with optional default and validation
# Arguments:
#   $1 - Prompt message
#   $2 - (optional) Default value
#   $3 - (optional) Validation regex
# Returns: User input via stdout
read_input() {
    local prompt="$1"
    local default="${2:-}"
    local validation="${3:-}"
    local input

    local display_prompt="$prompt"
    [[ -n "$default" ]] && display_prompt="${prompt} [${default}]"

    while true; do
        read -r -p "$(echo -e "${YELLOW}?${NC} ${display_prompt}: ")" input
        input="${input:-$default}"

        # Check if empty when required
        if [[ -z "$input" && -z "$default" ]]; then
            print_warning "This field is required"
            continue
        fi

        # Validate against regex if provided
        if [[ -n "$validation" && ! "$input" =~ $validation ]]; then
            print_warning "Invalid input format"
            continue
        fi

        echo "$input"
        return 0
    done
}

# =============================================================================
# Export Functions
# =============================================================================
export -f print_header print_divider
export -f print_success print_error print_warning print_info print_debug
export -f print_step spinner print_progress_bar
export -f confirm select_option select_multiple read_input
