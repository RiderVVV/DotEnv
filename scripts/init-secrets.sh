#!/usr/bin/env bash

# Secrets 初始化脚本
# 用法: ./scripts/init-secrets.sh

set -e

SECRETS_DIR="$HOME/.secrets.d"
TEMPLATE_DIR="$HOME/.secrets.d.template"

echo "🔐 初始化 secrets 配置..."

# 创建 secrets 目录
if [ ! -d "$SECRETS_DIR" ]; then
    echo "📁 创建 $SECRETS_DIR"
    mkdir -p "$SECRETS_DIR"
    chmod 700 "$SECRETS_DIR"
fi

# 从模板复制文件
if [ -d "$TEMPLATE_DIR" ]; then
    echo "📋 从模板复制文件..."
    for template in "$TEMPLATE_DIR"/*.template; do
        if [ -f "$template" ]; then
            filename=$(basename "$template" .template)
            target="$SECRETS_DIR/$filename"
            
            if [ ! -f "$target" ]; then
                cp "$template" "$target"
                chmod 600 "$target"
                echo "✅ 创建 $target"
            else
                echo "⚠️  $target 已存在，跳过"
            fi
        fi
    done
else
    echo "❌ 模板目录不存在: $TEMPLATE_DIR"
    echo "请手动创建 secrets 文件"
fi

echo ""
echo "📝 请编辑以下文件填入真实值:"
find "$SECRETS_DIR" -name "*.env" -exec echo "   {}" \;

echo ""
echo "🔧 验证 secrets 加载:"
echo "   source ~/.zsh.secrets && echo 'Secrets loaded successfully'"
