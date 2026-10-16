{ nixpkgs, ... }:

final: prev: {
  yt-dlp = nixpkgs.legacyPackages.${prev.system}.yt-dlp;
}
