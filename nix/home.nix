{
  config,
  pkgs,
  username,
  homedir,
  ...
}:
{
  home = {
    inherit username;
    homeDirectory = homedir;
    stateVersion = "25.11";

    sessionVariables = {
      EDITOR = "nano";
    };
  };

  # XDG Base Directory
  xdg = {
    enable = true;
    configHome = "${homedir}/.config";
  };

  # Packages
  home.packages = with pkgs; [
    bat
    coreutils
    fd
    ffmpeg
    fzf
    gh
    ghq
    gnupg
    grpcurl
    htop
    jq
    lsd
    mkcert
    nano
    peco
    pipx
    stow
    tree
    uv
    vim
    volta
    wget
    starship
    libpq
    pinact
    pinentry_mac
    jira-cli-go
  ];

  # Git
  programs.git = {
    enable = true;

    signing = {
      key = "2C41A1E5F13D96EF8916499EDE8090BBB3C7A57B";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Naoki Takahashi";
        email = "43571743+nemuki@users.noreply.github.com";
      };
      alias = {
        delete-marged-branch = "!f () { git branch --merged | egrep -v '\\*|develop|main|master|release' | xargs git branch -d; git fetch --prune; };f";
        pushf = "push --force-with-lease --force-if-includes";
        swc = "switch --create";
        sw = "switch";
      };
      core.autocrlf = "input";
      commit.gpgsign = true;
      gpg.program = "${pkgs.gnupg}/bin/gpg";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Zsh  (.zshrc 相当)
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      path = "${config.xdg.configHome}/zsh/.zsh_history";
      size = 100000;
      save = 1000000;
      ignoreDups = true;
      share = true;
    };

    setOptions = [
      "correct"
      "hist_reduce_blanks"
    ];

    shellAliases = {
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -la";
      lt = "lsd --tree";
      ncu = "npx npm-check-updates";
      cls = "clear";
      ghq-update = "ghq list | ghq get --update --parallel";
      relogin = "exec $SHELL -l";
      java_home = "/usr/libexec/java_home -V";
      z = "nano ~/.zshrc";
      s = "source ~/.zshrc";
      c = "code .";
      cz = "code ~/.zshrc";
      dc = "docker compose";
      jira = "op run -- jira";
    };

    initContent = ''
      # 補完の選択を楽にする
      zstyle ':completion:*' menu select

      # 補完で大文字にもマッチ
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

      # GPG
      export GPG_TTY=$(tty)
    '';
  };

  # Starship
  programs.starship = {
    enable = true;
    settings = {
      directory = {
        truncation_length = 100;
        truncate_to_repo = false;
      };
      aws = {
        format = "on [aws: ($profile, )($region)]($style),";
        force_display = true;
      };
      time.disabled = false;
    };
  };

  # Nano
  xdg.configFile."nano/nanorc".text = ''
    include "${pkgs.nano}/share/nano/*.nanorc"
    set linenumbers
    set autoindent
    set tabsize 4
    set tabstospaces
  '';

  # bat
  programs.bat = {
    enable = true;
    config.theme = "ansi";
  };

  programs.home-manager.enable = true;
}
