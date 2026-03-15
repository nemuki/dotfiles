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
