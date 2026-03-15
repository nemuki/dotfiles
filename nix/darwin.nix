{
  pkgs,
  username,
  homedir,
  ...
}:
{
  # --------------------------------------------------------------------------
  # Nix settings
  # --------------------------------------------------------------------------
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

  # --------------------------------------------------------------------------
  # System packages
  # --------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    git
  ];

  # --------------------------------------------------------------------------
  # Homebrew (casks / macOS-specific formulas)
  # --------------------------------------------------------------------------
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

  # --------------------------------------------------------------------------
  # macOS system defaults
  # --------------------------------------------------------------------------
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3; # フルキーボードアクセス
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      _HIHideMenuBar = false;
    };

    trackpad = {
      Clicking = true; # タップでクリック
      TrackpadThreeFingerDrag = true;
    };
  };

  # --------------------------------------------------------------------------
  # Shell / Users
  # --------------------------------------------------------------------------
  programs.zsh.enable = true;

  users.users.${username} = {
    home = homedir;
    shell = pkgs.zsh;
  };

  system.stateVersion = 5;
}
