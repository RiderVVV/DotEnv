#!/usr/bin/env bash

# 1Password Secrets 缓存管理脚本
# 用法: ./scripts/manage-secrets-cache.sh [clear|refresh|status]

SECRETS_CACHE="$HOME/.cache/dotfiles-secrets"

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
    echo "缓存策略: 永久有效，需要更新时手动刷新"
}

show_status() {
    if [ -f "$SECRETS_CACHE" ]; then
        cache_time=$(stat -f %m "$SECRETS_CACHE" 2>/dev/null || echo 0)
        current_time=$(date +%s)
        age=$((current_time - cache_time))
        
        echo "📄 缓存文件: $SECRETS_CACHE"
        echo "📅 创建时间: $(date -r "$cache_time" '+%Y-%m-%d %H:%M:%S')"
        # 友好的时间显示
        if [ $age -lt 3600 ]; then
            echo "⏰ 创建于: $(($age / 60))分钟前"
        elif [ $age -lt 86400 ]; then
            echo "⏰ 创建于: $(($age / 3600))小时前"
        else
            echo "⏰ 创建于: $(($age / 86400))天前"
        fi
        
        echo "✅ 缓存状态: 永久有效 (手动管理)"
        
        echo ""
        echo "缓存内容预览:"
        grep "^export" "$SECRETS_CACHE" | sed 's/=.*/=***/' || echo "  (无有效内容)"
        
        echo ""
        echo "文件大小: $(ls -lh "$SECRETS_CACHE" | awk '{print $5}')"
        
        echo ""
        echo "📝 管理提示:"
        echo "  - 缓存永久有效，不会自动过期"
        echo "  - 需要更新 secrets 时运行: refresh"
        echo "  - 只有手动 clear 或 refresh 才会重新认证"
    else
        echo "❌ 缓存文件不存在"
        echo "📝 首次使用时会自动从 1Password 加载并创建缓存"
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
