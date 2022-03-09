#zsh
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# プロンプト
autoload -U colors
colors

# 個別設定
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# コマンドミスを修正
setopt correct

# 補完の選択を楽にする
zstyle ':completion:*' menu select

# エディター
export EDITOR=code

# Starship
eval "$(starship init zsh)"

# alias
alias ll="ls -l"
alias la="ls -la"
alias ncu="npx npm-check-updates"
alias cls="clear"
alias zenn="npx zenn preview"
alias ghq-update="ghq list | ghq get --update --parallel"

#peco
peco-src () {
    local repo=$(ghq list | peco --query "$LBUFFER")
    if [ -n "$repo" ]; then
        repo=$(ghq list --full-path --exact $repo)
        BUFFER="cd ${repo}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# anyenv
eval "$(anyenv init -)"

# git
fpath=(
  ${HOME}/.zsh/completions
  ${fpath}
)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#ADB
export PATH=$PATH:/Users/nem/Library/Android/sdk/platform-tools
