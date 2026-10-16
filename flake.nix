{
  description = "Carlo's Nix systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-2511.url = "github:NixOS/nixpkgs/107cba9eb4a8d8c9f8e9e61266d78d340867913a";
    nixpkgs-up.url = "github:NixOS/nixpkgs/68e5b9f7e82a76a5171d10b5d316e0ae5e1df6e9";
    # last channel whose stdenv still builds on macOS 12
    nixpkgs-2505.url = "github:NixOS/nixpkgs/nixos-25.05";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixos-flake.url = "github:srid/nixos-flake";

    emacs-overlay = {
      url = "github:carloaromando/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcasks = {
      url = "github:jacekszymanski/nixcasks";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        systems = [ "x86_64-darwin" ];

        imports = [
          inputs.nixos-flake.flakeModule
          ./modules/nixos
          ./modules/home
          ./modules/darwin
        ];

        flake = {
          # Configurations for macOS machines
          darwinConfigurations = {
            invernomuto = self.nixos-flake.lib.mkMacosSystem {
              nixpkgs.hostPlatform = "x86_64-darwin";

              imports = [
                self.darwinModules.default
                ./hosts/invernomuto
                ./modules/darwin/services/nfsd.nix
                ./modules/darwin/services/dmenu.nix
                ./modules/darwin/services/pueue.nix
              ];
            };
          };
        };
      };
}
