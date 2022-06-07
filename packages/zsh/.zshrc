# エディタ
export EDITOR=nano

# Gitコマンドの補完
fpath=(~/.zsh/completion $fpath)

# コマンドミスを修正
setopt correct

# 補完の選択を楽にする
zstyle ':completion:*' menu select

# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# n
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

# alias
alias ll="ls -l"
alias la="ls -la"
alias ncu="npx npm-check-updates"
alias cls="clear"
alias ghq-update="ghq list | ghq get --update --parallel"
alias relogin="exec $SHELL -l"
alias z="nano ~/.zshrc"
alias s="source ~/.zshrc"

# function
m2g () {
    ffmpeg -i $1 -r 10 ~/Desktop/output.gif
}

# Starship
eval "$(starship init zsh)"

# ghq peco
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

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# brew
if type brew &>/dev/null
then
    # brew completions
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"

    # zsh
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    autoload -Uz compinit
    compinit
fi
