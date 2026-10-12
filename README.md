# dotfiles

nem's macOS dotfiles managed with [nix-darwin](https://github.com/LnL7/nix-darwin) + [home-manager](https://github.com/nix-community/home-manager)

## セットアップ

### 前提

- [Nix](https://nixos.org/) がインストール済みであること

### ビルド & 適用

```sh
darwin-rebuild switch --flake .#nem
```

## 構成

```
flake.nix          # Flake 定義 (inputs / outputs)
nix/
  darwin.nix       # nix-darwin: システム設定・Homebrew
  home.nix         # home-manager: ユーザー環境・dotfiles
apps/              # アプリ固有の設定ファイル
```

## zsh の起動高速化

Home Manager のビルド時に Starship・fzf の初期化コードを生成し、zsh の設定と
合わせて `zcompile` で事前コンパイルします。設定やパッケージを更新して適用すると、
対応するコンパイル済みファイルも自動で更新されます。

補完のキャッシュも変更時にコンパイルします。`compinit` の権限チェックと
補完ファイル数の確認は毎回実行します。補完を手動で再構築する場合は、zsh で
以下を実行してください。

```zsh
rm -f -- "$ZDOTDIR/.zcompdump" "$ZDOTDIR/.zcompdump.zwc"
exec zsh -l
```
