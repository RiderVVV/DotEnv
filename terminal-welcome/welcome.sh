#!/usr/bin/env zsh
# ═══════════════════════════════════════════════════════════════════════════
# 🚀 Terminal Welcome - Main Integration Script
# ═══════════════════════════════════════════════════════════════════════════

# Exit if not interactive shell
[[ $- != *i* ]] && return

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)"
FASTFETCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch/config.jsonc"
FASTFETCH_PRESETS="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch/presets"
QUOTE_LOADER="${SCRIPT_DIR}/quote-loader.sh"

# Check if welcome should be disabled
[[ "${WELCOME_DISABLED}" == "true" ]] && return

# Function to detect environment
detect_environment() {
    local env="standard"
    
    # Check if SSH session
    if [[ -n "${SSH_CLIENT}" ]] || [[ -n "${SSH_TTY}" ]]; then
        env="minimal"
    fi
    
    # Check if in Docker container
    if [[ -f /.dockerenv ]] || grep -q docker /proc/1/cgroup 2>/dev/null; then
        env="minimal"
    fi
    
    # Check terminal width
    local cols=$(tput cols 2>/dev/null || echo 80)
    if [[ $cols -lt 80 ]]; then
        env="minimal"
    elif [[ $cols -gt 120 ]]; then
        env="detailed"
    fi
    
    # Allow environment variable override
    echo "${WELCOME_PRESET:-$env}"
}

# Function to check if in git repository
is_git_repo() {
    git rev-parse --git-dir &>/dev/null
}

# Function to get git status summary
git_status_line() {
    if is_git_repo; then
        local branch=$(git branch --show-current 2>/dev/null || echo "detached")
        local changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        local ahead_behind=$(git status -sb 2>/dev/null | head -1 | grep -oE '\[.*\]' || echo "")
        
        local status_color="\033[0;32m"  # Green for clean
        local status_symbol="✓"
        
        if [[ $changes -gt 0 ]]; then
            status_color="\033[0;33m"  # Yellow for changes
            status_symbol="±${changes}"
        fi
        
        echo -e "  \033[0;35m󰊢\033[0m ${branch} ${status_color}${status_symbol}\033[0m ${ahead_behind}"
    fi
}

# Main welcome function
show_welcome() {
    local preset=$(detect_environment)
    local config_file="${FASTFETCH_CONFIG}"
    
    # Use preset if available
    if [[ -f "${FASTFETCH_PRESETS}/${preset}.jsonc" ]]; then
        config_file="${FASTFETCH_PRESETS}/${preset}.jsonc"
    fi
    
    # Clear screen for better presentation (optional)
    # clear
    
    # Show system info with fastfetch
    if command -v fastfetch &>/dev/null; then
        fastfetch --config "${config_file}" 2>/dev/null || fastfetch
    else
        # Fallback to basic info if fastfetch not available
        echo "  System: $(uname -s) $(uname -r)"
        echo "  Shell: ${SHELL##*/}"
        echo "  User: ${USER}@$(hostname -s)"
    fi
    
    # Add separator
    echo ""
    
    # Show git status if in repository
    local git_line=$(git_status_line)
    [[ -n "$git_line" ]] && echo "$git_line" && echo ""
    
    # Show quote
    if [[ -x "${QUOTE_LOADER}" ]]; then
        local quote=$("${QUOTE_LOADER}" 2>/dev/null)
        if [[ -n "$quote" ]]; then
            # Format quote with nice presentation
            echo "  ╭────────────────────────────────────────────────────╮"
            # Wrap quote to fit in box (50 chars width)
            echo "$quote" | fold -s -w 50 | while IFS= read -r line; do
                printf "  │ %-50s │\n" "$line"
            done
            echo "  ╰────────────────────────────────────────────────────╯"
            echo ""
        fi
    fi
    
    # Show quick tips if enabled
    if [[ "${WELCOME_SHOW_TIPS}" == "true" ]]; then
        echo "  💡 Quick commands: z <dir> | ll | gs | gd | tip"
        echo ""
    fi
    
    # Show date and time
    echo "  📅 $(date '+%A, %B %d, %Y @ %H:%M:%S')"
    echo ""
}

# Run the welcome screen
show_welcome