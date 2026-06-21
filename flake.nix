{
  description = "nem's home-manager configuration";

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

    claude-code-overlay.url = "github:ryoppippi/claude-code-overlay";
  };

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
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      flake = {
        # darwin + home-manager（統合）
        darwinConfigurations."${username}" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs username homedir; };
          modules = [
            ./nix/darwin.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [
                brew-nix.overlays.default
                inputs.claude-code-overlay.overlays.default
              ];
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit username homedir; };
                users.${username} = import ./nix/home.nix;
              };
            }
          ];
        };

        # darwin のみ（home-manager なし）
        darwinConfigurations."${username}-system" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs username homedir; };
          modules = [
            ./nix/darwin.nix
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [
                brew-nix.overlays.default
                inputs.claude-code-overlay.overlays.default
              ];
            }
          ];
        };

        # home-manager のみ (macOS)
        homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."aarch64-darwin";
          extraSpecialArgs = { inherit username homedir; };
          modules = [ ./nix/home.nix
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [
                inputs.claude-code-overlay.overlays.default
              ];
            }
          ];
        };

        # home-manager のみ (WSL Ubuntu / Linux)
        homeConfigurations."${username}-linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit username; homedir = "/home/${username}"; };
          modules = [ ./nix/home.nix 
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [
                inputs.claude-code-overlay.overlays.default
              ];
            }];
        };
      };

      perSystem =
        { pkgs, inputs', ... }:
        {
          apps = {
            # home.nix のみ反映 (macOS): nix run .#switch-home
            switch-home = {
              type = "app";
              program = toString (
                pkgs.writeShellScript "switch-home" ''
                  exec ${inputs'.home-manager.packages.default}/bin/home-manager switch --flake "${self}#${username}" "$@"
                ''
              );
            };

            # home.nix のみ反映 (Linux): nix run .#switch-home-linux
            switch-home-linux = {
              type = "app";
              program = toString (
                pkgs.writeShellScript "switch-home-linux" ''
                  exec ${inputs'.home-manager.packages.default}/bin/home-manager switch --flake "${self}#${username}-linux" "$@"
                ''
              );
            };

            # darwin.nix のみ反映: nix run .#switch-darwin
            switch-darwin = {
              type = "app";
              program = toString (
                pkgs.writeShellScript "switch-darwin" ''
                  exec sudo darwin-rebuild switch --flake "${self}#${username}-system" "$@"
                ''
              );
            };

            # darwin + home-manager 統合反映: nix run .#switch
            switch = {
              type = "app";
              program = toString (
                pkgs.writeShellScript "switch" ''
                  ${pkgs.nix}/bin/nix flake update claude-code-overlay
                  exec sudo darwin-rebuild switch --flake "$PWD#${username}" "$@"
                ''
              );
            };
          };
        };
    };
}
