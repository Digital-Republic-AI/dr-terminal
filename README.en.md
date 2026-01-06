<p align="center">
  <img src="https://img.shields.io/badge/macOS-10.15+-blue?style=for-the-badge&logo=apple&logoColor=white" alt="macOS">
  <img src="https://img.shields.io/badge/Shell-Bash%20%7C%20ZSH-green?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Shell">
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/badge/Version-1.0.0-purple?style=for-the-badge" alt="Version">
</p>

<h1 align="center">
  <br>
  🖥️ DR Custom Terminal
  <br>
</h1>

<h4 align="center">Transform your macOS terminal from basic to brilliant in minutes.</h4>

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-installation-profiles">Profiles</a> •
  <a href="#-included-tools">Tools</a> •
  <a href="#-usage-guide">Usage Guide</a> •
  <a href="#-project-structure">Structure</a>
</p>

---

## 🎯 What is This Project?

**DR Custom Terminal** is a complete modular toolkit for customizing your macOS terminal. It automatically installs and configures:

- **Shell Framework** - Oh My ZSH with powerful plugins
- **Icon Fonts** - Nerd Fonts for rich visuals
- **Prompt Themes** - Powerlevel10k or Starship
- **Modern CLI Tools** - Superior replacements for classic commands

### Why use it?

| Problem | Solution |
|---------|----------|
| Ugly, colorless terminal | Beautiful themes + syntax coloring |
| Basic `ls` with no info | `eza` with icons, colors, and Git status |
| `cat` without code highlighting | `bat` with syntax highlighting |
| Slow file searching | `fd` + `fzf` = instant search |
| Hard to navigate history | Fuzzy search with `CTRL-R` |
| Git on command line is tedious | `lazygit` with visual interface |

---

## 🚀 Quick Start

### One-Line Installation

```bash
git clone https://github.com/yourusername/terminal-customization.git && cd terminal-customization && ./install.sh
```

### Direct Profile Installation

```bash
# 🟢 Minimal Installation (~5 min, ~200MB)
./install.sh minimal

# 🔵 Full Developer Installation (~10 min, ~500MB)
./install.sh developer

# 🟣 Custom Installation (choose what you want)
./install.sh
```

---

## 📦 Installation Profiles

### 🟢 Minimal Profile

**Ideal for:** Quick setup, minimal overhead, essential features.

```
┌─────────────────────────────────────────────────────────┐
│  ✓ Homebrew        Package manager                      │
│  ✓ Oh My ZSH       ZSH configuration framework          │
│  ✓ MesloLGS NF     Icon font (Nerd Font)                │
│  ✓ Powerlevel10k   Beautiful and fast prompt theme      │
└─────────────────────────────────────────────────────────┘
```

### 🔵 Developer Profile

**Ideal for:** Developers, power users, maximum productivity.

```
┌─────────────────────────────────────────────────────────┐
│  ✓ Everything from Minimal                              │
│  ─────────────────────────────────────────────────────  │
│  ZSH Plugins:                                           │
│  ✓ autosuggestions     Automatic suggestions            │
│  ✓ syntax-highlighting Real-time coloring               │
│  ✓ completions         Enhanced autocomplete            │
│  ✓ history-search      History search                   │
│  ─────────────────────────────────────────────────────  │
│  CLI Utilities:                                         │
│  ✓ fzf      Fuzzy search         ✓ bat     Better cat   │
│  ✓ eza      Modern ls            ✓ ripgrep Fast grep    │
│  ✓ fd       Simple find          ✓ zoxide  Smart cd     │
│  ✓ delta    Beautiful diff       ✓ lazygit Visual Git   │
│  ✓ btop     Resource monitor     ✓ neofetch System info │
└─────────────────────────────────────────────────────────┘
```

### 🟣 Custom Profile

**Ideal for:** Specific needs, selective installation.

Interactively choose exactly what you want to install.

---

## 🛠️ Included Tools

### 📝 Shell and Prompt

<table>
<tr>
<td width="50%">

#### Oh My ZSH
Configuration framework for ZSH with 300+ plugins and themes.

**What it does:**
- Manages plugins and themes
- Provides useful aliases
- Automatic auto-updates

**How to use:**
```bash
# View active plugins
echo $plugins

# Update Oh My ZSH
omz update
```

</td>
<td width="50%">

#### Powerlevel10k
Extremely fast and customizable prompt theme.

**What it does:**
- Shows current Git branch
- Indicates last command status
- Displays project language/version

**How to use:**
```bash
# Configure prompt appearance
p10k configure

# Edit configuration
nano ~/.p10k.zsh
```

</td>
</tr>
</table>

---

### 🔍 Search and Navigation

<table>
<tr>
<td width="50%">

#### fzf - Fuzzy Finder
Interactive search for anything.

**What it does:**
- Search files instantly
- Navigate command history
- Filter any list

**Shortcuts:**
| Key | Action |
|-----|--------|
| `CTRL-R` | Search history |
| `CTRL-T` | Search files |
| `ALT-C` | Navigate to folder |

**Examples:**
```bash
# Search and open file in vim
vim $(fzf)

# Search in history
CTRL-R → type part of command

# File preview
fzf --preview 'bat {}'
```

</td>
<td width="50%">

#### zoxide - Smart CD
Directory navigation that learns your habits.

**What it does:**
- Remembers visited directories
- Jumps to folders by partial name
- Ranking by usage frequency

**Examples:**
```bash
# Go to ~/Projects/my-app
z my-app

# Go to ~/Documents/work/reports
z reports

# Interactive selection
zi

# View most used directories
zoxide query -l
```

**Tip:** After using it, `z` knows where you want to go!

</td>
</tr>
</table>

---

### 📂 File Viewing

<table>
<tr>
<td width="50%">

#### bat - Cat with Superpowers
File viewer with syntax highlighting.

**What it does:**
- Automatic syntax highlighting
- Line numbers
- Git integration (shows changes)
- Automatic pagination

**Examples:**
```bash
# View file with highlighting
bat file.js

# View Git differences
bat --diff file.js

# Show only lines 10-20
bat -r 10:20 file.py

# Different theme
bat --theme="Dracula" file.rs

# List available themes
bat --list-themes
```

</td>
<td width="50%">

#### eza - Modern LS
`ls` replacement with colors, icons, and more.

**What it does:**
- Icons for file types
- Colors by type/permission
- Integrated Git status
- Tree view

**Examples:**
```bash
# Detailed list with icons
eza -la

# Tree view (2 levels)
eza --tree --level=2

# With Git status
eza -la --git

# Sort by modification
eza -la --sort=modified

# Directories only
eza -la --only-dirs
```

**Useful aliases (already configured):**
```bash
ll    # eza -la
la    # eza -a
lt    # eza --tree
```

</td>
</tr>
</table>

---

### 🔎 File Search

<table>
<tr>
<td width="50%">

#### ripgrep (rg) - Ultra-fast Grep
File search 10x faster than grep.

**What it does:**
- Recursive search by default
- Ignores .gitignore automatically
- Regex support
- Match highlighting

**Examples:**
```bash
# Search "TODO" in all files
rg "TODO"

# Search in specific type
rg "import" --type js

# Case insensitive
rg -i "error"

# Show context (3 lines)
rg -C 3 "function"

# Search exact word
rg -w "test"

# Count occurrences
rg -c "console.log"

# List files that contain
rg -l "useState"
```

</td>
<td width="50%">

#### fd - Simplified Find
Alternative to `find` with friendly syntax.

**What it does:**
- Simple and intuitive syntax
- Ignores .gitignore automatically
- Colored search
- Much faster than `find`

**Examples:**
```bash
# Search by name
fd "readme"

# Search by extension
fd -e js

# Search directories only
fd -t d "src"

# Search hidden files
fd -H ".env"

# Execute command on results
fd -e jpg -x convert {} {.}.png

# Search with regex
fd "^test.*\.js$"

# Exclude directory
fd -E node_modules "config"
```

</td>
</tr>
</table>

---

### 🔀 Advanced Git

<table>
<tr>
<td width="50%">

#### delta - Beautiful Diff
Git diffs with syntax highlighting.

**What it does:**
- Colors by language
- Line numbers
- Side-by-side navigation
- Git integration

**Already configured automatically!**

```bash
# View diff with colors
git diff

# View log with diff
git log -p

# Compare branches
git diff main..feature
```

**Visual features:**
- Added lines in green
- Removed lines in red
- Language syntax highlighting

</td>
<td width="50%">

#### lazygit - Visual Git
Complete TUI interface for Git.

**What it does:**
- Visual stage/unstage
- Interactive commits
- Branch navigation
- Conflict resolution
- Cherry-pick, rebase, etc.

**How to use:**
```bash
# Open interface
lazygit
```

**Main shortcuts:**
| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `b` | View branches |
| `?` | Help |
| `q` | Quit |

</td>
</tr>
</table>

---

### 📊 System and Monitoring

<table>
<tr>
<td width="50%">

#### btop - Resource Monitor
System monitor with graphical terminal interface.

**What it does:**
- CPU, RAM, Disk, Network
- Real-time graphs
- Process list
- Kill processes

**How to use:**
```bash
# Open monitor
btop
```

**Shortcuts:**
| Key | Action |
|-----|--------|
| `m` | Menu |
| `k` | Kill process |
| `f` | Filter |
| `q` | Quit |

</td>
<td width="50%">

#### neofetch - System Info
Displays system information with style.

**What it does:**
- macOS logo in ASCII
- System version
- Hardware
- Uptime, packages, shell

**How to use:**
```bash
# Show info
neofetch

# With small logo
neofetch --ascii_distro mac_small
```

**Tip:** Add to `.zshrc` to see when opening terminal:
```bash
echo "neofetch" >> ~/.zshrc
```

</td>
</tr>
</table>

---

### ⚡ ZSH Plugins

| Plugin | What it does | How it works |
|--------|--------------|--------------|
| **autosuggestions** | Suggests commands based on history | Type and see suggestion in gray, `→` to accept |
| **syntax-highlighting** | Colors commands in real-time | Red = error, green = valid |
| **completions** | Advanced autocomplete | `Tab` to see options |
| **history-substring-search** | Search history by substring | `↑` `↓` after typing part of command |

---

## 🎨 Color Themes

Install color themes for your terminal:

```bash
# Dracula - Elegant dark purple
./themes/color-schemes/dracula.sh

# Catppuccin - Soft pastel tones
./themes/color-schemes/catppuccin.sh

# Gruvbox - Warm retro
./themes/color-schemes/gruvbox.sh

# Nord - Arctic blue
./themes/color-schemes/nord.sh
```

---

## 🔧 Module Management

Each module can be managed individually:

```bash
# ┌─────────────────────────────────────────────────┐
# │ Available commands for each module              │
# └─────────────────────────────────────────────────┘

# Install
./modules/utils/fzf.sh install

# View status
./modules/utils/fzf.sh status

# Uninstall
./modules/utils/fzf.sh uninstall

# Help
./modules/utils/fzf.sh help
```

### Available Modules

```
modules/
├── base/
│   ├── xcode-cli.sh      # Xcode Command Line Tools
│   └── homebrew.sh       # Package manager
├── shell/
│   └── oh-my-zsh.sh      # ZSH framework
├── fonts/
│   └── nerd-fonts.sh     # Icon fonts
├── prompt/
│   ├── powerlevel10k.sh  # Prompt theme
│   └── starship.sh       # Alternative prompt
├── plugins/
│   ├── zsh-autosuggestions.sh
│   ├── zsh-syntax-highlighting.sh
│   ├── zsh-completions.sh
│   └── zsh-history-substring-search.sh
└── utils/
    ├── fzf.sh            # Fuzzy finder
    ├── bat.sh            # Improved cat
    ├── eza.sh            # Modern ls
    ├── ripgrep.sh        # Fast grep
    ├── fd.sh             # Simple find
    ├── zoxide.sh         # Smart cd
    ├── delta.sh          # Beautiful diff
    ├── lazygit.sh        # Visual Git
    ├── btop.sh           # System monitor
    └── neofetch.sh       # System info
```

---

## 📁 Project Structure

```
terminal-customization/
│
├── install.sh              # 🚀 Main installer
├── custom-startup.sh       # ⚙️  Startup configurations
│
├── core/                   # 🔧 Core libraries
│   ├── colors.sh           #    ANSI color definitions
│   ├── ui.sh               #    UI components (headers, spinners)
│   ├── validators.sh       #    Validation functions
│   ├── shell-config.sh     #    Shell configuration helpers
│   └── installers.sh       #    Installation wrappers
│
├── modules/                # 📦 Installation modules
│   ├── base/               #    Base components
│   ├── shell/              #    Shell frameworks
│   ├── fonts/              #    Fonts
│   ├── prompt/             #    Prompt themes
│   ├── plugins/            #    ZSH plugins
│   └── utils/              #    CLI utilities
│
├── profiles/               # 👤 Installation profiles
│   ├── minimal.sh          #    Minimal profile
│   └── developer.sh        #    Developer profile
│
├── themes/                 # 🎨 Visual customization
│   ├── ascii-art/          #    ASCII art
│   └── color-schemes/      #    Color schemes
│
└── docs/                   # 📚 Documentation
    ├── MODULES.md          #    Detailed documentation
    └── TROUBLESHOOTING.md  #    Problem solving
```

---

## ⚙️ Post-Installation

### 1. Restart Your Terminal
```bash
source ~/.zshrc
# or simply close and reopen
```

### 2. Configure Powerlevel10k
```bash
p10k configure
```

### 3. Configure Terminal Font

**iTerm2:**
1. `⌘,` → Preferences
2. Profiles → Text → Font
3. Select **MesloLGS NF**

**Terminal.app:**
1. `⌘,` → Preferences
2. Profiles → Font → Change
3. Select **MesloLGS NF**

**VS Code Terminal:**
```json
{
  "terminal.integrated.fontFamily": "MesloLGS NF"
}
```

---

## 📋 Requirements

| Requirement | Minimum |
|-------------|---------|
| **System** | macOS 10.15 (Catalina)+ |
| **Shell** | Bash 3.2+ (for installer) |
| **Space** | 200MB - 500MB |
| **Internet** | Required |

---

## 🐛 Troubleshooting

### Icons not showing
→ Configure the **MesloLGS NF** font in your terminal

### Strange colors
→ Check if terminal supports 256 colors:
```bash
echo $TERM  # Should show xterm-256color
```

### Command not found
→ Reload shell:
```bash
source ~/.zshrc
```

### View installation log
```bash
cat .install.log
```

For more issues, see [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

---

<p align="center">
  <a href="#-terminal-customization-gallery">⬆️ Back to top</a>
</p>
