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
    _1password-cli
    bat
    coreutils
    fd
    ffmpeg
    fzf
    gh
    ghq
    grpcurl
    jq
    lsd
    mkcert
    nano
    peco
    tree
    uv
    vim
    wget
    starship
    libpq
    pinact
    jira-cli-go
    openssh
    nixfmt
    p7zip
  ];

  # Git
  programs.git = {
    enable = true;

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKylmdpY+HATtBHZpGfG05KZe7T05MOt49Oj9PR612IE";
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
      gpg = {
        format = "ssh";
        ssh = {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
      };
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
      "share_history"
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

      function zipwin () {
        if [ -z $1 ] || [ $1 = . ]; then
          # 現在の作業ディレクトリをZIPファイルに圧縮する．
          local zip_name="$(basename $(pwd)).zip"
          fd --type file --strip-cwd-prefix . -X 7z a -tzip -scsWIN $zip_name {}
        else
          # 指定したディレクトリをZIPファイルに圧縮する．
          local loc_dir=$(dirname $1)
          local target=$(basename $1)
          local zip_name="$(pwd)/''${target}.zip"
          fd --type file --base-directory=$loc_dir . $target -X 7z a -tzip -scsWIN $zip_name {}
        fi

        # 作成したZIPファイルに含まれるファイルを確認する．不要であればコメントアウトしてください．
        7z l $zip_name

        return 0
      }

      # peco-src: ghq + peco でリポジトリに移動
      peco-src() {
          local repo=$(ghq list | peco --query "$LBUFFER")
          if [ -n "$repo" ]; then
              repo=$(ghq list --full-path --exact $repo)
              BUFFER="cd ''${repo}"
              zle accept-line
          fi
          zle clear-screen
      }
      zle -N peco-src
      bindkey '^]' peco-src
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

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        identityAgent = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      };
    };
  };

  programs.home-manager.enable = true;
}
