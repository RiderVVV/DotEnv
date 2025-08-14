#!/usr/bin/env bash

# 1Password Secrets 缓存管理脚本
# 用法: ./scripts/manage-secrets-cache.sh [clear|refresh|status]

SECRETS_CACHE="$HOME/.cache/dotfiles-secrets"
CACHE_TTL=3600  # 1小时

show_help() {
    echo "用法: $0 [COMMAND]"
    echo ""
    echo "命令:"
    echo "  status   - 显示缓存状态"
    echo "  clear    - 清除缓存"  
    echo "  refresh  - 强制刷新缓存"
    echo "  help     - 显示帮助"
    echo ""
    echo "缓存文件: $SECRETS_CACHE"
    echo "缓存有效期: ${CACHE_TTL}秒 ($(($CACHE_TTL / 60))分钟)"
}

show_status() {
    if [ -f "$SECRETS_CACHE" ]; then
        cache_time=$(stat -f %m "$SECRETS_CACHE" 2>/dev/null || echo 0)
        current_time=$(date +%s)
        age=$((current_time - cache_time))
        
        echo "📄 缓存文件: $SECRETS_CACHE"
        echo "📅 创建时间: $(date -r "$cache_time" '+%Y-%m-%d %H:%M:%S')"
        echo "⏰ 缓存年龄: ${age}秒 ($(($age / 60))分钟)"
        
        if [ $age -lt $CACHE_TTL ]; then
            remaining=$((CACHE_TTL - age))
            echo "✅ 缓存有效 (还剩 $((remaining / 60))分钟)"
        else
            echo "❌ 缓存已过期"
        fi
        
        echo ""
        echo "缓存内容预览:"
        grep "^export" "$SECRETS_CACHE" | sed 's/=.*/=***/' || echo "  (无有效内容)"
        
        echo ""
        echo "文件大小: $(ls -lh "$SECRETS_CACHE" | awk '{print $5}')"
    else
        echo "❌ 缓存文件不存在"
    fi
}

clear_cache() {
    if [ -f "$SECRETS_CACHE" ]; then
        rm -f "$SECRETS_CACHE"
        echo "🗑️ 缓存已清除"
    else
        echo "ℹ️ 缓存文件不存在，无需清除"
    fi
}

refresh_cache() {
    echo "🔄 强制刷新缓存..."
    clear_cache
    
    # 重新加载 secrets
    if source ~/.secrets.d.template/load-from-1password.sh; then
        echo "✅ 缓存刷新完成"
    else
        echo "❌ 缓存刷新失败"
        return 1
    fi
}

# 主逻辑
case "${1:-status}" in
    "status"|"s")
        show_status
        ;;
    "clear"|"c")
        clear_cache
        ;;
    "refresh"|"r")
        refresh_cache
        ;;
    "help"|"h"|"-h"|"--help")
        show_help
        ;;
    *)
        echo "❌ 未知命令: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
