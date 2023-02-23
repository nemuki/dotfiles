# エディタ
export EDITOR=nano

# パスの重複をなくす
typeset -U path cdpath fpath manpath infopath

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

# 余分な空白は詰めて記録
setopt hist_reduce_blanks

# コマンド履歴件数
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=10000

# brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# go
export PATH=${HOME}/go/bin:${PATH}

# n
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

# 1Password
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# alias
alias ls="lsd"
alias ll="lsd -l"
alias la="lsd -la"
alias lt="lsd --tree"
alias ncu="npx npm-check-updates"
alias cls="clear"
alias ghq-update="ghq list | ghq get --update --parallel"
alias relogin="exec $SHELL -l"
alias java_home="/usr/libexec/java_home -V"
alias z="nano ~/.zshrc"
alias s="source ~/.zshrc"
alias c="code ."
alias cz="code ~/.zshrc"
alias dc="docker compose"

# function
m2g() {
    ffmpeg -i $1 -r 10 ~/Desktop/output.gif
}
delete-whitespace-new-line() {
    foo="$(echo $1 | tr -d ' ')"
    bar="$(echo $foo | tr -d '\n')"
    echo $bar
}
fssh() {
    grep -i '^host [^*]' ~/.ssh/config | cut -d ' ' -f 2 | fzf | xargs -o ssh
}
base64-encode() {
    echo -n "$1" | base64
}
base64-decode() {
    echo -n "$1" | base64 -D
}
awsp() {
    if [ $# -ge 1 ]; then
        AWS_PROFILE="$1"
        echo "Set AWS_PROFILE=$AWS_PROFILE."
    else
        AWS_PROFILE=$(sed -n "s/\]//g; s/\[profile //gp" ~/.aws/config | peco)
    fi
    awsume $AWS_PROFILE -a
}
awscl() {
    if [ $# -ge 1 ]; then
        AWS_PROFILE="$1"
    else
        AWS_PROFILE=$(sed -n "s/\]//g; s/\[profile //gp" ~/.aws/config | peco)
    fi
    awsume $AWS_PROFILE -cl
}
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

# Starship
eval "$(starship init zsh)"

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

    autoload -Uz compinit
    compinit
fi

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
