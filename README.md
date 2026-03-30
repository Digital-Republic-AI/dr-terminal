<p align="center">
  <img src="https://img.shields.io/badge/macOS-10.15+-blue?style=for-the-badge&logo=apple&logoColor=white" alt="macOS">
  <img src="https://img.shields.io/badge/Shell-Bash%20%7C%20ZSH-green?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Shell">
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/badge/Version-1.1.0-purple?style=for-the-badge" alt="Version">
</p>

<h1 align="center">
  <br>
  🖥️ DR Custom Terminal
  <br>
</h1>

<h4 align="center">Transforme seu terminal macOS de básico para brilhante em minutos.</h4>

<p align="center">
  <a href="#-início-rápido">Início Rápido</a> •
  <a href="#-o-que-será-instalado">Componentes</a> •
  <a href="#-ferramentas-incluídas">Ferramentas</a> •
  <a href="#-guia-de-uso">Guia de Uso</a> •
  <a href="#-estrutura-do-projeto">Estrutura</a>
</p>

---

## 🎯 O Que é Este Projeto?

O **DR Custom Terminal** é um toolkit modular completo para personalizar seu terminal macOS. Ele instala e configura automaticamente:

- **Shell Framework** - Oh My ZSH com plugins poderosos
- **Fontes com Ícones** - Nerd Fonts para visual rico
- **Temas de Prompt** - Powerlevel10k ou Starship
- **Ferramentas CLI Modernas** - Substitutos superiores para comandos clássicos

### Por que usar?

| Problema | Solução |
|----------|---------|
| Terminal feio e sem cor | Temas bonitos + sintaxe colorida |
| `ls` básico sem informações | `eza` com ícones, cores e status Git |
| `cat` sem destaque de código | `bat` com syntax highlighting |
| Buscar arquivos é lento | `fd` + `fzf` = busca instantânea |
| Histórico difícil de navegar | Busca fuzzy com `CTRL-R` |
| Git na linha de comando é tedioso | `lazygit` com interface visual |

---

## 🚀 Início Rápido

```bash
git clone https://github.com/yourusername/terminal-customization.git && cd terminal-customization && ./install.sh
```

---

## 📦 O que será instalado

O instalador configura automaticamente todos os componentes abaixo:

```
Base Components          Shell e Prompt            Plugins ZSH
  Xcode CLI Tools          Oh My ZSH                autosuggestions
  Homebrew                 MesloLGS Nerd Font       syntax-highlighting
                           Powerlevel10k            completions
                                                    history-search

CLI Utilities
  fzf        Busca fuzzy          bat     cat melhor
  eza        ls moderno           ripgrep grep rápido
  fd         find simples         zoxide  cd esperto
  delta      diff bonito          lazygit Git visual
```

---

## 🛠️ Ferramentas Incluídas

### 📝 Shell e Prompt

<table>
<tr>
<td width="50%">

#### Oh My ZSH
Framework de configuração para ZSH com 300+ plugins e temas.

**O que faz:**
- Gerencia plugins e temas
- Fornece aliases úteis
- Auto-updates automáticos

**Como usar:**
```bash
# Ver plugins ativos
echo $plugins

# Atualizar Oh My ZSH
omz update
```

</td>
<td width="50%">

#### Powerlevel10k
Tema de prompt extremamente rápido e customizável.

**O que faz:**
- Mostra branch Git atual
- Indica status do último comando
- Exibe linguagem/versão do projeto

**Como usar:**
```bash
# Configurar visual do prompt
p10k configure

# Editar configuração
nano ~/.p10k.zsh
```

</td>
</tr>
</table>

---

### 🔍 Busca e Navegação

<table>
<tr>
<td width="50%">

#### fzf - Fuzzy Finder
Busca interativa para qualquer coisa.

**O que faz:**
- Busca arquivos instantaneamente
- Navega no histórico de comandos
- Filtra qualquer lista

**Atalhos:**
| Tecla | Ação |
|-------|------|
| `CTRL-R` | Buscar no histórico |
| `CTRL-T` | Buscar arquivos |
| `ALT-C` | Navegar para pasta |

**Exemplos:**
```bash
# Buscar e abrir arquivo no vim
vim $(fzf)

# Buscar no histórico
CTRL-R → digite parte do comando

# Preview de arquivos
fzf --preview 'bat {}'
```

</td>
<td width="50%">

#### zoxide - CD Inteligente
Navegação de diretórios que aprende seus hábitos.

**O que faz:**
- Lembra diretórios visitados
- Pula para pastas por nome parcial
- Ranking por frequência de uso

**Exemplos:**
```bash
# Ir para ~/Projects/my-app
z my-app

# Ir para ~/Documents/work/reports
z reports

# Seleção interativa
zi

# Ver diretórios mais usados
zoxide query -l
```

**Dica:** Após usar, `z` sabe onde você quer ir!

</td>
</tr>
</table>

---

### 📂 Visualização de Arquivos

<table>
<tr>
<td width="50%">

#### bat - Cat com Superpoderes
Visualizador de arquivos com syntax highlighting.

**O que faz:**
- Destaque de sintaxe automático
- Números de linha
- Integração com Git (mostra alterações)
- Paginação automática

**Exemplos:**
```bash
# Ver arquivo com destaque
bat arquivo.js

# Ver diferenças do Git
bat --diff arquivo.js

# Mostrar apenas linhas 10-20
bat -r 10:20 arquivo.py

# Tema diferente
bat --theme="Dracula" arquivo.rs

# Listar temas disponíveis
bat --list-themes
```

</td>
<td width="50%">

#### eza - LS Moderno
Substituto do `ls` com cores, ícones e mais.

**O que faz:**
- Ícones para tipos de arquivo
- Cores por tipo/permissão
- Status Git integrado
- Vista em árvore

**Exemplos:**
```bash
# Lista detalhada com ícones
eza -la

# Vista em árvore (2 níveis)
eza --tree --level=2

# Com status Git
eza -la --git

# Ordenar por modificação
eza -la --sort=modified

# Apenas diretórios
eza -la --only-dirs
```

**Aliases úteis (já configurados):**
```bash
ll    # eza -la
la    # eza -a
lt    # eza --tree
```

</td>
</tr>
</table>

---

### 🔎 Busca em Arquivos

<table>
<tr>
<td width="50%">

#### ripgrep (rg) - Grep Ultra-rápido
Busca em arquivos 10x mais rápida que grep.

**O que faz:**
- Busca recursiva por padrão
- Ignora .gitignore automaticamente
- Suporte a regex
- Destaque de matches

**Exemplos:**
```bash
# Buscar "TODO" em todos arquivos
rg "TODO"

# Buscar em tipo específico
rg "import" --type js

# Case insensitive
rg -i "error"

# Mostrar contexto (3 linhas)
rg -C 3 "function"

# Buscar palavra exata
rg -w "test"

# Contar ocorrências
rg -c "console.log"

# Listar arquivos que contêm
rg -l "useState"
```

</td>
<td width="50%">

#### fd - Find Simplificado
Alternativa ao `find` com sintaxe amigável.

**O que faz:**
- Sintaxe simples e intuitiva
- Ignora .gitignore automaticamente
- Busca colorida
- Muito mais rápido que `find`

**Exemplos:**
```bash
# Buscar por nome
fd "readme"

# Buscar por extensão
fd -e js

# Buscar apenas diretórios
fd -t d "src"

# Buscar arquivos ocultos
fd -H ".env"

# Executar comando em resultados
fd -e jpg -x convert {} {.}.png

# Buscar com regex
fd "^test.*\.js$"

# Excluir diretório
fd -E node_modules "config"
```

</td>
</tr>
</table>

---

### 🔀 Git Avançado

<table>
<tr>
<td width="50%">

#### delta - Diff Bonito
Diffs do Git com syntax highlighting.

**O que faz:**
- Cores por linguagem
- Números de linha
- Navegação lado a lado
- Integração com Git

**Já configurado automaticamente!**

```bash
# Ver diff com cores
git diff

# Ver log com diff
git log -p

# Comparar branches
git diff main..feature
```

**Recursos visuais:**
- Linhas adicionadas em verde
- Linhas removidas em vermelho
- Destaque de sintaxe da linguagem

</td>
<td width="50%">

#### lazygit - Git Visual
Interface TUI completa para Git.

**O que faz:**
- Stage/unstage visual
- Commits interativos
- Navegação de branches
- Resolução de conflitos
- Cherry-pick, rebase, etc.

**Como usar:**
```bash
# Abrir interface
lazygit
```

**Atalhos principais:**
| Tecla | Ação |
|-------|------|
| `Space` | Stage/unstage arquivo |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `b` | Ver branches |
| `?` | Ajuda |
| `q` | Sair |

</td>
</tr>
</table>

---

### 📊 Sistema e Monitoramento

<table>
<tr>
<td width="50%">

#### btop - Monitor de Recursos
Monitor de sistema com interface gráfica no terminal.

**O que faz:**
- CPU, RAM, Disco, Rede
- Gráficos em tempo real
- Lista de processos
- Kill de processos

**Como usar:**
```bash
# Abrir monitor
btop
```

**Atalhos:**
| Tecla | Ação |
|-------|------|
| `m` | Menu |
| `k` | Kill processo |
| `f` | Filtrar |
| `q` | Sair |

</td>
<td width="50%">

#### neofetch - Info do Sistema
Exibe informações do sistema com estilo.

**O que faz:**
- Logo do macOS em ASCII
- Versão do sistema
- Hardware
- Uptime, pacotes, shell

**Como usar:**
```bash
# Mostrar info
neofetch

# Com logo pequeno
neofetch --ascii_distro mac_small
```

**Dica:** Adicione ao `.zshrc` para ver ao abrir terminal:
```bash
echo "neofetch" >> ~/.zshrc
```

</td>
</tr>
</table>

---

### ⚡ Plugins ZSH

| Plugin | O que faz | Como funciona |
|--------|-----------|---------------|
| **autosuggestions** | Sugere comandos baseado no histórico | Digite e veja sugestão em cinza, `→` para aceitar |
| **syntax-highlighting** | Colore comandos em tempo real | Vermelho = erro, verde = válido |
| **completions** | Autocomplete avançado | `Tab` para ver opções |
| **history-substring-search** | Busca no histórico por substring | `↑` `↓` após digitar parte do comando |

---

## 🎨 Temas de Cores

Instale temas de cores para seu terminal:

```bash
# Dracula - Roxo escuro elegante
./themes/color-schemes/dracula.sh

# Catppuccin - Tons pastel suaves
./themes/color-schemes/catppuccin.sh

# Gruvbox - Retro quente
./themes/color-schemes/gruvbox.sh

# Nord - Azul ártico
./themes/color-schemes/nord.sh
```

---

## 🔧 Gerenciamento de Módulos

Cada módulo pode ser gerenciado individualmente:

```bash
# ┌─────────────────────────────────────────────────┐
# │ Comandos disponíveis para cada módulo           │
# └─────────────────────────────────────────────────┘

# Instalar
./modules/utils/fzf.sh install

# Ver status
./modules/utils/fzf.sh status

# Desinstalar
./modules/utils/fzf.sh uninstall

# Ajuda
./modules/utils/fzf.sh help
```

### Módulos Disponíveis

```
modules/
├── base/
│   ├── xcode-cli.sh      # Xcode Command Line Tools
│   └── homebrew.sh       # Gerenciador de pacotes
├── shell/
│   └── oh-my-zsh.sh      # Framework ZSH
├── fonts/
│   └── nerd-fonts.sh     # Fontes com ícones
├── prompt/
│   ├── powerlevel10k.sh  # Tema de prompt
│   └── starship.sh       # Prompt alternativo
├── plugins/
│   ├── zsh-autosuggestions.sh
│   ├── zsh-syntax-highlighting.sh
│   ├── zsh-completions.sh
│   └── zsh-history-substring-search.sh
└── utils/
    ├── fzf.sh            # Fuzzy finder
    ├── bat.sh            # Cat melhorado
    ├── eza.sh            # Ls moderno
    ├── ripgrep.sh        # Grep rápido
    ├── fd.sh             # Find simples
    ├── zoxide.sh         # Cd inteligente
    ├── delta.sh          # Diff bonito
    ├── lazygit.sh        # Git visual
    ├── btop.sh           # Monitor sistema
    └── neofetch.sh       # Info sistema
```

---

## 📁 Estrutura do Projeto

```
terminal-customization/
│
├── install.sh              # 🚀 Instalador principal
├── custom-startup.sh       # ⚙️  Configurações de startup
│
├── core/                   # 🔧 Bibliotecas core
│   ├── colors.sh           #    Definições de cores ANSI
│   ├── ui.sh               #    Componentes de UI (headers, spinners)
│   ├── validators.sh       #    Funções de validação
│   ├── shell-config.sh     #    Helpers de configuração shell
│   └── installers.sh       #    Wrappers de instalação
│
├── modules/                # 📦 Módulos de instalação
│   ├── base/               #    Componentes base
│   ├── shell/              #    Frameworks de shell
│   ├── fonts/              #    Fontes
│   ├── prompt/             #    Temas de prompt
│   ├── plugins/            #    Plugins ZSH
│   └── utils/              #    Utilitários CLI
│
├── themes/                 # 🎨 Customização visual
│   ├── ascii-art/          #    Arte ASCII
│   └── color-schemes/      #    Esquemas de cores
│
└── docs/                   # 📚 Documentação
    ├── MODULES.md          #    Documentação detalhada
    └── TROUBLESHOOTING.md  #    Solução de problemas
```

---

## ⚙️ Pós-Instalação

### 1. Reinicie o Terminal
```bash
source ~/.zshrc
# ou simplesmente feche e abra novamente
```

### 2. Configure o Powerlevel10k
```bash
p10k configure
```

### 3. Configure a Fonte no Terminal

**iTerm2:**
1. `⌘,` → Preferences
2. Profiles → Text → Font
3. Selecione **MesloLGS NF**

**Terminal.app:**
1. `⌘,` → Preferences
2. Profiles → Font → Change
3. Selecione **MesloLGS NF**

**VS Code Terminal:**
```json
{
  "terminal.integrated.fontFamily": "MesloLGS NF"
}
```

---

## 📋 Requisitos

| Requisito | Mínimo |
|-----------|--------|
| **Sistema** | macOS 10.15 (Catalina)+ |
| **Shell** | Bash 3.2+ (para instalador) |
| **Espaço** | ~500MB |
| **Internet** | Necessária |

---

## 🐛 Solução de Problemas

### Ícones não aparecem
→ Configure a fonte **MesloLGS NF** no seu terminal

### Cores estranhas
→ Verifique se o terminal suporta 256 cores:
```bash
echo $TERM  # Deve mostrar xterm-256color
```

### Comando não encontrado
→ Recarregue o shell:
```bash
source ~/.zshrc
```

### Ver log de instalação
```bash
cat .install.log
```

Para mais problemas, veja [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

---

## 📄 Licença

MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

<p align="center">
  <a href="#-terminal-customization-gallery">⬆️ Voltar ao topo</a>
</p>
