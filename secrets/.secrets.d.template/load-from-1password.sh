#!/usr/bin/env bash

# 从 1Password 加载 secrets（优化版，减少认证弹窗）
# 使用方法: source ~/.secrets.d.template/load-from-1password.sh

# 缓存文件路径
SECRETS_CACHE="$HOME/.cache/dotfiles-secrets"

# 创建缓存目录
mkdir -p "$(dirname "$SECRETS_CACHE")"

# 检查缓存是否存在（永久有效，除非手动清除）
if [ -f "$SECRETS_CACHE" ]; then
    # 从缓存加载
    source "$SECRETS_CACHE"
    echo "📦 从缓存加载 secrets ($(date -r $(stat -f %m "$SECRETS_CACHE") '+%Y-%m-%d %H:%M:%S'))"
    return 0
fi

# 检查 op CLI 是否可用
if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI (op) 未安装"
    echo "请安装: brew install 1password/tap/1password-cli"
    return 1
fi

# 检查是否已登录（静默）
if ! op account list &> /dev/null; then
    echo "🔐 需要登录 1Password，将触发生物认证..."
    if ! op account list 2>/dev/null; then
        echo "❌ 1Password 未登录，请运行: eval \$(op signin)"
        return 1
    fi
fi

echo "🔑 正在从 1Password 加载 secrets...（可能需要生物认证）"

# 临时文件用于批量加载
temp_secrets=$(mktemp)

# 一次性批量获取所有secrets（减少认证次数）
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
    
} > "$temp_secrets"

# 验证并应用secrets
if [ -s "$temp_secrets" ]; then
    # 移动到正式缓存位置
    mv "$temp_secrets" "$SECRETS_CACHE"
    chmod 600 "$SECRETS_CACHE"
    
    # 加载到当前环境
    source "$SECRETS_CACHE"
    
    # 计算加载的数量
    loaded_count=0
    [ -n "$GEMINI_API_KEY" ] && ((loaded_count++))
    [ -n "$ANTHROPIC_API_KEY" ] && ((loaded_count++))
    [ -n "$JUMPSERVER_PASSWORD" ] && ((loaded_count++))
    [ -n "$RACK_PASSWORD" ] && ((loaded_count++))
    
    echo "✅ 从 1Password 加载了 $loaded_count 个 secrets（已永久缓存，需要更新时手动刷新）"
else
    rm -f "$temp_secrets"
    echo "⚠️ 未能从 1Password 加载任何 secrets，请检查条目名称和权限"
    return 1
fi
