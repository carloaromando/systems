{ self, ... }:
{
  # Configuration common to all macOS systems
  flake = {
    darwinModules = {
      home = {
        home-manager.users.carlo = { pkgs, ... }: {
          imports = [
            self.homeModules.default
            self.inputs.mac-app-util.homeManagerModules.default
            self.inputs.nix-index-database.homeModules.default
            { programs.nix-index-database.comma.enable = true; }
          ];
        };
      };

      default.imports = [
        self.darwinModules_.home-manager
        self.darwinModules.home
        self.nixosModules.common
      ];
    };
  };
}
