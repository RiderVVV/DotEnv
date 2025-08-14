# Dotfiles 新电脑迁移指南

## 方法1：一键脚本

```bash
#!/usr/bin/env bash
git clone --bare https://github.com/RiderVVV/DotEnv.git $HOME/.dotfiles
function dot(){ /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"; }
dot checkout
dot config status.showUntrackedFiles no
```

## 方法2：分步执行

### 步骤1：克隆仓库
```bash
git clone --bare https://github.com/RiderVVV/DotEnv.git $HOME/.dotfiles
```

### 步骤2：设置别名
```bash
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

### 步骤3：checkout文件
```bash
dot checkout
```

### 步骤4：如果有冲突
如果提示文件已存在，备份原文件：
```bash
mkdir -p ~/.config-backup
dot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.config-backup/{}
dot checkout
```

### 步骤5：配置git
```bash
dot config status.showUntrackedFiles no
```

## 3. 重新创建secrets文件

由于secrets文件被排除，需要手动重建：

### 步骤1：创建secrets目录
```bash
mkdir -p ~/.secrets.d
chmod 700 ~/.secrets.d
```

### 步骤2：创建API配置
```bash
cat > ~/.secrets.d/api.env << 'EOF'
# API Keys 和相关配置
export GEMINI_API_KEY="你的key"
export ANTHROPIC_API_KEY="你的key" 
export ANTHROPIC_BASE_URL="你的URL"
EOF
chmod 600 ~/.secrets.d/api.env
```

### 步骤3：创建SSH配置
```bash
cat > ~/.secrets.d/ssh.env << 'EOF'
# SSH 连接密码
export JUMPSERVER_PASSWORD='你的密码'
export RACK_PASSWORD='你的密码'
EOF
chmod 600 ~/.secrets.d/ssh.env
```

## 4. 配置shell

### 添加dot别名到shell配置
```bash
echo 'alias dot="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"' >> ~/.zshrc
```

### 重新加载配置
```bash
source ~/.zshrc
```

## 5. 验证安装

```bash
# 检查状态
dot status

# 查看配置文件
dot ls-files

# 验证secrets加载
source ~/.zsh.secrets && echo "Secrets loaded successfully"
```

## 故障排除

### 权限问题
```bash
chmod 600 ~/.zsh.secrets
chmod 700 ~/.secrets.d
chmod 600 ~/.secrets.d/*.env
```

### SSH密钥配置
```bash
# 检查SSH密钥
ls -la ~/.ssh/

# 如需生成新密钥
ssh-keygen -t ed25519 -C "your-email@example.com"
```

### Git配置检查
```bash
# 检查用户信息
dot config user.name
dot config user.email

# 如需更新
dot config user.name "Your Name"
dot config user.email "your-email@example.com"
```
