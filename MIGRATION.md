# Dotfiles 迁移指南

本指南帮助你在新电脑上快速部署 dotfiles 配置。

## 🚀 快速迁移

### 前置要求

确保已安装：
- Git
- [Homebrew](https://brew.sh) (macOS) 或对应的包管理器

### 一键部署脚本

```bash
#!/usr/bin/env bash

# 1. 克隆 dotfiles 仓库
git clone https://github.com/YourUsername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. 安装依赖
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    brew install stow fastfetch 1password/tap/1password-cli
else
    # Linux
    sudo apt install stow
    # 或
    sudo yum install stow
fi

# 3. 部署所有配置
./stow-manager.sh install

# 4. 重新加载 shell
source ~/.zshrc
```

## 📝 分步安装

### 步骤 1：克隆仓库

```bash
git clone https://github.com/YourUsername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 步骤 2：安装必要工具

```bash
# macOS
brew install stow
brew install fastfetch
brew install 1password/tap/1password-cli

# Linux
sudo apt install stow
```

### 步骤 3：查看可用配置包

```bash
./stow-manager.sh list
```

### 步骤 4：选择性部署

```bash
# 部署基础配置
./stow-manager.sh install shell git vim

# 或部署所有配置
./stow-manager.sh install
```

### 步骤 5：处理冲突

如果遇到文件冲突：

```bash
# 备份现有配置
mv ~/.zshrc ~/.zshrc.backup
mv ~/.gitconfig ~/.gitconfig.backup

# 重新部署
./stow-manager.sh restow shell git
```

## 🔐 配置 Secrets (1Password)

### 初次设置

```bash
# 1. 登录 1Password CLI
eval $(op signin)

# 2. 运行设置脚本
./scripts/setup-1password-secrets.sh

# 3. 在 1Password 中编辑条目，填入真实值
# 查看创建的条目
op item list --tags dotfiles
```

### 验证 Secrets 加载

```bash
# 重新加载 shell
source ~/.zshrc

# 验证环境变量
echo $GEMINI_API_KEY
```

## 🛠️ 特定应用配置

### Terminal (Ghostty/iTerm2)

配置会自动通过 Stow 链接到正确位置：
- Ghostty: `~/.config/ghostty/`
- 主题和字体会自动应用

### 编辑器 (VSCode/Zed/Cursor)

```bash
# 部署编辑器配置
./stow-manager.sh install vscode
./stow-manager.sh install zed
./stow-manager.sh install cursor
```

### Git 配置

Git 配置包括：
- 全局 .gitconfig
- 别名设置
- Beyond Compare 集成

确保设置用户信息：
```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

## 📋 迁移检查清单

- [ ] Git 已安装
- [ ] Homebrew/包管理器已安装
- [ ] 克隆 dotfiles 仓库到 `~/.dotfiles`
- [ ] 运行 `stow-manager.sh install`
- [ ] Shell 配置已加载
- [ ] 终端欢迎界面正常显示
- [ ] Git 用户信息已配置
- [ ] 1Password CLI 已配置（如需要）
- [ ] Secrets 正常加载（如需要）

## 🔄 更新配置

从远程仓库更新配置：

```bash
cd ~/.dotfiles
git pull

# 重新应用配置
./stow-manager.sh restow [包名]
```

## 🚨 常见问题

### Stow 报错 "would cause conflicts"

```bash
# 查看冲突文件
stow -nv shell

# 备份冲突文件
mv ~/.zshrc ~/.zshrc.backup

# 重新安装
./stow-manager.sh restow shell
```

### 终端欢迎界面不显示

```bash
# 检查 fastfetch 是否安装
which fastfetch

# 手动测试欢迎脚本
source ~/.dotfiles/terminal-welcome/welcome.sh

# 检查环境变量
echo $WELCOME_DISABLED
```

### Secrets 未加载

```bash
# 检查 1Password CLI
op account list

# 手动刷新缓存
./scripts/manage-secrets-cache.sh refresh
```

## 📚 相关文档

- [README.md](README.md) - 项目概览
- [stow-manager.sh](stow-manager.sh) - Stow 管理器帮助
- [GNU Stow 文档](https://www.gnu.org/software/stow/)

---

*最后更新：2025-01-15*