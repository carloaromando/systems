{ self, ... }:
{
  flake = {
    nixosModules = {
      common.imports = [
        ./nix.nix
      ];

      home-base = {
        home-manager.users.carlo = { pkgs, ... }: {
          imports = [
            self.homeModules.base
            self.inputs.nix-index-database.homeModules.default
            { programs.nix-index-database.comma.enable = true; }
          ];
        };
      };

      minimal.imports = [
        self.nixosModules.home-manager
        self.nixosModules.home-base
        self.nixosModules.common
      ];
    };
  };
}
