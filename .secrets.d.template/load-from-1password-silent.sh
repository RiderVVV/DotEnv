#!/usr/bin/env bash

# 从 1Password 加载 secrets（静默版本）
# 使用方法: source ~/.secrets.d.template/load-from-1password-silent.sh

# 缓存文件路径
SECRETS_CACHE="$HOME/.cache/dotfiles-secrets"
CACHE_TTL=3600  # 1小时缓存

# 创建缓存目录（静默）
mkdir -p "$(dirname "$SECRETS_CACHE")" 2>/dev/null

# 检查缓存是否有效
if [ -f "$SECRETS_CACHE" ] && [ $(($(date +%s) - $(stat -f %m "$SECRETS_CACHE" 2>/dev/null || echo 0))) -lt $CACHE_TTL ]; then
    # 从缓存加载（静默）
    source "$SECRETS_CACHE" 2>/dev/null
    return 0
fi

# 检查 op CLI 是否可用（静默）
if ! command -v op &> /dev/null; then
    return 1
fi

# 检查是否已登录（静默）
if ! op account list &> /dev/null; then
    return 1
fi

# 临时文件用于批量加载
temp_secrets=$(mktemp)

# 一次性批量获取所有secrets（静默）
{
    echo "# 1Password Secrets Cache - $(date)"
    echo "# Auto-generated, do not edit manually"
    echo ""
    
    # API Keys
    GEMINI_KEY=$(op read "op://Private/Gemini API/credential" 2>/dev/null || echo "")
    ANTHROPIC_KEY=$(op read "op://Private/Anthropic API/credential" 2>/dev/null || echo "")
    ANTHROPIC_URL=$(op read "op://Private/Anthropic API/url" 2>/dev/null || echo "http://localhost:8082")
    
    # SSH 密码  
    JUMP_PASS=$(op read "op://Private/JumpServer/password" 2>/dev/null || echo "")
    RACK_PASS=$(op read "op://Private/Rack Server/password" 2>/dev/null || echo "")
    
    # 写入缓存文件
    [ -n "$GEMINI_KEY" ] && echo "export GEMINI_API_KEY='$GEMINI_KEY'"
    [ -n "$ANTHROPIC_KEY" ] && echo "export ANTHROPIC_API_KEY='$ANTHROPIC_KEY'"
    [ -n "$ANTHROPIC_URL" ] && echo "export ANTHROPIC_BASE_URL='$ANTHROPIC_URL'"
    [ -n "$JUMP_PASS" ] && echo "export JUMPSERVER_PASSWORD='$JUMP_PASS'"
    [ -n "$RACK_PASS" ] && echo "export RACK_PASSWORD='$RACK_PASS'"
    
} > "$temp_secrets" 2>/dev/null

# 验证并应用secrets（静默）
if [ -s "$temp_secrets" ]; then
    # 移动到正式缓存位置
    mv "$temp_secrets" "$SECRETS_CACHE" 2>/dev/null
    chmod 600 "$SECRETS_CACHE" 2>/dev/null
    
    # 加载到当前环境
    source "$SECRETS_CACHE" 2>/dev/null
else
    rm -f "$temp_secrets" 2>/dev/null
    return 1
fi
