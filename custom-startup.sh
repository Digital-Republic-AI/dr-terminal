#!/usr/bin/env bash
#
# NERD TERMINAL Setup Script
# Instala e configura o neofetch com ASCII art customizado e métricas com barras
#
# Uso: chmod +x nerd-terminal.sh && ./nerd-terminal.sh
#

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
ORANGE='\033[38;5;208m'

# Função para verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para mostrar preview do logo
show_logo_preview() {
    local logo_name="$1"
    echo ""
    case $logo_name in
        "montini")
            echo -e "${ORANGE} __  __             _   _       _ ${NC}"
            echo -e "${ORANGE}|  \\/  | ___  _ __ | |_(_)_ __ (_)${NC}"
            echo -e "${ORANGE}| |\\/| |/ _ \\| '_ \\| __| | '_ \\| |${NC}"
            echo -e "${ORANGE}| |  | | (_) | | | | |_| | | | | |${NC}"
            echo -e "${ORANGE}|_|  |_|\\___/|_| |_|\\__|_|_| |_|_|${NC}"
            ;;
        "dr")
            echo -e "${ORANGE}  ____  ____  ${NC}"
            echo -e "${ORANGE} |  _ \\|  _ \\ ${NC}"
            echo -e "${ORANGE} | | | | |_) |${NC}"
            echo -e "${ORANGE} | |_| |  _ < ${NC}"
            echo -e "${ORANGE} |____/|_| \\_\\${NC}"
            ;;
        "dev")
            echo -e "${ORANGE}     _            ${NC}"
            echo -e "${ORANGE}  __| | _____   __${NC}"
            echo -e "${ORANGE} / _\` |/ _ \\ \\ / /${NC}"
            echo -e "${ORANGE}| (_| |  __/\\ V / ${NC}"
            echo -e "${ORANGE} \\__,_|\\___| \\_/  ${NC}"
            ;;
        "code")
            echo -e "${ORANGE}  ___ ___  ___| |___${NC}"
            echo -e "${ORANGE} / __/ _ \\/ _\` / _ \\${NC}"
            echo -e "${ORANGE}| (_| (_) | (_| |  __/${NC}"
            echo -e "${ORANGE} \\___\\___/\\__,_|\\___|${NC}"
            ;;
        "mac")
            echo -e "${ORANGE}    .:'${NC}"
            echo -e "${ORANGE}__ :'__${NC}"
            echo -e "${ORANGE}'.  .'${NC}"
            echo -e "${ORANGE} .:' ${NC}"
            echo -e "${ORANGE}':. ${NC}"
            echo -e "${ORANGE}  ':${NC}"
            ;;
        "skull")
            echo -e "${ORANGE}    _____ ${NC}"
            echo -e "${ORANGE}   /     \\ ${NC}"
            echo -e "${ORANGE}  | () () |${NC}"
            echo -e "${ORANGE}   \\  ^  / ${NC}"
            echo -e "${ORANGE}    |||||  ${NC}"
            ;;
        "rocket")
            echo -e "${ORANGE}     /\\     ${NC}"
            echo -e "${ORANGE}    /  \\    ${NC}"
            echo -e "${ORANGE}   |    |   ${NC}"
            echo -e "${ORANGE}   |    |   ${NC}"
            echo -e "${ORANGE}  /| /\\ |\\  ${NC}"
            echo -e "${ORANGE} /_||/\\||_\\ ${NC}"
            echo -e "${ORANGE}    /__\\    ${NC}"
            ;;
        "coffee")
            echo -e "${ORANGE}   ( (  ${NC}"
            echo -e "${ORANGE}    ) ) ${NC}"
            echo -e "${ORANGE}  ........ ${NC}"
            echo -e "${ORANGE}  |      |]${NC}"
            echo -e "${ORANGE}  \\      / ${NC}"
            echo -e "${ORANGE}   \`----'  ${NC}"
            ;;
        "terminal")
            echo -e "${ORANGE} _______________${NC}"
            echo -e "${ORANGE}|  ___________  |${NC}"
            echo -e "${ORANGE}| |  >_       | |${NC}"
            echo -e "${ORANGE}| |___________| |${NC}"
            echo -e "${ORANGE}|_______________|${NC}"
            ;;
        "ghost")
            echo -e "${ORANGE}   .----. ${NC}"
            echo -e "${ORANGE}  / o  o \\ ${NC}"
            echo -e "${ORANGE} |   <>   |${NC}"
            echo -e "${ORANGE} |  \\__/  |${NC}"
            echo -e "${ORANGE}  \\_/\\_/\\_/${NC}"
            ;;
        "ninja")
            echo -e "${ORANGE}    _____${NC}"
            echo -e "${ORANGE}   /     \\${NC}"
            echo -e "${ORANGE}  |_*  *_|${NC}"
            echo -e "${ORANGE}    |  |${NC}"
            echo -e "${ORANGE}   /|  |\\${NC}"
            echo -e "${ORANGE}  (_|__|_)${NC}"
            ;;
        "cat")
            echo -e "${ORANGE}  /\\_/\\  ${NC}"
            echo -e "${ORANGE} ( o.o ) ${NC}"
            echo -e "${ORANGE}  > ^ <  ${NC}"
            echo -e "${ORANGE} /|   |\\${NC}"
            echo -e "${ORANGE}(_|   |_)${NC}"
            ;;
    esac
    echo ""
}

# Função para gerar o logo no formato neofetch
generate_logo_file() {
    local logo_name="$1"
    local output_file="$2"

    case $logo_name in
        "montini")
            cat > "$output_file" << 'EOF'
${c1} __  __             _   _       _
${c1}|  \/  | ___  _ __ | |_(_)_ __ (_)
${c1}| |\/| |/ _ \| '_ \| __| | '_ \| |
${c1}| |  | | (_) | | | | |_| | | | | |
${c1}|_|  |_|\___/|_| |_|\__|_|_| |_|_|
EOF
            ;;
        "dr")
            cat > "$output_file" << 'EOF'
${c1}  ____  ____
${c1} |  _ \|  _ \
${c1} | | | | |_) |
${c1} | |_| |  _ <
${c1} |____/|_| \_\
EOF
            ;;
        "dev")
            cat > "$output_file" << 'EOF'
${c1}     _
${c1}  __| | _____   __
${c1} / _` |/ _ \ \ / /
${c1}| (_| |  __/\ V /
${c1} \__,_|\___| \_/
EOF
            ;;
        "code")
            cat > "$output_file" << 'EOF'
${c1}  ___ ___  ___| |___
${c1} / __/ _ \/ _` / _ \
${c1}| (_| (_) | (_| |  __/
${c1} \___\___/\__,_|\___|
EOF
            ;;
        "mac")
            cat > "$output_file" << 'EOF'
${c1}    .:'
${c1}__ :'__
${c1}'.  .'
${c1} .:'
${c1}':.
${c1}  ':
EOF
            ;;
        "skull")
            cat > "$output_file" << 'EOF'
${c1}    _____
${c1}   /     \
${c1}  | () () |
${c1}   \  ^  /
${c1}    |||||
EOF
            ;;
        "rocket")
            cat > "$output_file" << 'EOF'
${c1}     /\
${c1}    /  \
${c1}   |    |
${c1}   |    |
${c1}  /| /\ |\
${c1} /_||/\||_\
${c1}    /__\
EOF
            ;;
        "coffee")
            cat > "$output_file" << 'EOF'
${c1}   ( (
${c1}    ) )
${c1}  ........
${c1}  |      |]
${c1}  \      /
${c1}   `----'
EOF
            ;;
        "terminal")
            cat > "$output_file" << 'EOF'
${c1} _______________
${c1}|  ___________  |
${c1}| |  >_       | |
${c1}| |___________| |
${c1}|_______________|
EOF
            ;;
        "ghost")
            cat > "$output_file" << 'EOF'
${c1}   .----.
${c1}  / o  o \
${c1} |   <>   |
${c1} |  \__/  |
${c1}  \_/\_/\_/
EOF
            ;;
        "ninja")
            cat > "$output_file" << 'EOF'
${c1}    _____
${c1}   /     \
${c1}  |_*  *_|
${c1}    |  |
${c1}   /|  |\
${c1}  (_|__|_)
EOF
            ;;
        "cat")
            cat > "$output_file" << 'EOF'
${c1}  /\_/\
${c1} ( o.o )
${c1}  > ^ <
${c1} /|   |\
${c1}(_|   |_)
EOF
            ;;
        "custom")
            # Nome customizado será gerado depois
            ;;
    esac
}

# Função para gerar ASCII art de texto usando figlet-style
generate_custom_name() {
    local name="$1"
    local output_file="$2"

    # Converter para maiúsculas e limitar a 8 caracteres
    name=$(echo "$name" | tr '[:lower:]' '[:upper:]' | cut -c1-8)

    # Gerar ASCII art simples baseado no nome
    # Usando um estilo block letters simplificado
    python3 << PYEOF > "$output_file"
import sys

# Definição simplificada de letras ASCII
letters = {
    'A': [" __ ", "/  \\\\", "|--|", "|  |"],
    'B': ["|‾‾\\\\", "|--<", "|__/"],
    'C': [" __", "/  ", "\\\\__"],
    'D': ["|‾‾\\\\", "|  |", "|__/"],
    'E': ["|‾‾", "|--", "|__"],
    'F': ["|‾‾", "|--", "|  "],
    'G': [" __", "| _ ", "|__|"],
    'H': ["|  |", "|--|", "|  |"],
    'I': ["___", " | ", "_|_"],
    'J': ["  |", "  |", "\\_|"],
    'K': ["| /", "|< ", "| \\\\"],
    'L': ["|  ", "|  ", "|__"],
    'M': ["|\\/|", "|  |", "|  |"],
    'N': ["|\\ |", "| \\\\|", "|  |"],
    'O': [" _ ", "| |", "|_|"],
    'P': ["|‾‾\\\\", "|--/", "|   "],
    'Q': [" _ ", "| |", "|_\\\\"],
    'R': ["|‾‾\\\\", "|--<", "|  \\\\"],
    'S': [" __", "(__", "__)"],
    'T': ["___", " | ", " | "],
    'U': ["|  |", "|  |", "|__|"],
    'V': ["\\\\  /", " \\\\/ ", "  V "],
    'W': ["|  |", "|/\\\\|", "|  |"],
    'X': ["\\\\  /", " \\\\/ ", " /\\\\ "],
    'Y': ["\\\\  /", " \\\\/ ", "  | "],
    'Z': ["___", " / ", "/__"],
    ' ': ["   ", "   ", "   "],
    '0': [" _ ", "| |", "|_|"],
    '1': [" | ", " | ", " | "],
    '2': [" _ ", " _|", "|_ "],
    '3': ["__ ", " _|", "__|"],
    '4': ["|_|", "  |", "  |"],
    '5': [" __", "|_ ", " _|"],
    '6': [" _ ", "|_ ", "|_|"],
    '7': ["___", "  /", " / "],
    '8': [" _ ", "|_|", "|_|"],
    '9': [" _ ", "|_|", "  |"],
}

name = "${name}"
height = 3

# Gerar cada linha
for row in range(height):
    line = ""
    for char in name:
        if char in letters:
            letter = letters[char]
            if row < len(letter):
                line += letter[row]
            else:
                line += "   "
        else:
            line += "   "
    print(f"\${{c1}}{line}")
PYEOF

    # Se python falhar, usar método simples
    if [ ! -s "$output_file" ]; then
        echo "\${c1}  $name" > "$output_file"
    fi
}

# Menu de seleção de logo
show_logo_menu() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}        ${WHITE}NERD TERMINAL SETUP - Escolha seu ASCII Art${NC}         ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${WHITE}Logos de Texto:${NC}"
    echo -e "    ${YELLOW}1)${NC} montini   - Nome Montini em ASCII"
    echo -e "    ${YELLOW}2)${NC} dr        - DR (Digital Republic)"
    echo -e "    ${YELLOW}3)${NC} dev       - Palavra 'dev'"
    echo -e "    ${YELLOW}4)${NC} code      - Palavra 'code'"
    echo ""
    echo -e "  ${WHITE}Logos de Símbolos:${NC}"
    echo -e "    ${YELLOW}5)${NC} mac       - Apple minimalista"
    echo -e "    ${YELLOW}6)${NC} terminal  - Terminal/Console"
    echo -e "    ${YELLOW}7)${NC} rocket    - Foguete"
    echo -e "    ${YELLOW}8)${NC} coffee    - Xícara de café"
    echo ""
    echo -e "  ${WHITE}Logos Divertidos:${NC}"
    echo -e "    ${YELLOW}9)${NC} skull     - Caveira"
    echo -e "    ${YELLOW}10)${NC} ghost    - Fantasma"
    echo -e "    ${YELLOW}11)${NC} ninja    - Ninja"
    echo -e "    ${YELLOW}12)${NC} cat      - Gato"
    echo ""
    echo -e "  ${WHITE}Personalizado:${NC}"
    echo -e "    ${YELLOW}13)${NC} custom   - Digite seu próprio nome/texto"
    echo ""
}

# Seleção de cor
show_color_menu() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}               ${WHITE}Escolha a cor do ASCII Art${NC}                   ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${YELLOW}1)${NC} ${ORANGE}██${NC} Laranja (208) - Padrão"
    echo -e "    ${YELLOW}2)${NC} ${RED}██${NC} Vermelho (196)"
    echo -e "    ${YELLOW}3)${NC} ${GREEN}██${NC} Verde (46)"
    echo -e "    ${YELLOW}4)${NC} ${BLUE}██${NC} Azul (33)"
    echo -e "    ${YELLOW}5)${NC} ${PURPLE}██${NC} Roxo (129)"
    echo -e "    ${YELLOW}6)${NC} ${CYAN}██${NC} Ciano (51)"
    echo -e "    ${YELLOW}7)${NC} ${WHITE}██${NC} Branco (15)"
    echo -e "    ${YELLOW}8)${NC} \033[38;5;226m██${NC} Amarelo (226)"
    echo -e "    ${YELLOW}9)${NC} \033[38;5;213m██${NC} Rosa (213)"
    echo ""
}

get_color_code() {
    local choice="$1"
    case $choice in
        1) echo "208" ;;
        2) echo "196" ;;
        3) echo "46" ;;
        4) echo "33" ;;
        5) echo "129" ;;
        6) echo "51" ;;
        7) echo "15" ;;
        8) echo "226" ;;
        9) echo "213" ;;
        *) echo "208" ;;
    esac
}

# ============================================================
# INÍCIO DO SCRIPT
# ============================================================

clear
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║  _   _ _____ ____  ____    _____ _____ ____  __  __        ║"
echo "║ | \ | | ____|  _ \|  _ \  |_   _| ____|  _ \|  \/  |       ║"
echo "║ |  \| |  _| | |_) | | | |   | | |  _| | |_) | |\/| |       ║"
echo "║ | |\  | |___|  _ <| |_| |   | | | |___|  _ <| |  | |       ║"
echo "║ |_| \_|_____|_| \_\____/    |_| |_____|_| \_\_|  |_|       ║"
echo "║                                                            ║"
echo "║              CUSTOM SETUP INSTALLER                        ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "${WHITE}Este script irá:${NC}"
echo "  • Instalar neofetch (se necessário)"
echo "  • Configurar ASCII art personalizado"
echo "  • Adicionar métricas com barras visuais"
echo "  • Configurar execução automática no terminal"
echo ""
read -p "Pressione ENTER para continuar ou CTRL+C para cancelar..."

# Mostrar menu de logos
show_logo_menu

# Seleção do logo
echo -n -e "${WHITE}Digite o número ou nome do logo desejado: ${NC}"
read logo_choice

# Mapear escolha para nome do logo
case $logo_choice in
    1|montini) LOGO_NAME="montini" ;;
    2|dr) LOGO_NAME="dr" ;;
    3|dev) LOGO_NAME="dev" ;;
    4|code) LOGO_NAME="code" ;;
    5|mac) LOGO_NAME="mac" ;;
    6|terminal) LOGO_NAME="terminal" ;;
    7|rocket) LOGO_NAME="rocket" ;;
    8|coffee) LOGO_NAME="coffee" ;;
    9|skull) LOGO_NAME="skull" ;;
    10|ghost) LOGO_NAME="ghost" ;;
    11|ninja) LOGO_NAME="ninja" ;;
    12|cat) LOGO_NAME="cat" ;;
    13|custom) LOGO_NAME="custom" ;;
    *) LOGO_NAME="montini" ;;
esac

# Se for custom, pedir o nome
CUSTOM_NAME=""
if [ "$LOGO_NAME" = "custom" ]; then
    echo ""
    echo -n -e "${WHITE}Digite o texto para o ASCII art (max 8 caracteres): ${NC}"
    read CUSTOM_NAME
    CUSTOM_NAME=$(echo "$CUSTOM_NAME" | cut -c1-8)
fi

# Preview do logo selecionado
if [ "$LOGO_NAME" != "custom" ]; then
    echo ""
    echo -e "${GREEN}Preview do logo selecionado:${NC}"
    show_logo_preview "$LOGO_NAME"
fi

# Seleção de cor
show_color_menu
echo -n -e "${WHITE}Digite o número da cor desejada [1]: ${NC}"
read color_choice
color_choice=${color_choice:-1}
ASCII_COLOR=$(get_color_code "$color_choice")

echo ""
echo -e "${GREEN}Configuração selecionada:${NC}"
echo -e "  Logo: ${YELLOW}$LOGO_NAME${NC}"
[ -n "$CUSTOM_NAME" ] && echo -e "  Texto: ${YELLOW}$CUSTOM_NAME${NC}"
echo -e "  Cor: ${YELLOW}$ASCII_COLOR${NC}"
echo ""
read -p "Pressione ENTER para iniciar a instalação..."

# ============================================================
# INSTALAÇÃO
# ============================================================

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}                    INICIANDO INSTALAÇÃO                        ${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# 1. Verificar/Instalar Homebrew (apenas macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${YELLOW}[1/5]${NC} Verificando Homebrew..."
    if ! command_exists brew; then
        echo "  Instalando Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo -e "  ${GREEN}✓${NC} Homebrew já instalado"
    fi
fi

# 2. Instalar neofetch
echo -e "${YELLOW}[2/5]${NC} Verificando neofetch..."
if ! command_exists neofetch; then
    echo "  Instalando neofetch..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install neofetch
    elif command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y neofetch
    elif command_exists dnf; then
        sudo dnf install -y neofetch
    elif command_exists pacman; then
        sudo pacman -S --noconfirm neofetch
    else
        echo -e "  ${RED}ERRO:${NC} Não foi possível detectar o gerenciador de pacotes"
        exit 1
    fi
else
    echo -e "  ${GREEN}✓${NC} neofetch já instalado"
fi

# 3. Criar diretório de configuração
echo -e "${YELLOW}[3/5]${NC} Criando diretório de configuração..."
mkdir -p "$HOME/.config/neofetch"
echo -e "  ${GREEN}✓${NC} $HOME/.config/neofetch"

# 4. Criar arquivo de logo ASCII
echo -e "${YELLOW}[4/5]${NC} Criando logo ASCII..."
LOGO_FILE="$HOME/.config/neofetch/logo.txt"

if [ "$LOGO_NAME" = "custom" ] && [ -n "$CUSTOM_NAME" ]; then
    generate_custom_name "$CUSTOM_NAME" "$LOGO_FILE"
else
    generate_logo_file "$LOGO_NAME" "$LOGO_FILE"
fi
echo -e "  ${GREEN}✓${NC} logo.txt criado"

# 5. Criar arquivo de configuração
echo -e "${YELLOW}[5/5]${NC} Criando configuração customizada..."
cat > "$HOME/.config/neofetch/config.conf" << 'CONFIG_EOF'
# Nerd Terminal Config
# Configurado com métricas em GB e barras visuais

print_info() {
    # Linha em branco: prin ""
    # Linha com traços: info underline

    prin "$(date '+%d/%m/%Y - %H:%M:%S')"
    prin ""

    info "OS" distro
    info "Chip" cpu
    info "Uptime" uptime
    info "IP" local_ip

    prin ""

    # Custom memory info in GB with bar (bar left, values right)
    mem_info=$(
      total=$(sysctl -n hw.memsize 2>/dev/null | awk '{print $1/1024/1024/1024}' || free -b 2>/dev/null | awk '/Mem:/{print $2/1024/1024/1024}')
      used=$(ps -caxm -orss= 2>/dev/null | awk '{sum+=$1} END {print sum/1024/1024}' || free -b 2>/dev/null | awk '/Mem:/{print $3/1024/1024/1024}')
      awk -v used="$used" -v total="$total" 'BEGIN {
        pct=int((used/total)*100)
        bar_len=15
        filled=int((pct*bar_len)/100)
        empty=bar_len-filled
        bar=""
        for(i=0;i<empty;i++) bar=bar"-"
        for(i=0;i<filled;i++) bar=bar"="
        printf "[%s] %.1fG / %.0fG", bar, used, total
      }'
    )
    prin "Memory____" "$mem_info"

    # Custom disk info for macOS APFS (bar left, values right)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        disk_info=$(diskutil apfs list 2>/dev/null | grep -E "Size \(Capacity|Capacity In Use" | head -2 | \
          sed -n 's/.*(\([0-9.]*\) GB).*/\1/p' | \
          awk 'NR==1{total=$1} NR==2{used=$1} END{
            pct=int((used/total)*100)
            bar_len=15
            filled=int((pct*bar_len)/100)
            empty=bar_len-filled
            bar=""
            for(i=0;i<empty;i++) bar=bar"-"
            for(i=0;i<filled;i++) bar=bar"="
            printf "[%s] %.0fG / %.0fG (%.0f%%)", bar, used, total, pct
          }')
    else
        disk_info=$(df -h / | awk 'NR==2{
            used=$3; total=$2; pct=$5
            gsub(/G/,"",used); gsub(/G/,"",total); gsub(/%/,"",pct)
            bar_len=15
            filled=int((pct*bar_len)/100)
            empty=bar_len-filled
            bar=""
            for(i=0;i<empty;i++) bar=bar"-"
            for(i=0;i<filled;i++) bar=bar"="
            printf "[%s] %sG / %sG (%s%%)", bar, used, total, pct
        }')
    fi
    prin "Disk______" "$disk_info"

    info "CPU Usage_" cpu_usage
    info "Battery___" battery

    prin ""
}

title_fqdn="off"
kernel_shorthand="on"
distro_shorthand="off"
os_arch="on"
uptime_shorthand="on"
memory_percent="off"
memory_unit="gib"
package_managers="on"
shell_path="off"
shell_version="on"
speed_type="bios_limit"
speed_shorthand="off"
cpu_brand="on"
cpu_speed="on"
cpu_cores="logical"
cpu_temp="off"
gpu_brand="on"
gpu_type="all"
refresh_rate="off"
gtk_shorthand="off"
gtk2="on"
gtk3="on"
public_ip_host="http://ident.me"
public_ip_timeout=2
de_version="on"
disk_show=('/')
disk_subtitle="mount"
disk_percent="on"
music_player="auto"
song_format="%artist% - %album% - %title%"
song_shorthand="off"
mpc_args=()
colors=(7 7 7 7 7 7)
bold="on"
underline_enabled="on"
underline_char="-"
separator=":"
block_range=(0 15)
color_blocks="on"
block_width=3
block_height=1
col_offset="auto"
bar_char_elapsed="-"
bar_char_total="="
bar_border="on"
bar_length=15
bar_color_elapsed="distro"
bar_color_total="distro"
cpu_display="barinfo"
memory_display="barinfo"
battery_display="barinfo"
disk_display="infobar"
image_backend="ascii"
image_source="$HOME/.config/neofetch/logo.txt"
ascii_distro="auto"
ascii_bold="on"
image_loop="off"
thumbnail_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch"
crop_mode="normal"
crop_offset="center"
image_size="auto"
gap=3
yoffset=0
xoffset=0
background_color=
stdout="off"
CONFIG_EOF

# Atualizar cor no config
sed -i.bak "s/ascii_colors=.*/ascii_colors=($ASCII_COLOR)/" "$HOME/.config/neofetch/config.conf" 2>/dev/null || \
sed -i '' "s/ascii_colors=.*/ascii_colors=($ASCII_COLOR)/" "$HOME/.config/neofetch/config.conf"

# Adicionar linha de ascii_colors se não existir
if ! grep -q "ascii_colors" "$HOME/.config/neofetch/config.conf"; then
    echo "ascii_colors=($ASCII_COLOR)" >> "$HOME/.config/neofetch/config.conf"
fi

echo -e "  ${GREEN}✓${NC} config.conf criado"

# 6. Adicionar ao .zshrc ou .bashrc
echo ""
echo -e "${YELLOW}[Extra]${NC} Configurando shell..."
NEOFETCH_LINE="neofetch --ascii ~/.config/neofetch/logo.txt --ascii_colors $ASCII_COLOR"

# Detectar shell
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    SHELL_RC="$HOME/.zshrc"
fi

if [ -f "$SHELL_RC" ]; then
    # Remover configurações antigas de neofetch
    sed -i.bak '/neofetch/d' "$SHELL_RC" 2>/dev/null || \
    sed -i '' '/neofetch/d' "$SHELL_RC"
fi

# Adicionar nova configuração
echo "" >> "$SHELL_RC"
echo "# Nerd Terminal with custom ASCII art" >> "$SHELL_RC"
echo "$NEOFETCH_LINE" >> "$SHELL_RC"
echo -e "  ${GREEN}✓${NC} Configurado em $SHELL_RC"

# ============================================================
# CONCLUSÃO
# ============================================================

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}              INSTALAÇÃO CONCLUÍDA COM SUCESSO!                 ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${WHITE}Arquivos criados:${NC}"
echo "  • ~/.config/neofetch/logo.txt"
echo "  • ~/.config/neofetch/config.conf"
echo "  • $SHELL_RC (atualizado)"
echo ""
echo -e "${WHITE}Para ver o resultado:${NC}"
echo -e "  ${CYAN}Abra um novo terminal${NC} ou execute:"
echo -e "  ${YELLOW}$NEOFETCH_LINE${NC}"
echo ""

# Preview final
echo -e "${WHITE}Preview:${NC}"
echo ""
neofetch --ascii "$HOME/.config/neofetch/logo.txt" --ascii_colors "$ASCII_COLOR"
