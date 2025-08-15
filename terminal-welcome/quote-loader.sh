#!/usr/bin/env zsh
# ═══════════════════════════════════════════════════════════════════════════
# 💭 Quote Loader - High-performance quote system for terminal welcome
# ═══════════════════════════════════════════════════════════════════════════

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
QUOTES_DIR="${SCRIPT_DIR}/quotes.d"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/welcome-quotes"
CACHE_TTL=86400  # 24 hours for API cache
HISTORY_SIZE=10   # Number of quotes to remember to avoid repetition

# Create cache directory if it doesn't exist
[[ ! -d "$CACHE_DIR" ]] && mkdir -p "$CACHE_DIR"

# Function to load quotes from local files
load_local_quotes() {
    local category="${1:-tech}"
    local lang="${2:-en}"
    local quote_path="$QUOTES_DIR/$category/$lang"
    
    # Check if directory exists
    if [[ -d "$quote_path" ]]; then
        # Find all .txt files and concatenate them
        find "$quote_path" -type f -name "*.txt" 2>/dev/null | while read -r file; do
            # Skip empty files and comments (lines starting with #)
            grep -v '^#' "$file" 2>/dev/null | grep -v '^[[:space:]]*$' || true
        done
    fi
}

# Function to get quotes from all categories if specified
load_all_categories() {
    local lang="${1:-en}"
    local categories=("tech" "motivation" "humor" "chinese")
    
    for category in "${categories[@]}"; do
        load_local_quotes "$category" "$lang"
    done
}

# Function to select a quote avoiding recent repetition
select_quote() {
    local history_file="$CACHE_DIR/history.txt"
    local -a quotes
    local -a filtered_quotes
    
    # Read all quotes into array
    while IFS= read -r line; do
        [[ -n "$line" ]] && quotes+=("$line")
    done
    
    # If no quotes available, return default
    if [[ ${#quotes[@]} -eq 0 ]]; then
        echo "Code is poetry. 代码如诗。"
        return
    fi
    
    # Filter out recently used quotes if history exists
    if [[ -f "$history_file" ]] && [[ ${#quotes[@]} -gt $HISTORY_SIZE ]]; then
        # Read history into associative array for O(1) lookup
        typeset -A history_map
        while IFS= read -r line; do
            history_map["$line"]=1
        done < "$history_file"
        
        # Filter quotes not in history
        for quote in "${quotes[@]}"; do
            if [[ -z "${history_map[$quote]:-}" ]]; then
                filtered_quotes+=("$quote")
            fi
        done
        
        # Use filtered quotes if available, otherwise use all quotes
        if [[ ${#filtered_quotes[@]} -gt 0 ]]; then
            quotes=("${filtered_quotes[@]}")
        fi
    fi
    
    # Select random quote
    local selected="${quotes[$RANDOM % ${#quotes[@]}]}"
    
    # Update history (keep last N quotes)
    {
        echo "$selected"
        [[ -f "$history_file" ]] && tail -n $((HISTORY_SIZE - 1)) "$history_file" 2>/dev/null || true
    } > "$history_file.tmp"
    mv "$history_file.tmp" "$history_file"
    
    echo "$selected"
}

# Function to fetch quotes from API (optional, with caching)
fetch_api_quotes() {
    local api_cache="$CACHE_DIR/api_quotes.json"
    
    # Check if cache is still valid
    if [[ -f "$api_cache" ]]; then
        local cache_age=$(($(date +%s) - $(stat -f%m "$api_cache" 2>/dev/null || stat -c%Y "$api_cache" 2>/dev/null || echo 0)))
        if [[ $cache_age -lt $CACHE_TTL ]]; then
            # Cache is still valid, use it
            jq -r '.quotes[]' "$api_cache" 2>/dev/null || true
            return
        fi
    fi
    
    # Fetch new quotes from API (example with quotable.io)
    if command -v curl &>/dev/null && command -v jq &>/dev/null; then
        local api_response
        api_response=$(curl -s --max-time 2 "https://api.quotable.io/quotes?tags=technology&limit=20" 2>/dev/null || echo "{}")
        
        if [[ -n "$api_response" ]] && [[ "$api_response" != "{}" ]]; then
            # Cache the response
            echo "$api_response" > "$api_cache"
            # Extract quotes
            echo "$api_response" | jq -r '.results[].content' 2>/dev/null || true
        fi
    fi
}

# Main function
main() {
    # Get configuration from environment
    local category="${WELCOME_QUOTE_CATEGORY:-tech}"
    local lang="${WELCOME_QUOTE_LANG:-en}"
    local use_api="${WELCOME_QUOTE_USE_API:-false}"
    
    # Detect language from LANG environment variable if not set
    if [[ "$lang" == "en" ]] && [[ "${LANG:-}" == *"zh"* ]]; then
        lang="zh"
    fi
    
    # Collect quotes based on settings
    local quote_output=""
    
    if [[ "$category" == "all" ]]; then
        quote_output=$(load_all_categories "$lang")
    else
        quote_output=$(load_local_quotes "$category" "$lang")
    fi
    
    # Optionally add API quotes
    if [[ "$use_api" == "true" ]]; then
        local api_quotes
        api_quotes=$(fetch_api_quotes)
        if [[ -n "$api_quotes" ]]; then
            quote_output="${quote_output}${quote_output:+$'\n'}${api_quotes}"
        fi
    fi
    
    # Select and display a quote
    if [[ -n "$quote_output" ]]; then
        echo "$quote_output" | select_quote
    else
        # Fallback quotes if no quotes found
        local -a fallback_quotes=(
            "Code is poetry. 代码如诗。"
            "Make it work, make it right, make it fast."
            "Simplicity is the ultimate sophistication."
            "今天写点什么呢？"
            "让我们创造一些神奇的东西。"
        )
        echo "${fallback_quotes[$RANDOM % ${#fallback_quotes[@]}]}"
    fi
}

# Run main function with all arguments
main "$@"