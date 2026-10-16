{ pkgs, ... }:
let
  rubrication-theme = pkgs.callPackage ./rubrication-theme { inherit (pkgs.emacsPackages) trivialBuild; };
  rubricationThemePath = "${rubrication-theme}/share/emacs/site-lisp/rubrication-theme.el";
in
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs.el;
      defaultInitFile = pkgs.substituteAll {
        name = "default.el";
        src = ./emacs.el;
        inherit rubricationThemePath;
        piAcpCommand = "${pkgs.pi-acp}/bin/pi-acp";
        glsPath = "${pkgs.coreutils-prefixed}/bin/gls";
      };
      package = pkgs.emacs29-macport;
      alwaysEnsure = true;
      override = epkgs: epkgs // {
        inherit rubrication-theme;
        # not on melpa, built from git
        agent-shell-permission-transient =
          pkgs.callPackage ./agent-shell-permission-transient {
            inherit (epkgs) trivialBuild agent-shell transient;
          };
      };
      extraEmacsPackages = epkgs: with epkgs; [
        use-package
      ];
    };
  };
}
