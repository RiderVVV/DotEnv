# Dotfiles 🏠

基于 bare repository 和 1Password CLI 的安全 dotfiles 管理方案。

## 🚀 快速开始

### 一键部署

```bash
#!/usr/bin/env bash
# 克隆 bare repository
git clone --bare https://github.com/RiderVVV/DotEnv.git $HOME/.dotfiles

# 定义 dot 命令
function dot(){ /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"; }

# 检出文件到 home 目录
dot checkout

# 隐藏未跟踪文件
dot config status.showUntrackedFiles no

# 添加 dot 别名到 shell 配置
echo 'alias dot="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"' >> ~/.zshrc
```

### 处理文件冲突

如果 checkout 失败（已有同名文件）：

```bash
# 备份现有配置
mkdir -p ~/.config-backup
dot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.config-backup/{}

# 重新 checkout
dot checkout
```

## 🔐 Secrets 管理（1Password CLI）

### 安装 1Password CLI

```bash
brew install 1password/tap/1password-cli
```

### 登录 1Password

```bash
eval $(op signin)
```

### 初次设置 Secrets

```bash
# 运行设置脚本
./scripts/setup-1password-secrets.sh

# 在 1Password 中编辑条目，填入真实值
# 查看创建的条目
op item list --tags dotfiles
```

### Secrets 结构

脚本会在 1Password 中创建以下条目：

- **Gemini API** (API Credential)
  - `credential`: Gemini API Key
- **Anthropic API** (API Credential)  
  - `credential`: Anthropic API Key
  - `url`: Anthropic Base URL
- **JumpServer** (Login)
  - `username`: SSH 用户名
  - `password`: SSH 密码
- **Rack Server** (Login)
  - `username`: SSH 用户名  
  - `password`: SSH 密码

## 📁 文件结构

```
~/.dotfiles/              # bare repository
~/
├── .zshrc               # zsh 配置（自动加载 secrets）
├── .zsh.secrets         # secrets 加载器
├── .p10k.zsh            # PowerLevel10k 主题
├── .gitconfig           # Git 全局配置
├── .vimrc               # Vim 配置
├── .config/
│   ├── ghostty/         # Ghostty 终端配置
│   ├── zed/             # Zed 编辑器配置
│   └── git/             # Git 配置
├── .secrets.d.template/ # Secrets 模板
│   ├── load-from-1password.sh
│   ├── api.env.template
│   └── ssh.env.template
└── scripts/
    ├── setup-1password-secrets.sh
    └── init-secrets.sh
```

## 🛠️ 日常使用

### 管理 dotfiles

```bash
# 查看状态
dot status

# 添加文件
dot add .newrc

# 提交更改
dot commit -m "add new config"

# 推送到远程
dot push

# 查看历史
dot log --oneline
```

### 管理 secrets

```bash
# 在 1Password 中直接编辑条目
op item edit "Gemini API" credential="new-api-key"

# 重新加载 secrets
source ~/.zsh.secrets

# 验证加载
echo $GEMINI_API_KEY
```

## 🔒 安全特性

### Git Hooks

- **pre-commit**: 自动检测敏感信息，阻止意外提交
- 检测模式：`AKIA|sk-ant|password|sshpass -p`

### Git Exclude

以下文件/目录永不跟踪：
- `.zsh.secrets`
- `.secrets.d/`
- `.ssh/`
- `.m2/settings.xml`

### 1Password 集成优势

- ✅ 加密存储在 1Password vault
- ✅ 跨设备自动同步
- ✅ 版本控制友好
- ✅ 降级兼容（本地 .env 文件）
- ✅ 细粒度权限控制

## 🚨 故障排除

### Secrets 未加载

```bash
# 检查 1Password CLI 状态
op account list

# 重新登录
eval $(op signin)

# 检查条目
op item list --tags dotfiles

# 手动测试加载
source ~/.secrets.d.template/load-from-1password.sh
```

### 权限问题

```bash
chmod 600 ~/.zsh.secrets
chmod 700 ~/.secrets.d
chmod 600 ~/.secrets.d/*.env
```

### Git 配置

```bash
# 检查用户信息
dot config user.name
dot config user.email

# 更新配置
dot config user.name "Your Name"
dot config user.email "your-email@example.com"
```

## 📚 更多信息

- [MIGRATION.md](MIGRATION.md) - 详细迁移指南
- [Bare Repository 原理](https://www.atlassian.com/git/tutorials/dotfiles)
- [1Password CLI 文档](https://developer.1password.com/docs/cli/)
