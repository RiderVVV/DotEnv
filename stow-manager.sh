#!/bin/bash

# GNU Stow 管理脚本
# 用于便捷管理 dotfiles 各个包

set -e

DOTFILES_DIR="$HOME/.dotfiles"
PACKAGES=("shell" "git" "vim" "vscode" "ghostty" "zed" "secrets" "cursor")

usage() {
    echo "用法: $0 [命令] [包名...]"
    echo ""
    echo "命令:"
    echo "  install, i     - 安装包 (创建符号链接)"
    echo "  uninstall, u   - 卸载包 (删除符号链接)"
    echo "  restow, r      - 重新安装包 (先卸载再安装)"
    echo "  list, l        - 列出所有可用包"
    echo "  status, s      - 显示所有包的状态"
    echo "  help, h        - 显示此帮助信息"
    echo ""
    echo "包名:"
    echo "  shell    - Shell 配置 (.zshrc, .bash_profile, etc.)"
    echo "  git      - Git 配置 (.gitconfig, git ignore)"
    echo "  vim      - Vim 配置 (.vimrc)"
    echo "  vscode   - VSCode 配置"
    echo "  ghostty  - Ghostty 终端配置"
    echo "  zed      - Zed 编辑器配置"
    echo "  cursor   - Cursor 编辑器配置"
    echo "  secrets  - 密钥模板文件"
    echo ""
    echo "示例:"
    echo "  $0 install shell git    # 安装 shell 和 git 配置"
    echo "  $0 uninstall vscode     # 卸载 VSCode 配置"
    echo "  $0 restow shell         # 重新安装 shell 配置"
    echo "  $0 status               # 查看所有包状态"
}

check_stow() {
    if ! command -v stow &> /dev/null; then
        echo "❌ 错误: 未安装 GNU Stow"
        echo "请运行: brew install stow"
        exit 1
    fi
}

list_packages() {
    echo "📦 可用的配置包:"
    for pkg in "${PACKAGES[@]}"; do
        if [ -d "$DOTFILES_DIR/$pkg" ]; then
            echo "  ✅ $pkg"
        else
            echo "  ❌ $pkg (目录不存在)"
        fi
    done
}

check_package_status() {
    local pkg=$1
    echo -n "📦 $pkg: "
    
    if [ ! -d "$DOTFILES_DIR/$pkg" ]; then
        echo "❌ 包目录不存在"
        return 1
    fi
    
    # 检查是否有符号链接指向该包
    local linked_files=0
    local total_files=0
    
    while IFS= read -r -d '' file; do
        ((total_files++))
        local relative_path="${file#$DOTFILES_DIR/$pkg/}"
        local target_path="$HOME/$relative_path"
        
        if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = ".dotfiles/$pkg/$relative_path" ]; then
            ((linked_files++))
        fi
    done < <(find "$DOTFILES_DIR/$pkg" -type f -print0)
    
    if [ $linked_files -eq $total_files ] && [ $total_files -gt 0 ]; then
        echo "🟢 已安装 ($linked_files/$total_files 文件)"
    elif [ $linked_files -gt 0 ]; then
        echo "🟡 部分安装 ($linked_files/$total_files 文件)"
    else
        echo "⚪ 未安装 (0/$total_files 文件)"
    fi
}

show_status() {
    echo "🔍 配置包状态:"
    for pkg in "${PACKAGES[@]}"; do
        check_package_status "$pkg"
    done
}

install_packages() {
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        packages=("${PACKAGES[@]}")
        echo "📥 安装所有配置包..."
    else
        echo "📥 安装指定配置包: ${packages[*]}"
    fi
    
    cd "$DOTFILES_DIR"
    
    for pkg in "${packages[@]}"; do
        if [ -d "$pkg" ]; then
            echo "  安装 $pkg..."
            if stow "$pkg"; then
                echo "  ✅ $pkg 安装成功"
            else
                echo "  ❌ $pkg 安装失败"
            fi
        else
            echo "  ⚠️  跳过 $pkg (目录不存在)"
        fi
    done
}

uninstall_packages() {
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        packages=("${PACKAGES[@]}")
        echo "📤 卸载所有配置包..."
    else
        echo "📤 卸载指定配置包: ${packages[*]}"
    fi
    
    cd "$DOTFILES_DIR"
    
    for pkg in "${packages[@]}"; do
        if [ -d "$pkg" ]; then
            echo "  卸载 $pkg..."
            if stow -D "$pkg"; then
                echo "  ✅ $pkg 卸载成功"
            else
                echo "  ❌ $pkg 卸载失败"
            fi
        else
            echo "  ⚠️  跳过 $pkg (目录不存在)"
        fi
    done
}

restow_packages() {
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        packages=("${PACKAGES[@]}")
        echo "🔄 重新安装所有配置包..."
    else
        echo "🔄 重新安装指定配置包: ${packages[*]}"
    fi
    
    cd "$DOTFILES_DIR"
    
    for pkg in "${packages[@]}"; do
        if [ -d "$pkg" ]; then
            echo "  重新安装 $pkg..."
            if stow -R "$pkg"; then
                echo "  ✅ $pkg 重新安装成功"
            else
                echo "  ❌ $pkg 重新安装失败"
            fi
        else
            echo "  ⚠️  跳过 $pkg (目录不存在)"
        fi
    done
}

# 主程序
check_stow

case "${1:-}" in
    install|i)
        shift
        install_packages "$@"
        ;;
    uninstall|u)
        shift
        uninstall_packages "$@"
        ;;
    restow|r)
        shift
        restow_packages "$@"
        ;;
    list|l)
        list_packages
        ;;
    status|s)
        show_status
        ;;
    help|h|"")
        usage
        ;;
    *)
        echo "❌ 未知命令: $1"
        echo ""
        usage
        exit 1
        ;;
esac
