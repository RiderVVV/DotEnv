# Dotfiles 🏠

基于 GNU Stow 和 1Password CLI 的现代化 dotfiles 管理方案。

## ✨ 特性

- 🔗 **GNU Stow** - 优雅的符号链接管理
- 🚀 **Fastfetch** - 高性能终端欢迎界面
- 🔐 **1Password CLI** - 安全的密钥管理
- 📦 **模块化设计** - 按应用组织配置
- ⚡ **永久缓存** - 零弹窗的密钥加载体验
- 🎨 **Nerd Font 支持** - 美观的图标和 Powerline 符号

## 📦 项目结构

```
~/.dotfiles/
├── shell/              # Shell 配置 (.zshrc, .bash_profile, etc.)
├── git/                # Git 配置 (.gitconfig, ignore 文件)
├── vim/                # Vim 配置 (.vimrc)
├── vscode/             # VSCode 配置
├── ghostty/            # Ghostty 终端配置
├── zed/                # Zed 编辑器配置
├── cursor/             # Cursor 编辑器配置
├── fastfetch/          # Fastfetch 终端欢迎配置
├── terminal-welcome/   # 终端欢迎系统（名言和脚本）
├── secrets/            # 密钥模板文件
├── scripts/            # 管理脚本
└── stow-manager.sh     # Stow 管理脚本
```

## 🚀 快速开始

### 1. 克隆仓库

```bash
# 克隆到 ~/.dotfiles
git clone https://github.com/YourUsername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. 安装依赖

```bash
# macOS (使用 Homebrew)
brew install stow
brew install fastfetch
brew install 1password/tap/1password-cli

# Linux
sudo apt install stow
# 或
sudo yum install stow
```

### 3. 安装字体

Ghostty 终端需要以下字体：

```bash
# macOS - 安装必需字体
brew tap homebrew/cask-fonts

# 1. JetBrains Mono Nerd Font (主字体)
brew install --cask font-jetbrains-mono-nerd-font

# 2. Symbols Nerd Font (图标符号)
brew install --cask font-symbols-nerd-font

# 注：SF Pro 和 Apple Color Emoji 为 macOS 内置字体
```

### 4. 部署配置

```bash
# 查看所有可用配置包
./stow-manager.sh list

# 安装所有配置
./stow-manager.sh install

# 或选择性安装
./stow-manager.sh install shell git vim
```

## 🛠️ Stow 管理器使用

```bash
# 查看所有包状态
./stow-manager.sh status

# 安装配置包
./stow-manager.sh install [包名...]

# 卸载配置包
./stow-manager.sh uninstall [包名...]

# 重新安装配置包
./stow-manager.sh restow [包名...]

# 显示帮助
./stow-manager.sh help
```

### 可用的配置包

- `shell` - Shell 配置 (.zshrc, .bash_profile)
- `git` - Git 配置
- `vim` - Vim 配置
- `vscode` - VSCode 配置
- `ghostty` - Ghostty 终端配置
- `zed` - Zed 编辑器配置
- `cursor` - Cursor 编辑器配置
- `fastfetch` - Fastfetch 配置
- `secrets` - 密钥模板文件

## 🎉 终端欢迎界面

### 功能特性

每次打开终端时自动显示：
- **系统信息** - CPU使用率、内存、磁盘、电池状态等
- **Git状态** - 当前分支和未提交更改
- **励志名言** - 随机显示编程相关名言（支持防重复机制）
- **快捷提示** - 常用命令提醒
- **日期时间** - 当前时间显示

### 显示效果

```
 👤 │ eric@MBP2019
─────────────────────────────
 💻 │ macOS Sequoia 15.6 x86_64
 🔧 │ Darwin 24.6.0
 ⏱️ │ 10 hours, 59 mins
 🐚 │ zsh 5.9
 🖥️ │ ghostty 1.1.3
 🧠 │ 13%
 💾 │ 24.66 GiB / 32.00 GiB (77%)
 💿 │ 623.63 GiB / 931.55 GiB (67%)
 🔋 │ 93% [AC connected]

 💭 │ Talk is cheap. Show me the code.
 💡 │ Quick commands: z <dir> | ll | gs | gd | tip
 📅 │ Friday, August 15, 2025 @ 15:04:24
```

### 性能指标

- Fastfetch：30-50ms（原生C性能）
- 名言加载：5-10ms（ZSH脚本优化）
- **总延迟：<65ms**

### 配置结构

```
terminal-welcome/
├── welcome.sh          # 主集成脚本（ZSH）
├── quote-loader.sh     # 高性能名言加载器（带防重复机制）
└── quotes.d/          # 名言集合
    ├── tech/          # 技术名言
    │   ├── en/       # 英文技术名言
    │   └── zh/       # 中文技术名言
    ├── motivation/    # 励志名言
    ├── humor/         # 幽默语录
    └── chinese/       # 中国古诗词

fastfetch/
└── .config/
    └── fastfetch/
        └── config.jsonc  # Fastfetch 配置文件
```

### 自定义配置

```bash
# 环境变量控制
export WELCOME_DISABLED=true           # 完全禁用欢迎界面
export WELCOME_SHOW_TIPS=true          # 显示快捷命令提示（默认开启）
export WELCOME_PRESET=minimal          # 强制最小模式（SSH/Docker环境）

# 手动显示欢迎界面
welcome

# 显示随机提示
tip
```

### Fastfetch 配置

配置通过 GNU Stow 管理（目录级软链接）：
- **源目录**：`~/.dotfiles/fastfetch/.config/fastfetch/`
- **软链接**：`~/.config/fastfetch` → `~/.dotfiles/fastfetch/.config/fastfetch/`

特性：
- 无 Logo 显示（简洁模式）
- 统一的分隔符格式（│）
- 彩色 emoji 图标
- 自适应终端宽度

### 添加自定义名言

```bash
# 添加技术名言
echo "Your quote" >> ~/.dotfiles/terminal-welcome/quotes.d/tech/en/custom.txt

# 添加中文名言
echo "你的名言" >> ~/.dotfiles/terminal-welcome/quotes.d/chinese/zh/custom.txt
```

## 🔐 Secrets 管理（1Password CLI）

### 初次设置

```bash
# 运行设置脚本
./scripts/setup-1password-secrets.sh

# 登录 1Password
eval $(op signin)

# 查看创建的条目
op item list --tags dotfiles
```

### 永久缓存机制

我们采用**永久缓存**策略，提供零弹窗体验：

1. **首次使用** - 触发生物认证，创建永久缓存
2. **日常使用** - 直接从缓存加载，无需认证
3. **手动更新** - 需要时主动刷新缓存

```bash
# 查看缓存状态
./scripts/manage-secrets-cache.sh status

# 手动刷新缓存（唯一需要认证的操作）
./scripts/manage-secrets-cache.sh refresh

# 清除缓存
./scripts/manage-secrets-cache.sh clear
```

## 📝 日常使用

### Git 操作

```bash
# 在 ~/.dotfiles 目录中使用标准 git 命令
cd ~/.dotfiles
git status
git add .
git commit -m "更新配置"
git push
```

### 更新配置

1. 直接编辑 `~/.dotfiles/` 中的文件
2. 提交更改到 Git
3. Stow 会自动维护符号链接

### 添加新配置

1. 在 `~/.dotfiles/` 创建新的包目录
2. 按照目标路径组织文件结构
3. 使用 `stow-manager.sh install` 创建链接

## 🔒 安全特性

### Git Hooks

- **pre-commit** - 检测敏感信息，阻止意外提交
- 检测模式：`AKIA|sk-ant|password|sshpass`

### 永不跟踪

- `.zsh.secrets`
- `.secrets.d/`
- `.ssh/`
- `.m2/settings.xml`

### 1Password 集成

- ✅ 加密存储
- ✅ 跨设备同步
- ✅ 永久缓存
- ✅ 零弹窗体验

## 🚨 故障排除

### Stow 冲突

```bash
# 如果遇到冲突，先备份现有文件
mv ~/.zshrc ~/.zshrc.backup

# 重新安装
./stow-manager.sh restow shell
```

### Secrets 未加载

```bash
# 检查 1Password CLI
op account list

# 重新登录
eval $(op signin)

# 手动刷新缓存
./scripts/manage-secrets-cache.sh refresh
```

### 权限问题

```bash
chmod 600 ~/.zsh.secrets
chmod 700 ~/.secrets.d
chmod +x ~/.dotfiles/**/*.sh
```

## 📚 相关链接

- [GNU Stow 文档](https://www.gnu.org/software/stow/)
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch)
- [1Password CLI](https://developer.1password.com/docs/cli/)

## 📄 License

MIT