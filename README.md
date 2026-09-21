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

## Git ユーティリティ

`git delete-merged-branch` は、デフォルトブランチに取り込まれたローカルブランチを削除します。
通常の merge に加え、GitHub 上で merge 済みの PR とブランチ先端のコミットが一致する場合は、
squash merge / rebase merge されたブランチも削除できます。

```sh
# 削除対象を確認
git delete-merged-branch --dry-run

# 削除を実行
git delete-merged-branch
```

旧名 `git delete-marged-branch` も互換性のため利用できます。
