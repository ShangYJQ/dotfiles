# 🛠️ 我的 Dotfiles 托管库

这是我的个人配置文件（dotfiles）仓库，使用 [chezmoi](https://www.chezmoi.io/) 进行管理。

## 同步

### 在新机器上(需要 `git` `paru` `chezmoi`)：

```bash
chezmoi init --apply git@github.com:ShangYJQ/dotfiles.git
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

# 配置 sddm 主题
sudo mkdir /etc/sddm.conf.d/

sudo tee /etc/sddm.conf.d/theme.conf <<'EOF'
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
EOF

# 测试 sddm
cd /usr/share/sddm/themes/silent/
./test.sh

# 配置语音输入 (whisper.cpp)
cd .local/share/whisper/models
wget https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin
wget https://huggingface.co/ggml-org/whisper-vad/resolve/main/ggml-silero-v6.2.0.bin

#  ai commits
bun i -g aicommits@develop
aicommits setup
aicommits config set PROMPT=$'请使用 Conventional Commits 规范写一条提交信息。\n格式必须为：type(scope 可选): 中文描述。\n每一行长度不得超过 74 个字符。\n请使用中文（zh-CN）输出。\n如果能从分支名 {branch} 推断出 issue 编号，请把它加在提交标题末尾，并用括号包裹。\n\n（提示：使用这个 hint 来改进提交信息：$hint）\n\n之前的提交信息：\n{previousCommitMessages}\n\nDiff：\n{diff}\n\n只输出最终的 commit message，不要输出任何解释。'
```
