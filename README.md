# 🛠️ 我的 Dotfiles 托管库

这是我的个人配置文件（dotfiles）仓库，使用 [chezmoi](https://www.chezmoi.io/) 进行管理。

## 同步

### 在新机器上(需要 `git` `paru` `chezmoi`)：
```bash
chezmoi init --apply ShangYJQ
```

## 依赖安装
```bash
chezmoi cd && ./install.sh
```

## 其他
```bash
#安装omz
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 链接omz插件
mkdir -p ~/.oh-my-zsh/custom/plugins
ln -s /usr/share/zsh/plugins/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
ln -s /usr/share/zsh/plugins/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# clone nvim config
git clone git@github.com:ShangYJQ/nvim-lite.git ~/.config/nvim
```

