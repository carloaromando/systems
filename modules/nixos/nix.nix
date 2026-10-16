{ flake, pkgs, ... }:
{
  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
      packageOverrides = _: {
        nixcasks = import flake.inputs.nixcasks {
          inherit (flake.inputs) nixpkgs;
          pkgs = pkgs;
          osVersion = "monterey";
        };
      };
    };
    overlays = [
      flake.inputs.emacs-overlay.overlays.default
      (import ../../overlays/ytdlp.nix { nixpkgs = flake.inputs.nixpkgs-up; })
      (import ../../overlays/pi.nix { nixpkgs = flake.inputs.nixpkgs-up; })
      # (import ../../overlays/coder.nix { nixpkgs = flake.inputs.nixpkgs-2505; })
    ];
  };

  nix = {
    package = pkgs.nixUnstable;
    registry.nixpkgs.flake = flake.inputs.nixpkgs-up; # Make `nix shell` etc use pinned nixpkgs
    nixPath = [
      "nixpkgs=${flake.inputs.nixpkgs}"
      "nix-darwin=${flake.inputs.nix-darwin}"
      "home-manager=${flake.inputs.home-manager}"
    ];
    settings = {
      max-jobs = "auto";
      experimental-features = "nix-command flakes repl-flake"; # pipe-operators
      trusted-users = [ "root" "carlo" ];
      accept-flake-config = true;
      extra-nix-path = "nixpkgs=flake:nixpkgs";
    };
    # extraOptions = ''
    #   keep-outputs = true
    #   keep-derivations = true
    # '';
    gc = {
      automatic = pkgs.lib.mkDefault true;
      options = pkgs.lib.mkDefault "--delete-older-than 1w";
    };
  };
}
