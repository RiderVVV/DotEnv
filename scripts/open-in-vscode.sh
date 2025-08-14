#!/usr/bin/env bash

# 在 VSCode 中打开 dotfiles 的便捷脚本
# 用法: ./scripts/open-in-vscode.sh

set -e

echo "🚀 在 VSCode 中打开 dotfiles..."

# 检查 VSCode 是否安装
if ! command -v code &> /dev/null; then
    echo "❌ VSCode 未安装或 'code' 命令不可用"
    echo "请安装 VSCode 并启用 shell 命令"
    echo "VSCode → Command Palette → Shell Command: Install 'code' command in PATH"
    exit 1
fi

# 方式1：使用 workspace 文件
if [ -f "$HOME/dotfiles.code-workspace" ]; then
    echo "📂 使用 workspace 配置打开..."
    code "$HOME/dotfiles.code-workspace"
else
    # 方式2：直接打开 home 目录但只显示 dotfiles
    echo "📁 直接打开 home 目录..."
    code "$HOME" --new-window
fi

echo "✅ VSCode 已打开 dotfiles 工作区"

# 显示提示信息
echo ""
echo "💡 使用提示:"
echo "1. 使用 Ctrl+Shift+P 打开命令面板"
echo "2. 运行任务: Tasks: Run Task → dot status"
echo "3. 集成终端中使用 'dot' 命令管理 dotfiles"
echo "4. 推荐安装扩展: Shell Script, DotENV, GitLens"
