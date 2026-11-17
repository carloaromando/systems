{ nixpkgs, ... }:

final: prev:
let
  # agent-skills cli. needs go >= 1.26, which the pinned nixpkgs doesn't have,
  # so the newer toolchain is borrowed - but the build itself stays on the
  # pinned stdenv, since nixpkgs-up's coreutils won't run on macOS 12.
  buildGoModule = prev.buildGoModule.override {
    go = nixpkgs.legacyPackages.${prev.system}.go;
  };
in
{
  kungfu = buildGoModule rec {
    pname = "kungfu";
    version = "0.6.5";

    src = prev.fetchFromGitHub {
      owner = "danicat";
      repo = "kungfu";
      rev = "v${version}";
      hash = "sha256-0zETpSHVU6pJSPfIrlIhlBGzoXBX1T1nKAJM0KKibuU=";
    };

    vendorHash = "sha256-g+yaVIx4jxpAQ/+WrGKxhVeliYx7nLQe/zsGpxV4Fn4=";

    meta = {
      description = "CLI to discover, stream and install Agent Skills for AI coding agents";
      homepage = "https://github.com/danicat/kungfu";
      license = prev.lib.licenses.asl20;
      mainProgram = "kungfu";
    };
  };
}
