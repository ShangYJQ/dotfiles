#!/usr/bin/env bash

set -Eeuo pipefail

PACMAN_PKGS=(
	noto-fonts-cjk
	noto-fonts-emoji
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
	fzf
	git
	curl
	zsh
	zsh-autosuggestions
	zsh-syntax-highlighting
	qt6-svg
	qt6-virtualkeyboard
	qt6-multimedia-ffmpeg
	seahorse
	cliphist
	wl-clipboard
	zoxide
	slurp
	swappy
)

AUR_PKGS=(
	neovim-nightly-bin
	gpu-screen-recorder
	noctalia-shell
	sddm-silent-theme-git
	bibata-cursor-theme-bin
)

echo ">> 准备安装所需的软件和依赖"
echo "------------------------"

echo ">> 安装软件包"

sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

if command -v paru &>/dev/null; then
	echo ">> 安装 AUR 软件..."
	paru -S --needed --noconfirm --skipreview "${AUR_PKGS[@]}"
else
	echo "!! 未检测到 Paru，跳过 AUR 安装。"
fi

echo ">> 安装完成！"
