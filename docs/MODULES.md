# Module Documentation

**Complete reference for all DR Custom Terminal modules.**

This document provides detailed information about each module, including what it installs, configuration options, dependencies, and standalone usage examples.

---

## Table of Contents

- [Module Categories](#module-categories)
- [Base Modules](#base-modules)
  - [xcode-cli](#xcode-cli)
  - [homebrew](#homebrew)
- [Shell Modules](#shell-modules)
  - [oh-my-zsh](#oh-my-zsh)
- [Font Modules](#font-modules)
  - [nerd-fonts](#nerd-fonts)
- [Prompt Themes](#prompt-themes)
  - [powerlevel10k](#powerlevel10k)
  - [starship](#starship)
- [ZSH Plugins](#zsh-plugins)
  - [zsh-autosuggestions](#zsh-autosuggestions)
  - [zsh-syntax-highlighting](#zsh-syntax-highlighting)
  - [zsh-completions](#zsh-completions)
  - [zsh-history-substring-search](#zsh-history-substring-search)
- [Utility Modules](#utility-modules)
  - [fzf](#fzf)
  - [bat](#bat)
  - [eza](#eza)
  - [ripgrep](#ripgrep)
  - [fd](#fd)
  - [zoxide](#zoxide)
  - [delta](#delta)
  - [lazygit](#lazygit)
  - [btop](#btop)
  - [neofetch](#neofetch)
- [Core Libraries](#core-libraries)
- [Creating Custom Modules](#creating-custom-modules)

---

## Module Categories

Modules are organized into logical categories:

| Category | Purpose | Location |
|----------|---------|----------|
| **Base** | System prerequisites and package management | `modules/base/` |
| **Shell** | Shell frameworks and configurations | `modules/shell/` |
| **Fonts** | Icon-patched and programming fonts | `modules/fonts/` |
| **Prompt** | Terminal prompt themes | `modules/prompt/` |
| **Plugins** | ZSH plugins for enhanced functionality | `modules/plugins/` |
| **Utils** | CLI utilities and productivity tools | `modules/utils/` |

---

## Base Modules

### xcode-cli

**Xcode Command Line Tools** - Apple's essential development utilities.

#### What It Installs
- Git version control
- Make and build tools
- Compilers (gcc, clang)
- macOS SDK headers
- Developer utilities

#### Dependencies
- None (base requirement)

#### Installation
```bash
./modules/base/xcode-cli.sh install
```

#### Configuration
- None required
- Installs to: `/Library/Developer/CommandLineTools/`

#### Verification
```bash
xcode-select -p
# Output: /Library/Developer/CommandLineTools
```

#### Notes
- Required for Homebrew and most development tools
- May prompt for password (requires sudo)
- Can take 5-10 minutes depending on internet speed
- Automatic installation if missing when running main installer

#### Standalone Usage
```bash
# Check if already installed
./modules/base/xcode-cli.sh status

# Install
./modules/base/xcode-cli.sh install
```

---

### homebrew

**Homebrew** - The missing package manager for macOS.

#### What It Installs
- Homebrew package manager
- Homebrew core repository
- Sets up `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)

#### Dependencies
- xcode-cli

#### Installation
```bash
./modules/base/homebrew.sh install
```

#### Configuration
- Adds Homebrew to PATH in `.zshrc`
- Configures environment variables
- Disables analytics (optional)

#### Environment Variables
```bash
HOMEBREW_PREFIX        # /opt/homebrew or /usr/local
HOMEBREW_NO_ANALYTICS  # Set to 1 to disable telemetry
```

#### Common Commands
```bash
# Update Homebrew
brew update

# Upgrade all packages
brew upgrade

# Search for packages
brew search <package>

# Install a package
brew install <package>

# List installed packages
brew list

# Show package info
brew info <package>

# Cleanup old versions
brew cleanup
```

#### Verification
```bash
brew --version
brew doctor  # Check for issues
```

#### Notes
- Base requirement for all other modules
- Supports both Apple Silicon and Intel Macs
- Installation location differs by architecture

#### Standalone Usage
```bash
# Check status
./modules/base/homebrew.sh status

# Install
./modules/base/homebrew.sh install

# Help
./modules/base/homebrew.sh help
```

---

## Shell Modules

### oh-my-zsh

**Oh My Zsh** - Delightful ZSH configuration framework.

#### What It Installs
- Oh My Zsh framework (~/.oh-my-zsh)
- Default plugins: git
- Customization structure for themes and plugins
- Auto-update mechanism

#### Dependencies
- ZSH (pre-installed on macOS)
- Git (from xcode-cli)

#### Installation
```bash
./modules/shell/oh-my-zsh.sh install
```

#### Configuration

**Directory Structure:**
```
~/.oh-my-zsh/
├── custom/              # User customizations
│   ├── themes/          # Custom themes
│   └── plugins/         # Custom plugins
├── plugins/             # Built-in plugins
├── themes/              # Built-in themes
└── oh-my-zsh.sh        # Main script
```

**Enable Plugins in ~/.zshrc:**
```bash
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)
```

#### Built-in Plugins (Examples)
```bash
# Git shortcuts
plugins=(git)

# Docker commands
plugins=(docker docker-compose)

# Node.js utilities
plugins=(node npm yarn)

# Python helpers
plugins=(python pip virtualenv)

# macOS utilities
plugins=(macos brew)
```

#### Features
- **300+ plugins** for various tools and languages
- **150+ themes** for prompt customization
- **Auto-updates** with `omz update`
- **Plugin manager** built-in
- **Extensive aliases** for common commands

#### Common Commands
```bash
# Update Oh My Zsh
omz update

# Reload configuration
omz reload

# List plugins
ls ~/.oh-my-zsh/plugins

# List themes
ls ~/.oh-my-zsh/themes
```

#### Verification
```bash
# Check installation
echo $ZSH
# Output: /Users/yourusername/.oh-my-zsh

# Check version
omz version
```

#### Notes
- Creates backup of existing `.zshrc` as `.zshrc.pre-oh-my-zsh`
- Default theme is "robbyrussell"
- Updates available via `omz update` or automatically

#### Standalone Usage
```bash
# Check status
./modules/shell/oh-my-zsh.sh status

# Install
./modules/shell/oh-my-zsh.sh install

# Uninstall
./modules/shell/oh-my-zsh.sh uninstall
```

#### Resources
- [Official Website](https://ohmyz.sh/)
- [GitHub Repository](https://github.com/ohmyzsh/ohmyzsh)
- [Plugin List](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
- [Theme Gallery](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)

---

## Font Modules

### nerd-fonts

**Nerd Fonts** - Icon-patched fonts for enhanced terminal experience.

#### What It Installs
Patched fonts with icons from:
- Font Awesome
- Devicons
- Octicons
- Powerline symbols
- Material Design Icons
- Weather Icons
- And more...

#### Available Fonts
| Font | Best For | Features |
|------|----------|----------|
| **MesloLGS NF** | Powerlevel10k (recommended) | Perfect spacing, all icons |
| **JetBrains Mono NF** | Coding, ligatures | Ligatures, excellent readability |
| **Fira Code NF** | Programming ligatures | Coding ligatures, clean design |
| **Hack NF** | General use | Clear at small sizes |
| **Source Code Pro NF** | Adobe lovers | Professional, clean |
| **Ubuntu Mono NF** | Ubuntu fans | Geometric, friendly |
| **Cascadia Code NF** | Windows users | Microsoft design, ligatures |

#### Dependencies
- homebrew

#### Installation

**Quick Install (MesloLGS - Recommended):**
```bash
./modules/fonts/nerd-fonts.sh quick meslo
```

**Quick Install (JetBrains Mono):**
```bash
./modules/fonts/nerd-fonts.sh quick jetbrains
```

**Interactive Install (Choose from list):**
```bash
./modules/fonts/nerd-fonts.sh install
```

**Install All Popular Fonts:**
```bash
./modules/fonts/nerd-fonts.sh install all
```

#### Installation Locations
```
~/Library/Fonts/          # User fonts
/Library/Fonts/           # System fonts (if installed system-wide)
```

#### Font Configuration

**iTerm2:**
1. Preferences (`⌘,`)
2. Profiles → Text → Font
3. Click "Change Font"
4. Select "MesloLGS NF" (or your chosen font)
5. Recommended size: 12-14pt

**Terminal.app:**
1. Preferences (`⌘,`)
2. Profiles → Font → Change
3. Select Nerd Font
4. Size: 12-14pt

**VS Code:**
```json
{
  "terminal.integrated.fontFamily": "MesloLGS NF",
  "editor.fontFamily": "JetBrains Mono NF",
  "editor.fontLigatures": true
}
```

#### Font Testing
After installation, test icons in terminal:
```bash
echo ""           # Font Awesome icons
echo ""       # Devicons
echo ""     # Weather icons
echo "⚡"          # Powerline symbols
```

#### Verification
```bash
# List installed Nerd Fonts (macOS)
fc-list | grep -i "nerd font"

# Or check in Font Book app
open -a "Font Book"
```

#### Notes
- MesloLGS NF specifically designed for Powerlevel10k
- Nerd Fonts include thousands of glyphs
- Some fonts support ligatures (multi-character symbols)
- Requires terminal restart after installation

#### Standalone Usage
```bash
# Quick install MesloLGS
./modules/fonts/nerd-fonts.sh quick meslo

# Quick install JetBrains Mono
./modules/fonts/nerd-fonts.sh quick jetbrains

# Interactive selection
./modules/fonts/nerd-fonts.sh install

# Check status
./modules/fonts/nerd-fonts.sh status

# List available fonts
./modules/fonts/nerd-fonts.sh list
```

#### Resources
- [Nerd Fonts Website](https://www.nerdfonts.com/)
- [Font Previews](https://www.programmingfonts.org/)
- [GitHub Repository](https://github.com/ryanoasis/nerd-fonts)

---

## Prompt Themes

### powerlevel10k

**Powerlevel10k** - Lightning-fast, highly customizable ZSH theme.

#### What It Installs
- Powerlevel10k theme for ZSH
- Instant prompt feature for ultra-fast startup
- Extensive customization options
- Wizard for easy configuration

#### Dependencies
- oh-my-zsh
- nerd-fonts (recommended: MesloLGS NF)

#### Installation
```bash
./modules/prompt/powerlevel10k.sh install
```

#### Configuration

**Initial Configuration:**
```bash
p10k configure
```

This launches an interactive wizard that asks about:
- Prompt style (lean, classic, rainbow, pure)
- Character set (Unicode, ASCII)
- Prompt colors
- Show time, user, directory
- Git status format
- Command execution time
- And much more...

**Re-configure Anytime:**
```bash
p10k configure
```

**Configuration File:**
- `~/.p10k.zsh` - Your Powerlevel10k configuration

#### Features

**Instant Prompt:**
- Terminal ready in milliseconds
- No lag when opening new terminal

**Rich Information Display:**
- Git status (branch, dirty state, stash)
- Command execution time
- Exit code of last command
- Background jobs
- Current directory (with truncation)
- Python virtualenv
- Node.js version
- Ruby version
- And 100+ more segments

**Customization Options:**
```bash
# Edit ~/.p10k.zsh to customize

# Show/hide segments
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  # Exit code of last command
  command_execution_time  # Duration of last command
  background_jobs         # Presence of background jobs
  virtualenv              # Python virtualenv
  context                 # user@hostname
  time                    # Current time
)

# Customize colors
typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
typeset -g POWERLEVEL9K_DIR_BACKGROUND=234
```

#### Prompt Styles

**Lean:**
```
~/projects/terminal-customization main ❯
```

**Classic:**
```
┌─[user@hostname] ~/projects/terminal-customization main*
└─❯
```

**Rainbow:**
```
 user  ~/projects  main*  12:34:56
❯
```

#### Common Customizations

**Enable Transient Prompt (clean history):**
```bash
# Add to ~/.p10k.zsh
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
```

**Show Python Version:**
```bash
# Add 'pyenv' to right prompt segments
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(... pyenv ...)
```

**Hide Time:**
```bash
# Remove 'time' from right prompt segments
```

#### Verification
```bash
# Check if active
echo $POWERLEVEL9K_VERSION

# Check theme in use
echo $ZSH_THEME
# Output: powerlevel10k/powerlevel10k
```

#### Troubleshooting

**Icons not showing:**
- Ensure MesloLGS NF font is installed
- Set terminal font to "MesloLGS NF"
- Restart terminal

**Slow prompt:**
- Run `p10k configure` and enable Instant Prompt
- Disable unused segments

**Git status slow:**
- Adjust `POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY` in `~/.p10k.zsh`

#### Notes
- Fastest ZSH theme available
- Instant prompt renders in <1ms
- MesloLGS NF font strongly recommended
- Configuration persists in `~/.p10k.zsh`

#### Standalone Usage
```bash
# Install
./modules/prompt/powerlevel10k.sh install

# Check status
./modules/prompt/powerlevel10k.sh status

# Uninstall
./modules/prompt/powerlevel10k.sh uninstall
```

#### Resources
- [GitHub Repository](https://github.com/romkatv/powerlevel10k)
- [Configuration Guide](https://github.com/romkatv/powerlevel10k#configuration)
- [FAQ](https://github.com/romkatv/powerlevel10k#faq)

---

### starship

**Starship** - Minimal, blazing-fast, cross-shell prompt.

#### What It Installs
- Starship prompt binary
- Default minimal configuration
- Cross-shell compatibility

#### Dependencies
- homebrew
- nerd-fonts (optional, for icons)

#### Installation
```bash
./modules/prompt/starship.sh install
```

#### Configuration

**Configuration File:**
- `~/.config/starship.toml`

**Basic Configuration:**
```toml
# Get editor completions based on the config schema
"$schema" = 'https://starship.rs/config-schema.json'

# Use custom format
format = """
[┌───────────────────>](bold green)
[│](bold green)$directory$rust$package
[└─>](bold green) """

# Disable the blank line at the start of the prompt
add_newline = false

# Directory settings
[directory]
truncation_length = 3
truncate_to_repo = true
```

**Minimal Example:**
```toml
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

[directory]
style = "blue bold"

[git_branch]
style = "purple bold"
```

#### Features
- **Fast:** Written in Rust, optimized for speed
- **Cross-shell:** Works with ZSH, Bash, Fish, PowerShell
- **Minimal:** Only shows what you need
- **Extensible:** 100+ modules available
- **Smart:** Context-aware information display

#### Available Modules
```toml
# Language versions
[nodejs]
[python]
[rust]
[golang]
[ruby]

# Tools
[git_branch]
[git_status]
[docker_context]
[kubernetes]

# System info
[battery]
[memory_usage]
[time]
```

#### Presets
```bash
# View available presets
starship preset --list

# Use a preset
starship preset nerd-font-symbols -o ~/.config/starship.toml
starship preset tokyo-night -o ~/.config/starship.toml
```

Available presets:
- `nerd-font-symbols` - With icons
- `no-nerd-font` - ASCII only
- `bracketed-segments` - Bracketed style
- `plain-text-symbols` - No special characters
- `pure-preset` - Pure prompt clone
- `tokyo-night` - Tokyo Night theme

#### Common Customizations

**Show Command Duration:**
```toml
[cmd_duration]
min_time = 500
format = "took [$duration](bold yellow)"
```

**Show Time:**
```toml
[time]
disabled = false
format = '🕙[\[ $time \]](bold white) '
```

**Git Status Detail:**
```toml
[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
```

#### Verification
```bash
starship --version

# Test configuration
starship config
```

#### Troubleshooting

**Prompt not showing:**
```bash
# Ensure starship is in ~/.zshrc
eval "$(starship init zsh)"
```

**Icons not displaying:**
- Install a Nerd Font
- Use `no-nerd-font` preset

#### Notes
- Lighter and faster than Powerlevel10k
- Great for minimalists
- Cross-shell support
- Highly configurable via TOML

#### Standalone Usage
```bash
# Install
./modules/prompt/starship.sh install

# Check status
./modules/prompt/starship.sh status

# Uninstall
./modules/prompt/starship.sh uninstall
```

#### Resources
- [Official Website](https://starship.rs/)
- [Configuration Guide](https://starship.rs/config/)
- [Presets](https://starship.rs/presets/)

---

## ZSH Plugins

### zsh-autosuggestions

**Fish-like autosuggestions for ZSH** - Suggests commands as you type based on history.

#### What It Installs
- zsh-autosuggestions plugin
- Integration with Oh My Zsh

#### Dependencies
- oh-my-zsh

#### Installation
```bash
./modules/plugins/zsh-autosuggestions.sh install
```

#### Configuration

**Accept Suggestion:**
- `→` (Right arrow) - Accept full suggestion
- `CTRL-F` - Accept suggestion (alternative)
- `ALT-→` - Accept one word

**Suggestion Strategy:**
```bash
# Add to ~/.zshrc
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
```

**Customization:**
```bash
# Suggestion color (add to ~/.zshrc)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Disable for large buffers
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Manual fetch
bindkey '^[a' autosuggest-accept
```

#### Features
- Suggests from command history
- Non-intrusive gray text
- Smart completion
- Fast and asynchronous

#### Verification
```bash
# Type a command you've used before
# Should see gray suggestion

# Plugin enabled in ~/.zshrc
grep "zsh-autosuggestions" ~/.zshrc
```

#### Notes
- Learns from your command history
- Gray suggestions don't interfere with typing
- Combines with zsh-syntax-highlighting

#### Standalone Usage
```bash
./modules/plugins/zsh-autosuggestions.sh install
```

#### Resources
- [GitHub Repository](https://github.com/zsh-users/zsh-autosuggestions)

---

### zsh-syntax-highlighting

**Real-time syntax highlighting for ZSH commands.**

#### What It Installs
- zsh-syntax-highlighting plugin
- Integration with Oh My Zsh

#### Dependencies
- oh-my-zsh

#### Installation
```bash
./modules/plugins/zsh-syntax-highlighting.sh install
```

#### Features

**Highlighting Types:**
- **Green:** Valid commands
- **Red:** Invalid commands
- **Cyan:** Strings
- **Yellow:** Options/flags
- **Magenta:** Paths
- **Blue:** Aliases

**Benefits:**
- Catch typos before execution
- Visual feedback on command validity
- Identify strings and paths
- Recognize aliases

#### Configuration

**Custom Colors:**
```bash
# Add to ~/.zshrc after loading plugin
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=magenta,underline'
```

**Enable/Disable Highlighters:**
```bash
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
```

#### Verification
```bash
# Type a valid command - should turn green
ls

# Type invalid command - should turn red
lss

# Plugin loaded
echo $ZSH_HIGHLIGHT_VERSION
```

#### Notes
- Must be last plugin in `plugins=()` array
- Works in real-time as you type
- Low performance impact

#### Standalone Usage
```bash
./modules/plugins/zsh-syntax-highlighting.sh install
```

#### Resources
- [GitHub Repository](https://github.com/zsh-users/zsh-syntax-highlighting)

---

### zsh-completions

**Additional completion definitions for ZSH.**

#### What It Installs
- 100+ additional command completions
- Integration with ZSH completion system

#### Dependencies
- oh-my-zsh

#### Installation
```bash
./modules/plugins/zsh-completions.sh install
```

#### Features
- Docker completions
- Git completions
- npm/yarn completions
- Homebrew completions
- And 100+ more tools

#### Configuration

**Enable Completion:**
```bash
# Usually automatic, but ensure in ~/.zshrc:
autoload -U compinit && compinit
```

**Completion Cache:**
```bash
# Speed up completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
```

#### Usage
```bash
# Press TAB to complete commands
docker <TAB>
git <TAB>
npm <TAB>
```

#### Verification
```bash
# Check plugin loaded
echo $fpath | grep completions
```

#### Standalone Usage
```bash
./modules/plugins/zsh-completions.sh install
```

#### Resources
- [GitHub Repository](https://github.com/zsh-users/zsh-completions)

---

### zsh-history-substring-search

**Search command history by substring matching.**

#### What It Installs
- zsh-history-substring-search plugin
- Smart history navigation

#### Dependencies
- oh-my-zsh

#### Installation
```bash
./modules/plugins/zsh-history-substring-search.sh install
```

#### Features
- Search history with ↑ ↓
- Substring matching (not just prefix)
- Fuzzy search support
- Case-insensitive search

#### Usage
```bash
# Type part of a command
git

# Press ↑ to cycle through all commands containing "git"
# Press ↓ to go back
```

#### Configuration

**Keybindings:**
```bash
# Default: ↑ ↓
# Custom (add to ~/.zshrc):
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
```

**Case Sensitivity:**
```bash
# Case insensitive (add to ~/.zshrc)
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_FUZZY=1
```

#### Verification
```bash
# Type partial command and press ↑
# Should search through history
```

#### Standalone Usage
```bash
./modules/plugins/zsh-history-substring-search.sh install
```

#### Resources
- [GitHub Repository](https://github.com/zsh-users/zsh-history-substring-search)

---

## Utility Modules

### fzf

**Fuzzy Finder** - Command-line fuzzy finder for files, history, and more.

#### What It Installs
- fzf binary
- Shell key bindings
- Fuzzy completion

#### Dependencies
- homebrew

#### Installation
```bash
./modules/utils/fzf.sh install
```

#### Key Bindings
| Keybinding | Function |
|------------|----------|
| `CTRL-T` | Paste selected files onto command line |
| `CTRL-R` | Search command history |
| `ALT-C` | cd into selected directory |

#### Features
- Instant fuzzy search
- Real-time filtering
- Multi-select support
- Preview window
- Syntax highlighting with bat

#### Configuration

**Default Options:**
```bash
# Add to ~/.zshrc
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
```

**Use fd for faster file search:**
```bash
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
```

**Preview with bat:**
```bash
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"
```

#### Usage Examples

**Find Files:**
```bash
vim $(fzf)
```

**Search History:**
```bash
# Press CTRL-R in terminal
```

**Interactive cd:**
```bash
# Press ALT-C to fuzzy search directories
```

**Custom Aliases:**
```bash
# Fuzzy file preview
alias fp="fzf --preview 'bat --style=numbers --color=always {}'"

# Fuzzy cd
alias fcd='cd $(fd --type d | fzf)'

# Fuzzy history
alias fh='history | fzf --tac'
```

#### Advanced Usage

**Multi-Select:**
```bash
# TAB to select multiple files
rm $(fzf -m)
```

**With ripgrep:**
```bash
# Search file contents
rg --files-with-matches "pattern" | fzf --preview 'bat {}'
```

#### Verification
```bash
fzf --version

# Test keybinding
# Press CTRL-R
```

#### Standalone Usage
```bash
./modules/utils/fzf.sh install
./modules/utils/fzf.sh status
```

#### Resources
- [GitHub Repository](https://github.com/junegunn/fzf)
- [Advanced Usage](https://github.com/junegunn/fzf/wiki)

---

### bat

**A cat clone with syntax highlighting and Git integration.**

#### What It Installs
- bat binary
- Syntax themes
- Integration with fzf and other tools

#### Dependencies
- homebrew

#### Installation
```bash
./modules/utils/bat.sh install
```

#### Features
- Syntax highlighting for 200+ languages
- Git diff integration
- Automatic paging
- Line numbers
- Non-printable character visualization

#### Usage
```bash
# View file with syntax highlighting
bat file.js

# Show Git changes
bat --diff file.js

# Output for piping (no decorations)
bat --plain file.js

# Show all (including hidden chars)
bat --show-all file.txt
```

#### Configuration

**Set as default pager:**
```bash
# Add to ~/.zshrc
export PAGER="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```

**Custom theme:**
```bash
# List themes
bat --list-themes

# Set theme
export BAT_THEME="Nord"
```

**Config file:** `~/.config/bat/config`
```bash
--theme="Nord"
--style="numbers,changes,header"
--paging=auto
```

#### Aliases
```bash
# Use instead of cat
alias cat='bat'

# Quick preview
alias preview='bat --paging=never'
```

#### Verification
```bash
bat --version
bat README.md
```

#### Standalone Usage
```bash
./modules/utils/bat.sh install
```

#### Resources
- [GitHub Repository](https://github.com/sharkdp/bat)

---

### eza

**Modern replacement for ls with colors and icons.**

#### What It Installs
- eza binary (successor to exa)
- Colorful file listings
- Git integration

#### Dependencies
- homebrew
- nerd-fonts (for icons)

#### Installation
```bash
./modules/utils/eza.sh install
```

#### Features
- Colors for file types
- Nerd Font icons
- Git status integration
- Tree view
- Extended attributes
- Better defaults than ls

#### Usage
```bash
# Basic listing
eza

# Long format with icons
eza -la

# Tree view
eza --tree --level=2

# Git status in listing
eza -la --git

# Show file headers
eza -lh

# Sort by modified time
eza -la --sort=modified

# Show only directories
eza -D
```

#### Configuration

**Aliases:**
```bash
# Add to ~/.zshrc
alias ls='eza'
alias ll='eza -la'
alias lt='eza --tree --level=2'
alias lg='eza -la --git'
```

#### File Type Colors
- **Blue:** Directories
- **Green:** Executables
- **Red:** Archives
- **Yellow:** Images
- **Magenta:** Videos
- **Cyan:** Symlinks

#### Git Status Indicators
- `M` - Modified
- `N` - New file
- `I` - Ignored
- `U` - Updated but unmerged

#### Verification
```bash
eza --version
eza -la
```

#### Standalone Usage
```bash
./modules/utils/eza.sh install
```

#### Resources
- [GitHub Repository](https://github.com/eza-community/eza)

---

### ripgrep

**Ultra-fast grep alternative for searching code.**

#### What It Installs
- rg (ripgrep) binary
- Smart defaults for searching

#### Dependencies
- homebrew

#### Installation
```bash
./modules/utils/ripgrep.sh install
```

#### Features
- 10x faster than grep
- Respects .gitignore
- Recursive by default
- Syntax highlighting
- Multi-line search
- Regex patterns

#### Usage
```bash
# Search for pattern
rg "TODO"

# Search specific file types
rg "import" --type js

# Case insensitive
rg -i "error"

# Show context (3 lines before and after)
rg -C 3 "function"

# Search only filenames
rg --files | rg "test"

# Count matches
rg "import" --count

# Search hidden files
rg "pattern" --hidden

# Search with regex
rg "^fn\s+\w+"
```

#### Configuration

**Config file:** `~/.ripgreprc`
```bash
# Smart case (case-insensitive if all lowercase)
--smart-case

# Show line numbers
--line-number

# Follow symlinks
--follow

# Exclude directories
--glob=!.git/*
--glob=!node_modules/*
```

**Use config:**
```bash
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
```

#### File Types
```bash
# List supported types
rg --type-list

# Search JavaScript
rg "pattern" -t js

# Search Python
rg "pattern" -t py

# Multiple types
rg "pattern" -t js -t ts
```

#### Verification
```bash
rg --version
rg "import" --type js
```

#### Standalone Usage
```bash
./modules/utils/ripgrep.sh install
```

#### Resources
- [GitHub Repository](https://github.com/BurntSushi/ripgrep)
- [User Guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md)

---

### fd

**Simple, fast alternative to find.**

#### What It Installs
- fd binary
- Intuitive find replacement

#### Dependencies
- homebrew

#### Installation
```bash
./modules/utils/fd.sh install
```

#### Features
- Simple syntax
- Fast execution
- Colored output
- Smart case
- Respects .gitignore
- Parallel execution

#### Usage
```bash
# Find by name
fd pattern

# Find only files
fd pattern --type f

# Find only directories
fd pattern --type d

# Include hidden files
fd pattern --hidden

# Exclude pattern
fd pattern --exclude node_modules

# Execute command on results
fd ".*.js" --exec bat {}

# Search in specific directory
fd pattern /path/to/search

# Max depth
fd pattern --max-depth 2

# Show absolute paths
fd pattern --absolute-path
```

#### Configuration

**Aliases:**
```bash
# Quick find
alias f='fd'

# Find and edit
alias fe='fd --type f | fzf | xargs nvim'
```

#### File Type Shortcuts
```bash
# Executable files
fd --type x

# Empty files
fd --type e

# Symlinks
fd --type l
```

#### Integration with fzf
```bash
# Use fd with fzf for faster file search
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
```

#### Verification
```bash
fd --version
fd README
```

#### Standalone Usage
```bash
./modules/utils/fd.sh install
```

#### Resources
- [GitHub Repository](https://github.com/sharkdp/fd)

---

### zoxide

**Smarter cd command that learns your habits.**

#### What It Installs
- zoxide binary
- Shell integration
- Smart directory jumping

#### Dependencies
- homebrew

#### Installation
```bash
./modules/utils/zoxide.sh install
```

#### Features
- Learns frequently used directories
- Fuzzy matching
- Interactive selection with fzf
- Works across all shells
- Fast and lightweight

#### Usage
```bash
# Jump to a directory (fuzzy match)
z projects

# Interactive selection (requires fzf)
zi

# After using, zoxide remembers
cd ~/Documents/projects/terminal-customization
# Later:
z term
# Jumps to ~/Documents/projects/terminal-customization

# List database
zoxide query -l

# Remove entry
zoxide remove /path/to/dir
```

#### How It Works
1. Every `cd` command is tracked
2. Directories get a score based on "frecency" (frequency + recency)
3. `z` command matches scored directories

#### Configuration

**Aliases:**
```bash
# Already set by installer
alias z='zoxide'
alias zi='zoxide query -i'  # Interactive
```

**Custom matching:**
```bash
# Match by last component only
z <term>

# Match by full path
z full/path/to/dir
```

#### Integration
Works automatically after installation. Just use `cd` normally, and `z` becomes smarter over time.

#### Verification
```bash
# Check installation
zoxide --version

# View statistics
zoxide query -l -s
```

#### Standalone Usage
```bash
./modules/utils/zoxide.sh install
```

#### Resources
- [GitHub Repository](https://github.com/ajeetdsouza/zoxide)

---

### delta

**Syntax-highlighting pager for Git diffs.**

#### What It Installs
- delta binary
- Git configuration for beautiful diffs
- Syntax highlighting themes

#### Dependencies
- homebrew
- git

#### Installation
```bash
./modules/utils/delta.sh install
```

#### Features
- Syntax highlighting
- Side-by-side diffs
- Line numbers
- Git blame integration
- Customizable themes
- Better merge conflict display

#### Configuration

**Automatic (via installer):**
```gitconfig
# ~/.gitconfig
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true
    light = false
    line-numbers = true
    side-by-side = false

[merge]
    conflictstyle = diff3

[diff]
    colorMoved = default
```

**Manual theming:**
```bash
# List themes
delta --list-syntax-themes

# Use specific theme
git config delta.syntax-theme "Nord"
```

#### Usage
```bash
# Normal git commands now use delta
git diff
git log -p
git show
git blame file.js

# View diff side-by-side
git diff --side-by-side

# Disable delta temporarily
git --no-pager diff
```

#### Themes
Popular themes:
- Nord
- Dracula
- Monokai Extended
- OneHalfDark
- Solarized (dark/light)

#### Verification
```bash
delta --version
git diff
```

#### Standalone Usage
```bash
./modules/utils/delta.sh install
```

#### Resources
- [GitHub Repository](https://github.com/dandavison/delta)

---

### lazygit

**Terminal UI for Git commands.**

#### What It Installs
- lazygit binary
- Interactive Git interface
- Custom configuration

#### Dependencies
- homebrew
- git

#### Installation
```bash
./modules/utils/lazygit.sh install
```

#### Features
- Visual interface for Git
- Stage files with spacebar
- Create commits with `c`
- View diffs inline
- Branch management
- Merge conflict resolution
- Rebase support
- Cherry-pick
- Stash management

#### Usage
```bash
# Launch lazygit
lazygit

# Open in specific path
lazygit -p /path/to/repo
```

#### Interface Navigation

**Main Panels:**
- `1` - Status
- `2` - Files
- `3` - Branches
- `4` - Commits
- `5` - Stash

**Key Actions:**
| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `c` | Commit |
| `C` | Commit with editor |
| `P` | Push |
| `p` | Pull |
| `[` | Previous panel |
| `]` | Next panel |
| `x` | Open menu |
| `?` | Help |
| `q` | Quit |

**File Actions:**
- `a` - Stage all
- `A` - Unstage all
- `d` - Discard changes
- `e` - Edit file
- `o` - Open file

**Commit Actions:**
- `s` - Squash commit
- `r` - Reword commit
- `d` - Delete commit
- `p` - Pick commit (cherry-pick)

#### Configuration

**Config file:** `~/.config/lazygit/config.yml`

```yaml
gui:
  theme:
    lightTheme: false
    activeBorderColor:
      - green
      - bold
    inactiveBorderColor:
      - default
  scrollHeight: 2
  scrollPastBottom: true

git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
```

#### Verification
```bash
lazygit --version
lazygit
```

#### Standalone Usage
```bash
./modules/utils/lazygit.sh install
```

#### Resources
- [GitHub Repository](https://github.com/jesseduffield/lazygit)
- [Documentation](https://github.com/jesseduffield/lazygit/tree/master/docs)

---

### btop

**Resource monitor with beautiful interface.**

#### What It Installs
- btop binary
- System monitoring tool

#### Dependencies
- homebrew

#### Installation
```bash
./modules/utils/btop.sh install
```

#### Features
- CPU usage graphs
- Memory/swap usage
- Disk I/O statistics
- Network traffic
- Process list with filtering
- Themeable interface
- Mouse support

#### Usage
```bash
# Launch btop
btop
```

#### Interface

**Navigation:**
| Key | Action |
|-----|--------|
| `↑↓` | Navigate processes |
| `f` | Filter processes |
| `t` | Change sorting |
| `k` | Kill process |
| `+/-` | Increase/decrease update interval |
| `m` | Main menu |
| `q` | Quit |

**Tabs:**
- CPU graph and stats
- Memory usage
- Disk I/O
- Network traffic
- Process list

#### Configuration

**Config file:** `~/.config/btop/btop.conf`

```ini
# Theme
color_theme = "Default"

# Update interval (milliseconds)
update_ms = 2000

# Show temperatures
show_temps = true

# CPU graph type (line, block)
cpu_graph_upper = "total"
cpu_graph_lower = "total"
```

#### Themes
- Default
- TTY
- Nord
- Gruvbox Dark

#### Verification
```bash
btop --version
btop
```

#### Standalone Usage
```bash
./modules/utils/btop.sh install
```

#### Resources
- [GitHub Repository](https://github.com/aristocratos/btop)

---

### neofetch

**System information display with ASCII art.**

#### What It Installs
- neofetch binary
- macOS ASCII art
- Custom configuration

#### Dependencies
- homebrew

#### Installation
```bash
./modules/utils/neofetch.sh install
```

#### Features
- System information display
- macOS ASCII logo
- Customizable output
- Color themes
- Screenshot capture

#### Usage
```bash
# Display system info
neofetch

# Custom ASCII art
neofetch --source /path/to/ascii.txt

# Specific information only
neofetch --off

# No ASCII art
neofetch --off
```

#### Information Displayed
- OS version
- Kernel version
- Uptime
- Packages installed (Homebrew)
- Shell
- Resolution
- Terminal emulator
- CPU model
- GPU model
- Memory usage

#### Configuration

**Config file:** `~/.config/neofetch/config.conf`

```bash
# Information to display
print_info() {
    info title
    info underline

    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "Terminal" term
    info "CPU" cpu
    info "Memory" memory

    info cols
}

# Shorten output
kernel_shorthand="on"
os_arch="on"
```

#### Customization

**Change colors:**
```bash
# Color configuration in config.conf
ascii_distro="auto"
ascii_colors=(4 6 1 8 8 6)
```

**Add to shell startup:**
```bash
# Add to ~/.zshrc for greeting
neofetch
```

#### Verification
```bash
neofetch --version
neofetch
```

#### Standalone Usage
```bash
./modules/utils/neofetch.sh install
```

#### Resources
- [GitHub Repository](https://github.com/dylanaraps/neofetch)

---

## Core Libraries

The installer includes reusable core libraries located in `core/`:

### colors.sh
- Color definitions for terminal output
- ANSI color codes
- Text formatting (bold, dim, underline)

**Usage:**
```bash
source "${PROJECT_ROOT}/core/colors.sh"
echo -e "${GREEN}Success!${NC}"
echo -e "${BOLD}${CYAN}Information${NC}"
```

### ui.sh
- User interface components
- Headers, dividers, status messages
- Spinners and progress indicators
- Confirmation prompts

**Functions:**
```bash
print_header "Title"
print_success "Operation complete"
print_error "Failed"
print_warning "Warning message"
print_info "Information"
confirm "Are you sure?" [y/n]
print_step 1 5 "Step description"
```

### validators.sh
- System validation functions
- Command existence checks
- Internet connectivity
- macOS version detection

**Functions:**
```bash
is_macos
has_internet
command_exists <command>
get_macos_version
```

### installers.sh
- Installation helper functions
- Homebrew package management
- GitHub repository cloning
- Generic installation utilities

**Functions:**
```bash
install_with_brew <package> <cask_name>
install_from_github <user/repo> <dest_path>
get_brew_prefix
uninstall_brew <package>
```

### shell-config.sh
- Shell configuration management
- .zshrc manipulation
- Source file management
- Alias creation

**Functions:**
```bash
get_zshrc_path
add_to_zshrc <content> <description>
source_in_zshrc <file> <description>
add_alias_zshrc <alias_name> <alias_cmd> <description>
remove_from_zshrc <pattern> <mode>
```

---

## Creating Custom Modules

Want to add your own module? Follow this template:

### Module Template

```bash
#!/bin/bash
# =============================================================================
# Module Name - Brief Description
# DR Custom Terminal
# =============================================================================
# Detailed description of what this module does and why it's useful.
# =============================================================================

set -euo pipefail

# Get script directory for sourcing core libs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Source core libraries
source "${PROJECT_ROOT}/core/colors.sh"
source "${PROJECT_ROOT}/core/ui.sh"
source "${PROJECT_ROOT}/core/validators.sh"
source "${PROJECT_ROOT}/core/installers.sh"
source "${PROJECT_ROOT}/core/shell-config.sh"

# =============================================================================
# Module Metadata
# =============================================================================
MODULE_NAME="your-module"
MODULE_VERSION="1.0.0"
MODULE_DEPS=("brew" "other-dependency")

# =============================================================================
# Dependency Check
# =============================================================================
check_dependencies() {
    local has_errors=0

    for dep in "${MODULE_DEPS[@]}"; do
        if ! command_exists "$dep"; then
            print_error "Required dependency not found: $dep"
            has_errors=1
        fi
    done

    return $has_errors
}

# =============================================================================
# Installation Status Check
# =============================================================================
is_installed() {
    command_exists your-command
}

# =============================================================================
# Install Module
# =============================================================================
install() {
    print_divider "Installation"

    # Pre-flight checks
    print_step 1 3 "Checking prerequisites..."
    if ! has_internet; then
        print_error "No internet connection"
        return 1
    fi

    # Main installation
    print_step 2 3 "Installing ${MODULE_NAME}..."
    if ! install_with_brew "package-name" "your-command"; then
        print_error "Failed to install ${MODULE_NAME}"
        return 1
    fi

    # Post-installation
    print_step 3 3 "Configuring ${MODULE_NAME}..."
    configure

    return 0
}

# =============================================================================
# Configure Module
# =============================================================================
configure() {
    print_divider "Configuration"

    # Add configuration to .zshrc
    add_to_zshrc 'export YOUR_VAR="value"' "your-module configuration"

    # Add aliases
    add_alias_zshrc "ym" "your-command" "your-module shortcut"

    return 0
}

# =============================================================================
# Show Status
# =============================================================================
show_status() {
    print_divider "Current Status"

    if is_installed; then
        echo -e "  ${ICON_SUCCESS} ${GREEN}Installed${NC}"
        echo -e "  ${ICON_BULLET} Version: $(your-command --version)"
    else
        echo -e "  ${ICON_ERROR} ${RED}Not installed${NC}"
    fi

    echo ""
}

# =============================================================================
# Uninstall Module
# =============================================================================
uninstall() {
    print_divider "Uninstall ${MODULE_NAME}"

    if ! confirm "Are you sure?" "n"; then
        print_info "Uninstallation cancelled"
        return 0
    fi

    # Remove via Homebrew
    uninstall_brew "package-name"

    # Clean up configuration
    remove_from_zshrc "YOUR_VAR" "pattern"
    remove_from_zshrc "your-module" "pattern"

    print_success "${MODULE_NAME} uninstalled"
    return 0
}

# =============================================================================
# Show Help
# =============================================================================
show_help() {
    echo ""
    echo -e "${BOLD}${MODULE_NAME} Installer${NC}"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Install ${MODULE_NAME}"
    echo "  status      Show installation status"
    echo "  uninstall   Remove ${MODULE_NAME}"
    echo "  help        Show this help"
    echo ""
}

# =============================================================================
# Main Entry Point
# =============================================================================
main() {
    local command="${1:-install}"

    print_header "${MODULE_NAME} Installer"

    case "$command" in
        install)
            if ! check_dependencies; then
                print_error "Missing dependencies"
                exit 1
            fi

            if is_installed; then
                show_status
                if confirm "Reconfigure ${MODULE_NAME}?"; then
                    configure
                fi
                exit 0
            fi

            install
            ;;
        status)
            show_status
            ;;
        uninstall)
            if ! is_installed; then
                print_info "${MODULE_NAME} is not installed"
                exit 0
            fi
            uninstall
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $command"
            show_help
            exit 1
            ;;
    esac

    exit $?
}

# Run main if executed directly
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
```

### Module Guidelines

1. **Follow the structure:** Use the template above
2. **Source core libraries:** Use provided utilities
3. **Error handling:** Use `set -euo pipefail`
4. **Idempotent:** Safe to run multiple times
5. **Informative:** Use print functions for user feedback
6. **Dependencies:** Check and document all dependencies
7. **Cleanup:** Provide uninstall functionality
8. **Documentation:** Include help text

### Adding to the Installer

To include your module in the installation, add a `run_module` call to the `run_installation()` function in `install.sh`:

```bash
# In the appropriate phase section of run_installation():
run_module "${MODULES_UTILS}/your-module.sh" "Your Module"
```

---

## Additional Resources

- [Main README](../README.md) - Project overview
- [Troubleshooting Guide](TROUBLESHOOTING.md) - Common issues and solutions
- [GitHub Repository](https://github.com/yourusername/terminal-customization)

---

**Last Updated:** 2025-01-01
