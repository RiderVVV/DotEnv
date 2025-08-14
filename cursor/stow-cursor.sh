#!/usr/bin/env bash

# Cursor 配置文件路径有空格，需要特殊处理
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
CURSOR_CONFIG_DIR="$HOME/.config/cursor"

case "$1" in
    "link"|"install")
        echo "创建 Cursor 配置的符号链接..."
        
        # 确保目标目录存在
        mkdir -p "$CURSOR_USER_DIR"
        
        # 备份现有文件
        if [[ -f "$CURSOR_USER_DIR/settings.json" && ! -L "$CURSOR_USER_DIR/settings.json" ]]; then
            echo "备份现有的 settings.json..."
            mv "$CURSOR_USER_DIR/settings.json" "$CURSOR_USER_DIR/settings.json.bak.$(date +%Y%m%d_%H%M%S)"
        fi
        
        if [[ -f "$CURSOR_USER_DIR/keybindings.json" && ! -L "$CURSOR_USER_DIR/keybindings.json" ]]; then
            echo "备份现有的 keybindings.json..."
            mv "$CURSOR_USER_DIR/keybindings.json" "$CURSOR_USER_DIR/keybindings.json.bak.$(date +%Y%m%d_%H%M%S)"
        fi
        
        # 创建符号链接
        ln -sf "$CURSOR_CONFIG_DIR/settings.json" "$CURSOR_USER_DIR/settings.json"
        ln -sf "$CURSOR_CONFIG_DIR/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"
        
        echo "✅ Cursor 配置链接创建完成"
        ;;
        
    "unlink"|"uninstall")
        echo "移除 Cursor 配置的符号链接..."
        
        if [[ -L "$CURSOR_USER_DIR/settings.json" ]]; then
            rm "$CURSOR_USER_DIR/settings.json"
            echo "移除 settings.json 符号链接"
        fi
        
        if [[ -L "$CURSOR_USER_DIR/keybindings.json" ]]; then
            rm "$CURSOR_USER_DIR/keybindings.json"
            echo "移除 keybindings.json 符号链接"
        fi
        
        echo "✅ Cursor 配置链接移除完成"
        ;;
        
    "status")
        echo "=== Cursor 配置状态 ==="
        
        if [[ -L "$CURSOR_USER_DIR/settings.json" ]]; then
            echo "✅ settings.json -> $(readlink "$CURSOR_USER_DIR/settings.json")"
        elif [[ -f "$CURSOR_USER_DIR/settings.json" ]]; then
            echo "⚠️  settings.json 存在但不是符号链接"
        else
            echo "❌ settings.json 不存在"
        fi
        
        if [[ -L "$CURSOR_USER_DIR/keybindings.json" ]]; then
            echo "✅ keybindings.json -> $(readlink "$CURSOR_USER_DIR/keybindings.json")"
        elif [[ -f "$CURSOR_USER_DIR/keybindings.json" ]]; then
            echo "⚠️  keybindings.json 存在但不是符号链接"
        else
            echo "❌ keybindings.json 不存在"
        fi
        ;;
        
    *)
        echo "用法: $0 {link|unlink|status}"
        echo "  link    - 创建符号链接"
        echo "  unlink  - 移除符号链接"  
        echo "  status  - 检查状态"
        exit 1
        ;;
esac
