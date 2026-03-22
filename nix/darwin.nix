# https://nix-darwin.github.io/nix-darwin/manual/index.html
{
  pkgs,
  username,
  homedir,
  ...
}:
{
  # Nix settings
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      username
    ];
  };

  # Shell / Users
  programs.zsh.enable = true;

  users.users.${username} = {
    home = homedir;
    shell = pkgs.zsh;
  };

  # Enable Touch ID for sudo (including tmux support via pam-reattach)
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  # macOS system defaults
  system = {
    stateVersion = 5;
    primaryUser = username;

    defaults = {
      dock = {
        autohide = false;
        tilesize = 40; # アイコンサイズ
        show-recents = false; # 最近使ったアプリを表示しない
        mru-spaces = false; # 最近使ったスペースを表示しない
        mineffect = "scale"; # ウィンドウを開くときのアニメーション
        minimize-to-application = true; # ウィンドウをアプリケーションアイコンに格納
        persistent-others = [
          # 最近使ったアプリを表示するスペース
          {
            folder = {
              path = "/Users/${username}/Desktop";
              showas = "fan";
            };
          }
          {
            folder = {
              path = "/Users/${username}/Downloads";
              showas = "fan";
            };
          }
        ];
        wvous-bl-corner = 11; # 左下のホットコーナーを「Launchpad」に設定
        wvous-tr-corner = 12; # 右上のホットコーナーを「通知センター」に設定
      };

      # Finder 設定
      finder = {
        AppleShowAllExtensions = true; # 拡張子を常に表示
        ShowPathbar = true;
        ShowStatusBar = false;
        FXPreferredViewStyle = "clmv"; # リスト表示をデフォルトにする
        NewWindowTarget = "Home"; # 新しい Finder ウィンドウをホームディレクトリにする
      };

      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true; # ダークモードを自動で切り替える
        InitialKeyRepeat = 15; # キーリピートの初期遅延を短くする
        KeyRepeat = 2; # キーリピートの速度を速くする
        _HIHideMenuBar = false; # メニューバーを常に表示
        "com.apple.keyboard.fnState" = true; # F1-F12 をファンクションキーとして使用（メディアキーではなく）
      };

      trackpad = {
        Clicking = true; # タップでクリック
        TrackpadRightClick = true; # 2本指で右クリック
      };

      screencapture = {
        disable-shadow = true; # スクリーンショットの影を消す
        type = "png"; # スクリーンショットのファイル形式
      };

      menuExtraClock.ShowSeconds = true; # メニューバーの時計に秒を表示
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
  ];

  # Homebrew (casks / macOS-specific formulas)
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "zap"; # Brewfile 外のパッケージを削除
    };

    brews = [
      "mas"
    ];

    casks = [
      "1password"
      "docker-desktop"
      "font-cica"
      "font-hackgen"
      "font-hackgen-nerd"
      "iterm2"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keyboardcleantool"
      "raycast"
      "google-chrome"
      "visual-studio-code"
      "visual-studio-code@insiders"
    ];

    masApps = {
      "Microsoft Excel" = 462058435;
      "Slack" = 803453959;
      "The Unarchiver" = 425424353;
      "RunCat" = 1429033973;
    };
  };
}
