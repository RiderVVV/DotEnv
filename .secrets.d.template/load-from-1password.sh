#!/usr/bin/env bash

# 从 1Password 加载 secrets
# 使用方法: source ~/.secrets.d.template/load-from-1password.sh

# 检查 op CLI 是否可用
if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI (op) 未安装"
    echo "请安装: brew install 1password/tap/1password-cli"
    return 1
fi

# 检查是否已登录
if ! op account list &> /dev/null; then
    echo "🔐 请先登录 1Password: eval \$(op signin)"
    return 1
fi

# 从 1Password 加载环境变量
# 格式: export VAR_NAME="$(op read "op://vault/item/field")"

# API Keys (假设你在 1Password 中创建了相应的条目)
export GEMINI_API_KEY="$(op read "op://Private/Gemini API/credential" 2>/dev/null || echo '')"
export ANTHROPIC_API_KEY="$(op read "op://Private/Anthropic API/credential" 2>/dev/null || echo '')"
export ANTHROPIC_BASE_URL="$(op read "op://Private/Anthropic API/url" 2>/dev/null || echo 'http://localhost:8082')"

# SSH 密码
export JUMPSERVER_PASSWORD="$(op read "op://Private/JumpServer/password" 2>/dev/null || echo '')"
export RACK_PASSWORD="$(op read "op://Private/Rack Server/password" 2>/dev/null || echo '')"

# 验证加载状态
loaded_count=0
[ -n "$GEMINI_API_KEY" ] && ((loaded_count++))
[ -n "$ANTHROPIC_API_KEY" ] && ((loaded_count++))
[ -n "$JUMPSERVER_PASSWORD" ] && ((loaded_count++))
[ -n "$RACK_PASSWORD" ] && ((loaded_count++))

if [ $loaded_count -gt 0 ]; then
    echo "✅ 从 1Password 加载了 $loaded_count 个 secrets"
else
    echo "⚠️ 未从 1Password 加载任何 secrets，请检查条目名称"
fi
