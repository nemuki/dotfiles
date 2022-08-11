# エディタ
export EDITOR=nano

# Gitコマンドの補完
fpath=(~/.zsh/completion $fpath)

# コマンドミスを修正
setopt correct

# 補完の選択を楽にする
zstyle ':completion:*' menu select

# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 直前と同じコマンドの場合はヒストリに追加しない
setopt hist_ignore_dups

# コマンド履歴件数
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000

# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# n
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

# 1Password
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

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
m2g() {
    ffmpeg -i $1 -r 10 ~/Desktop/output.gif
}

# Starship
eval "$(starship init zsh)"

# ghq peco
peco-src() {
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
if type brew &>/dev/null; then
    # brew completions
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    FPATH="$(brew --prefix)/share/zsh-completions:${FPATH}"

    # zsh
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

autoload -Uz compinit
compinit
