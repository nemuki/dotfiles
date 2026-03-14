{
  description = "nem's home-manager configuration"

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs = {
        brew-api.follows = "brew-api";
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
      };
    };

    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
  }

  outputs = 
    inputs@{
      self,
      flake-parts,
      home-manager,
      nixpkgs,
      nix-darwin,
      brew-nix,
      ...
    }:
    let
      username = "nem";
      homedir = "/Users/${username}";

      # Create pkgs with overlays
      mkPkgs =
        system:
        let
          isDarwin = builtins.match ".*-darwin" system != null;
        in
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          # overlays = [
          #   llm-agents.overlays.default
          #   (_final: _prev: {
          #     _claude-code-overlay = claude-code-overlay;
          #   })
          #   gh-nippou.overlays.default
          #   gh-graph.overlays.default
          #   (import ./nix/overlays/default.nix)
          # ]
          ++ nixpkgs.lib.optionals isDarwin [
            brew-nix.overlays.default
          ];
        };
}

