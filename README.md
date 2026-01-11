# 🛠️ 我的 Dotfiles 托管库

这是我的个人配置文件（dotfiles）仓库，使用 [chezmoi](https://www.chezmoi.io/) 进行管理。

## 🚀 快速开始 (新机器部署)

在新机器上，只需一行命令即可全自动安装 `chezmoi` 并同步所有配置：

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ShangYJQ
```
或
```bash
chezmoi init --apply ShangYJQ
```
## 安装其他软件
```bash
#oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 安装字体
sudo pacman -S noto-fonts-cjk ttf-cascadia-code-nerd
```

---

## 💡 日常操作指南

### 1. 修改配置
修改家目录下的文件，使用以下命令：
```bash
nvim ~/.zshrc
chezmoi re-add
```
*提示：如果你想在保存后立即生效，可以使用 `chezmoi edit --apply ~/.zshrc`*

### 2. 添加新配置
如果你想备份一个新的文件：
```bash
chezmoi add ~/.gitconfig
```

### 3. 在其他机器获取更新
```bash
chezmoi update
```

