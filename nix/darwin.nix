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
    taps = [
      "ankitpokhrel/jira-cli"
    ];
    brews = [
      "openssl@3"
      "icu4c@76"
      "jira-cli"
      "libpq"
      "mas"
      "pinact"
      "pinentry-mac"
    ];
    casks = [
      "1password-cli"
      "claude-code"
      "font-cica"
      "font-hackgen"
      "font-hackgen-nerd"
      "iterm2"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keyboardcleantool"
      "raycast"
      "visual-studio-code"
    ];
  };

  # macOS system defaults
  system.defaults = {
    dock = {
      autohide = false;
      tilesize = 40; # アイコンサイズ
      show-recents = false; # 最近使ったアプリを表示しない
      mru-spaces = false; # 最近使ったスペースを表示しない
      mineffect = "scale"; # ウィンドウを開くときのアニメーション
      minimize-to-application = true; # ウィンドウをアプリケーションアイコンに格納
      persistent-others = [ # 最近使ったアプリを表示するスペース
        { folder = "/Users/${username}/Desktop"; }
        { folder = "/Users/${username}/Downloads"; }
      ];
      static-only = true; # 開いているアプリのみを表示
      wvous-bl-corner = 11; # 左下のホットコーナーを「Launchpad」に設定
      wvous-tr-corner = 12; # 右上のホットコーナーを「通知センター」に設定
    };

    # Finder 設定
    finder = {
      AppleShowAllExtensions = true; # 拡張子を常に表示
      ShowPathbar = true;
      ShowStatusBar = true;
      FXPreferredViewStyle = "Nlsv"; # リスト表示をデフォルトにする
    };

    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true; # ダークモードを自動で切り替える
      InitialKeyRepeat = 15; # キーリピートの初期遅延を短くする
      KeyRepeat = 2; # キーリピートの速度を速くする
      _HIHideMenuBar = false; # メニューバーを常に表示
    };

    trackpad = {
      Clicking = true; # タップでクリック
      TrackpadRightClick = true; # 2本指で右クリック
    };
  };

  # Shell / Users
  programs.zsh.enable = true;

  users.users.${username} = {
    home = homedir;
    shell = pkgs.zsh;
  };

  system.stateVersion = 5;
  system.primaryUser = username;
}
