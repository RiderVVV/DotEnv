# Cursor 配置管理

## 概述

此目录包含 Cursor 编辑器的配置文件，并提供了特殊的管理脚本来处理 Cursor 配置路径中包含空格的问题。

## 文件结构

```
cursor/
├── .config/cursor/
│   ├── settings.json      # Cursor 用户设置
│   └── keybindings.json   # Cursor 快捷键绑定
├── stow-cursor.sh         # Cursor 配置链接管理脚本
└── README.md             # 本说明文档
```

## 使用方法

### 🚀 快速安装（已有 dotfiles 环境）

如果你已经克隆了这个 dotfiles 仓库并且配置了 1Password CLI：

```bash
# 1. 使用 Stow 安装基础配置文件到 ~/.config/cursor/
./stow-manager.sh install cursor

# 2. 使用特殊脚本创建到 Cursor 应用目录的符号链接
./cursor/stow-cursor.sh link
```

### 🆕 全新安装（新环境）

如果你是第一次在新机器上设置：

```bash
# 1. 安装依赖
brew install stow
brew install 1password/tap/1password-cli

# 2. 克隆 dotfiles 仓库
git clone https://github.com/RiderVVV/DotEnv.git ~/.dotfiles
cd ~/.dotfiles

# 3. 安装 Cursor 配置
./stow-manager.sh install cursor
./cursor/stow-cursor.sh link
```

### 检查配置状态

```bash
# 查看 Cursor 配置链接状态
./cursor/stow-cursor.sh status
```

### 卸载 Cursor 配置

```bash
# 移除 Cursor 应用目录的符号链接
./cursor/stow-cursor.sh unlink

# 卸载 Stow 包
./stow-manager.sh uninstall cursor
```

## 为什么需要特殊处理？

Cursor 的配置文件路径包含空格：
- `~/Library/Application Support/Cursor/User/`

这导致 GNU Stow 无法直接处理这种路径。我们的解决方案：

1. 使用 Stow 将配置文件链接到标准的 `~/.config/cursor/` 路径
2. 使用 `stow-cursor.sh` 脚本创建从 Cursor 应用目录到标准路径的符号链接

## 配置文件说明

### settings.json
包含 Cursor 的所有用户设置，包括：
- 编辑器外观和字体设置
- 代码格式化和补全设置
- Git 和终端集成设置
- 扩展和插件配置
- 以及其他个性化设置

### keybindings.json
包含自定义的快捷键绑定，覆盖默认的键盘快捷键。
