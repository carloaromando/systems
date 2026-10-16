{ nixpkgs, ... }:

final: prev:
let
  up = import nixpkgs {
    inherit (prev) system;
    config.allowUnfree = true;
  };
in
{
  # https://pi.dev - `pi` coding agent cli
  pi-coding-agent = up.pi-coding-agent;

  # acp adapter for pi, needed by emacs agent-shell.
  # built with the pinned nixpkgs (the newer stdenv doesn't run on macOS 12),
  # but run with a recent node, which pi-acp requires
  pi-acp = final.callPackage ./pi-acp.nix {
    runtimeNodejs = up.nodejs_24;
  };
}
