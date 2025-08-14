#!/usr/bin/env bash

# 1Password Secrets 设置脚本
# 用法: ./scripts/setup-1password-secrets.sh

set -e

echo "🔐 设置 1Password secrets 管理..."

# 检查 op CLI
if ! command -v op &> /dev/null; then
    echo "❌ 1Password CLI 未安装"
    echo "安装命令: brew install 1password/tap/1password-cli"
    exit 1
fi

# 检查登录状态
if ! op account list &> /dev/null; then
    echo "🔑 请先登录 1Password:"
    echo "   eval \$(op signin)"
    echo "   然后重新运行此脚本"
    exit 1
fi

echo "✅ 1Password CLI 已就绪"

# 创建 secrets 条目模板（如果不存在）
echo ""
echo "📝 创建 1Password 条目模板..."

# 创建 API Keys 条目
echo "创建 Gemini API 条目..."
op item create --category="API Credential" \
    --title="Gemini API" \
    --vault="Private" \
    credential="YOUR_GEMINI_KEY_HERE" \
    --tags="dotfiles,api" || echo "⚠️ Gemini API 条目可能已存在"

echo "创建 Anthropic API 条目..."  
op item create --category="API Credential" \
    --title="Anthropic API" \
    --vault="Private" \
    credential="YOUR_ANTHROPIC_KEY_HERE" \
    url="YOUR_ANTHROPIC_URL_HERE" \
    --tags="dotfiles,api" || echo "⚠️ Anthropic API 条目可能已存在"

echo "创建 JumpServer 条目..."
op item create --category="Login" \
    --title="JumpServer" \
    --vault="Private" \
    username="YOUR_USERNAME_HERE" \
    password="YOUR_JUMPSERVER_PASSWORD_HERE" \
    --tags="dotfiles,server" || echo "⚠️ JumpServer 条目可能已存在"

echo "创建 Rack Server 条目..."
op item create --category="Login" \
    --title="Rack Server" \
    --vault="Private" \
    username="YOUR_USERNAME_HERE" \
    password="YOUR_RACK_PASSWORD_HERE" \
    --tags="dotfiles,server" || echo "⚠️ Rack Server 条目可能已存在"

echo ""
echo "✅ 1Password 条目模板创建完成"
echo ""
echo "📋 接下来的步骤:"
echo "1. 在 1Password 中编辑条目，填入正确的值"
echo "2. 测试加载: source ~/.zsh.secrets"
echo "3. 验证变量: echo \$GEMINI_API_KEY"
echo ""
echo "🔍 查看所有相关条目:"
echo "   op item list --tags dotfiles"
