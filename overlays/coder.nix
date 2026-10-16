{ nixpkgs, ... }:

# currently unwired - see modules/nixos/nix.nix.
#
# coder 0.17.1 from the pinned nixpkgs no longer builds: gvisor's build
# constraints exclude every go file, so no binary comes out. pass nixpkgs-2505
# here: nixpkgs-up's coder needs a local build, which macOS 12 can't do.
final: prev: {
  coder = (import nixpkgs {
    inherit (prev) system;
    config.allowUnfree = true;
  }).coder;
}
