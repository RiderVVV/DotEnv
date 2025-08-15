# ═══════════════════════════════════════════════════════════════════════════
# 🚀 Eric's Enhanced ZSH Configuration
# ═══════════════════════════════════════════════════════════════════════════


# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🔐 Secrets Loading (Must be first for security tokens)                 │
# └─────────────────────────────────────────────────────────────────────────┘
[[ -f ~/.zsh.secrets ]] && source ~/.zsh.secrets

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ ⚡ Powerlevel10k Instant Prompt (Must be early in config)              │
# └─────────────────────────────────────────────────────────────────────────┘
# Disable instant prompt to allow welcome screen display
# This trades startup speed for the ability to show the welcome screen
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
# Note: We've disabled instant prompt to allow the welcome screen to display
# If you want faster startup without welcome screen, change 'off' to 'quiet'

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🎨 Oh My ZSH Configuration                                             │
# └─────────────────────────────────────────────────────────────────────────┘
export ZSH="/Users/eric/.oh-my-zsh"

# Performance optimizations for large repositories
DISABLE_UNTRACKED_FILES_DIRTY="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

# Auto-update settings
DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=30

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🔌 Plugins Configuration                                               │
# └─────────────────────────────────────────────────────────────────────────┘
plugins=(
    git                      # Git aliases and functions
    docker                   # Docker autocomplete and aliases
    docker-compose          # Docker-compose support
    colored-man-pages       # Colorful man pages
    command-not-found       # Suggest package to install
    extract                 # Extract any archive with 'x'
    sudo                    # ESC twice = sudo last command
    web-search              # Search from terminal
    copypath                # Copy current path
    copyfile                # Copy file contents
    encode64                # Base64 encode/decode
    urltools                # URL encode/decode
    jsontools               # JSON pretty print
    zsh-autosuggestions     # Fish-like suggestions
    zsh-syntax-highlighting # Syntax highlighting (must be last)
)

source $ZSH/oh-my-zsh.sh

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🎨 Theme Configuration                                                 │
# └─────────────────────────────────────────────────────────────────────────┘
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🛠️ Development Environment                                             │
# └─────────────────────────────────────────────────────────────────────────┘

# === Go Configuration ===
export GOROOT=/usr/local/go
export GOPATH=$HOME/Dropbox/bin/go
export GO111MODULE=on

# === Python Configuration ===
alias python='python3'
alias pip='pip3'
alias py='python3'
alias ipy='ipython'
alias jup='jupyter notebook'
alias jlab='jupyter lab'

# === Node.js Configuration (Lazy Loading for Performance) ===
# NVM lazy loading - significantly improves shell startup time
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}
node() {
    unset -f node
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    node "$@"
}
npm() {
    unset -f npm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm "$@"
}
claude() {
    unset -f claude
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    claude "$@"
}

# === Bun Configuration ===
[ -s "/Users/eric/.bun/_bun" ] && source "/Users/eric/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"

# === Conda Configuration (Lazy Loading) ===
# Conda is loaded on-demand to improve startup time
init_conda() {
    __conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
}
alias conda='init_conda && conda'

# === Rust Configuration ===
export PATH="/usr/local/opt/rustup/bin:$PATH"

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🚀 Productivity Aliases                                                │
# └─────────────────────────────────────────────────────────────────────────┘

# === Enhanced ls Commands ===
alias ll='ls -lhF'                    # Long format with file size
alias la='ls -lahF'                   # Show hidden files
alias lt='ls -lhtrF'                  # Sort by modification time
alias lsize='ls -lhSrF'               # Sort by file size
alias ldot='ls -ld .*'                # List only dotfiles
alias ldir='ls -lhF | grep ^d'        # List only directories
alias tree='tree -C'                  # Colorized tree

# === Navigation Shortcuts ===
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'                     # Go to previous directory

# === File Operations ===
alias cp='cp -iv'                     # Interactive and verbose
alias mv='mv -iv'                     # Interactive and verbose
alias rm='rm -iv'                     # Interactive and verbose (safer)
alias mkdir='mkdir -pv'               # Create parent directories as needed
alias rmrf='rm -rf'                   # Force remove (use with caution!)

# === Quick Directory Creation and Navigation ===
mkcd() { mkdir -p "$1" && cd "$1"; }  # Make directory and cd into it
cdl() { cd "$1" && ls -la; }          # cd and list
backup() { cp -r "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"; }

# === Git Workflow Enhancements ===
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -v --amend'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gstash='git stash'
alias gpop='git stash pop'
alias greset='git reset --hard HEAD'
alias gclean='git clean -fd'

# Git commit with emoji
gcme() {
    local emoji_type=$1
    shift
    local message="$@"

    case $emoji_type in
        feat)    emoji="✨" ;;
        fix)     emoji="🐛" ;;
        docs)    emoji="📝" ;;
        style)   emoji="💄" ;;
        refactor) emoji="♻️" ;;
        perf)    emoji="⚡" ;;
        test)    emoji="✅" ;;
        build)   emoji="🔨" ;;
        ci)      emoji="👷" ;;
        chore)   emoji="🔧" ;;
        *)       emoji="🎉" ;;
    esac

    git commit -m "$emoji $message"
}

# === Docker Shortcuts ===
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias dexec='docker exec -it'
alias dlogs='docker logs -f'
alias dstop='docker stop $(docker ps -q)'
alias dclean='docker system prune -af'
alias dvolumes='docker volume ls'
alias dnetworks='docker network ls'

# Docker compose shortcuts
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dcl='docker-compose logs -f'
alias dcps='docker-compose ps'

# === System Monitoring ===
alias cpu='top -o cpu'                # Sort by CPU usage
alias mem='top -o mem'                # Sort by memory usage
alias ports='netstat -tulanp'         # Show open ports
alias myip='curl -s ifconfig.me'      # Show public IP
alias localip='ipconfig getifaddr en0' # Show local IP
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# === Development Tools ===
alias serve='python3 -m http.server'  # Quick HTTP server
alias json='python3 -m json.tool'     # Pretty print JSON
alias timestamp='date +%s'            # Current timestamp
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]"' # Generate UUID

# === Search and Find ===
alias ff='find . -type f -name'       # Find files
alias fd='find . -type d -name'       # Find directories
alias grep='grep --color=auto'        # Colorized grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias rg='rg --smart-case'           # Ripgrep with smart case

# === Process Management ===
alias ka='killall'
alias k9='kill -9'
pgrep() { ps aux | grep -v grep | grep "$@" -i --color=auto; }
pkill() { pgrep "$@" | awk '{print $2}' | xargs kill -9; }

# === Archive Operations ===
alias tarz='tar -czf'                 # Create tar.gz
alias tarx='tar -xzf'                 # Extract tar.gz
alias tarl='tar -tzf'                 # List tar.gz contents

# === Clipboard Operations ===
alias clip='pbcopy'                   # Copy to clipboard
alias paste='pbpaste'                 # Paste from clipboard

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🔧 Custom Functions                                                    │
# └─────────────────────────────────────────────────────────────────────────┘

# === Dotfiles Management ===
# Dotfiles management - using regular git in ~/.dotfiles directory
alias dots="cd ~/.dotfiles && git status"
alias dota="cd ~/.dotfiles && git add"
alias dotc="cd ~/.dotfiles && git commit -m"
alias dotp="cd ~/.dotfiles && git push"

# === Enhanced cd with auto ls ===
cd() {
    builtin cd "$@" && ls -F
}

# === Extract any archive ===
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# === Show directory size ===
dirsize() {
    du -sh ${1:-.} | cut -f1
}

# === Create a data URL from a file ===
dataurl() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# === Get weather ===
weather() {
    local location="${1:-Beijing}"
    curl -s "wttr.in/${location}?format=3"
}

# === Show PATH in readable format ===
path() {
    echo $PATH | tr ':' '\n' | nl
}

# === Quick notes ===
note() {
    local notes_dir="$HOME/notes"
    mkdir -p "$notes_dir"
    local note_file="$notes_dir/$(date +%Y-%m-%d).md"

    if [ $# -eq 0 ]; then
        ${EDITOR:-vim} "$note_file"
    else
        echo "$(date +%H:%M:%S) - $*" >> "$note_file"
        echo "Note added to $note_file"
    fi
}

# === Quick todo ===
todo() {
    local todo_file="$HOME/.todo.md"

    if [ $# -eq 0 ]; then
        if [ -f "$todo_file" ]; then
            cat "$todo_file"
        else
            echo "No todos yet!"
        fi
    else
        echo "- [ ] $*" >> "$todo_file"
        echo "Todo added!"
    fi
}

# === Server Login Functions ===
function wise() {
    /Users/eric/login_wise.sh wise "$@"
}

function maa() {
    /Users/eric/login_wise.sh maa "$@"
}

function test() {
    /Users/eric/login_wise.sh test "$@"
}

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🎯 FZF Configuration (if installed)                                    │
# └─────────────────────────────────────────────────────────────────────────┘
if command -v fzf >/dev/null 2>&1; then
    # FZF default options
    export FZF_DEFAULT_OPTS='
        --height 60%
        --layout=reverse
        --border
        --preview-window=right:60%:wrap
        --bind="ctrl-d:preview-page-down,ctrl-u:preview-page-up"
    '

    # Use fd for file search if available
    if command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi

    # Preview files with bat if available, otherwise cat
    if command -v bat >/dev/null 2>&1; then
        export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    else
        export FZF_CTRL_T_OPTS="--preview 'cat {}'"
    fi

    # cd into selected directory
    fcd() {
        local dir
        dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
        cd "$dir"
    }

    # Kill process
    fkill() {
        local pid
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

        if [ "x$pid" != "x" ]; then
            echo $pid | xargs kill -${1:-9}
        fi
    }

    # Git branch selection
    fbr() {
        local branches branch
        branches=$(git branch --all | grep -v HEAD) &&
        branch=$(echo "$branches" | fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
        git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    }
fi

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 📊 ZSH Options & Settings                                              │
# └─────────────────────────────────────────────────────────────────────────┘

# History configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format
setopt INC_APPEND_HISTORY        # Write to the history file immediately
setopt SHARE_HISTORY            # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS         # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS    # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS       # Do not display a line previously found
setopt HIST_IGNORE_SPACE       # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS      # Remove superfluous blanks before recording entry

# Directory navigation
setopt AUTO_CD                  # Auto cd into directory by typing its name
setopt AUTO_PUSHD              # Push the current directory visited on the stack
setopt PUSHD_IGNORE_DUPS       # Do not store duplicates in the stack
setopt PUSHD_SILENT           # Do not print the directory stack after pushd or popd

# Completion options
setopt ALWAYS_TO_END           # Move cursor to the end of a completed word
setopt AUTO_MENU              # Show completion menu on successive tab press
setopt AUTO_LIST              # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH       # Add a trailing slash for directory completions
setopt COMPLETE_IN_WORD       # Allow completion from within a word/phrase
setopt MENU_COMPLETE          # Autoselect the first completion entry

# Misc options
setopt INTERACTIVE_COMMENTS    # Allow comments in interactive shell
setopt NO_BEEP                # Don't beep on errors

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🌈 Syntax Highlighting Customization                                   │
# └─────────────────────────────────────────────────────────────────────────┘
# Customize colors for zsh-syntax-highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=blue,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=magenta,bold'

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🔄 Auto-suggestions Configuration                                      │
# └─────────────────────────────────────────────────────────────────────────┘
# Customize auto-suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🛣️ PATH Configuration (Deduplicated)                                   │
# └─────────────────────────────────────────────────────────────────────────┘
# Build PATH (avoiding duplicates)
typeset -U path
path=(
    $HOME/go/bin
    $GOROOT/bin
    $GOPATH/bin
    $HOME/Dropbox/bin/bin
    $HOME/.local/bin
    $HOME/Library/Python/3.9/bin
    $BUN_INSTALL/bin
    /Users/eric/.codeium/windsurf/bin
    /usr/local/opt/rustup/bin
    $path
)
export PATH

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🔧 Tool Integrations                                                   │
# └─────────────────────────────────────────────────────────────────────────┘

# Zoxide (better cd)
eval "$(zoxide init zsh)"

# Custom z function wrapper for better usability
z() {
    if [ $# -eq 0 ]; then
        # No arguments: show frecent directories
        zoxide query -l | head -20
    else
        # With arguments: use __zoxide_z function created by init
        __zoxide_z "$@"
    fi
}

# Interactive selection with fzf
zi() {
    __zoxide_zi "$@"
}

# Claude Code settings
export BASH_MAX_TIMEOUT_MS=1200000    # 20 minutes
export BASH_DEFAULT_TIMEOUT_MS=600000 # 10 minutes
alias yolo="claude --dangerously-skip-permissions"

# Kiro terminal integration
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🎉 Welcome Message                                                     │
# └─────────────────────────────────────────────────────────────────────────┘
# Tips array for reference (use 'tips' command to show a random tip)
tips=(
    "💡 Use 'extract' to extract any archive format"
    "💡 Press ESC twice to add sudo to the last command"
    "💡 Use 'z <partial-path>' to jump to frequently used directories"
    "💡 Type 'weather' to check the weather forecast"
    "💡 Use 'mkcd' to create and enter a directory in one command"
    "💡 Press Ctrl+R to search command history with fzf"
    "💡 Use 'gcme feat \"message\"' for emoji git commits"
    "💡 Type 'todo' to manage your quick todos"
    "💡 Use 'note' to take quick timestamped notes"
    "💡 Type 'path' to see your PATH in a readable format"
)

# Command to show a random tip
alias tip='echo "${tips[$RANDOM % ${#tips[@]}]}"'

# Welcome screen command
alias welcome='source ~/.dotfiles/terminal-welcome/welcome.sh'  # Manual welcome display

# ┌─────────────────────────────────────────────────────────────────────────┐
# │ 🎉 Terminal Welcome Screen (Shows on every terminal)                   │
# └─────────────────────────────────────────────────────────────────────────┘
# Display welcome screen for every new terminal session
# P10k instant prompt is disabled to allow this to work properly
if [[ $- == *i* ]] && [[ -z "$WELCOME_SHOWN" ]]; then
    export WELCOME_SHOWN=1
    source ~/.dotfiles/terminal-welcome/welcome.sh
fi

# ═══════════════════════════════════════════════════════════════════════════
# 🎯 Configuration Complete!
# ═══════════════════════════════════════════════════════════════════════════
