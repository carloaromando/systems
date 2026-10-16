{ self, ... }:
{
  flake = {
    homeModules = {
      base = {
        imports = [
          ./shell.nix
          ./direnv.nix
          ./zsh.nix
          ./git.nix
          ./ssh.nix
          ./bat.nix
          ./lf.nix
          ./lisp.nix
        ];

        home.stateVersion = "24.05";

        programs.home-manager.enable = true;
      };

      default = {
        imports = [
          self.homeModules.base
          ./pkgs.nix
          ./pass.nix
          ./emacs
        ];

        home.sessionVariables = {
          GOPATH = "$HOME/.go/";
          BROWSER = "firefox";
        };
      };
    };
  };
}
