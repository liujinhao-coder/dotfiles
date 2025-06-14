#!/bin/bash

# ====== 配置 ======
DOTFILES_DIR="$HOME/dotfiles"  # 点文件仓库路径
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d)"  # 备份目录

# ====== 主程序 ======
main() {
    check_prerequisites
    backup_existing_files
    create_symlinks
    finalize
}

# ====== 函数定义 ======

# 检查依赖项
check_prerequisites() {
    if ! command -v git &> /dev/null; then
        echo "错误：请先安装 Git"
        exit 1
    fi
}

# 备份现有文件
backup_existing_files() {
    echo "正在备份现有配置文件..."
    mkdir -p "$BACKUP_DIR"
    
    local files=(
        ".bashrc" 
        ".gitconfig"
        ".profile"
        ".tmux.conf"
        ".vim"
        ".vimrc"
    )

    for file in "${files[@]}"; do
        if [ -e "$HOME/$file" ]; then
            mv "$HOME/$file" "$BACKUP_DIR/"
            echo "已备份: $file"
        fi
    done
}

# 创建符号链接
create_symlinks() {
    echo "正在创建符号链接..."
    
    ln -sf "$DOTFILES_DIR/.bashrc"    "$HOME/.bashrc"
    ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    ln -sf "$DOTFILES_DIR/.profile"   "$HOME/.profile"
    ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
    ln -sf "$DOTFILES_DIR/.vimrc"     "$HOME/.vimrc"
    
    # 处理目录
    if [ -d "$DOTFILES_DIR/.vim" ]; then
        rm -rf "$HOME/.vim"  # 先删除可能存在的目录
        ln -sf "$DOTFILES_DIR/.vim" "$HOME/.vim"
    fi
}

# 完成安装
finalize() {
    echo -e "\n=== 安装完成 ==="
    echo "• 配置文件已链接到: $DOTFILES_DIR"
    echo "• 原始文件备份在: $BACKUP_DIR"
    echo -e "\n请重新加载 shell 配置:"
    echo "  source ~/.bashrc"
}

# ====== 执行主程序 ======
main "$@"
