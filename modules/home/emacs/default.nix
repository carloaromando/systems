{ pkgs, flake, lib, ... }:
let
  rubrication-theme = pkgs.callPackage ./rubrication-theme { inherit (pkgs.emacsPackages) trivialBuild; };
  rubricationThemePath = "${rubrication-theme}/share/emacs/site-lisp/rubrication-theme.el";
  agentSessionManagerOverlay =
    flake.inputs.agent-session-manager.overlays.default;
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
      override = lib.composeManyExtensions [
        agentSessionManagerOverlay
        (final: prev: {
          inherit rubrication-theme;
          # not on melpa, built from git
          agent-shell-permission-transient =
            pkgs.callPackage ./agent-shell-permission-transient {
              inherit (prev) trivialBuild agent-shell transient;
            };
        })
      ];
      extraEmacsPackages = epkgs: with epkgs; [
        use-package
      ];
    };
  };
}
