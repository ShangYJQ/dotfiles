#!/usr/bin/env bash

set -Eeuo pipefail

PACMAN_PKGS=(
    noto-fonts-cjk
    ttf-cascadia-code-nerd
    fcitx5-im
    fcitx5-chinese-addons
    fcitx5-qt
    fcitx5-gtk
    papirus-icon-theme
    qt6ct
    hypridle
    eza
    kitty
)

AUR_PKGS=(
    noctalia-shell
    bibata-cursor-theme-bin
)

echo "准备安装所需的软件和依赖"
echo "------------------------"

echo "安装zsh omz"
sudo pacman -S --needed --noconfirm zsh curl git

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo ">>安装omz"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo ">>已经有omz了？"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo ">> 安装 Oh My Zsh 插件..."

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "正在下载 zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting 已存在，跳过。"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "正在下载 zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions 已存在，跳过。"
fi

echo ">>安装其他桌面软件"

sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

if command -v paru &> /dev/null; then
    echo ">> 安装 AUR 软件..."
    paru -S --needed --noconfirm --skipreview "${AUR_PKGS[@]}"
else
    echo "!! 未检测到 Paru，跳过 AUR 安装。"
fi

echo ">> 安装完成！"
