# systems

Nix configuration for Carlo's machines: a [nix-darwin](https://github.com/lnl7/nix-darwin) +
[home-manager](https://github.com/nix-community/home-manager) flake, wired together with
[flake-parts](https://flake.parts) and [nixos-flake](https://github.com/srid/nixos-flake).

Right now there is exactly one host: `invernomuto`, an `x86_64-darwin` laptop.

## Layout

| Path | What lives there |
| --- | --- |
| `flake.nix` | Inputs, pinned nixpkgs channels, the `darwinConfigurations` entry point |
| `hosts/invernomuto/` | Machine-specific bits: hostname, system packages, services toggles |
| `modules/darwin/` | macOS-level config, plus optional services (`nfsd`, `pueue`, `dmenu`) |
| `modules/nixos/` | Shared Nix settings: overlays, registry, `nixpkgs.config` |
| `modules/home/` | The user environment — zsh, git, ssh, direnv, lf, bat, Emacs, package list |
| `overlays/` | Per-package fixes and version pins (see the note below) |

The Emacs setup is the largest piece: `modules/home/emacs/` carries `emacs.el`,
a custom `rubrication-theme`, and the `agent-shell-permission-transient` package.

## Applying a change

The aliases in `modules/home/shell.nix` do the work, from anywhere:

```bash
nixactivate   # nix run .#activate in ~/src/systems — rebuild and switch
nixup         # nix run .#update   in ~/src/systems — bump the flake inputs
nixgc         # nix store gc --debug — reclaim space
```

They're defined by this repo, so on a fresh machine the first activation has to be run by hand:

```bash
nix run .#activate
```

To check that everything still evaluates, without touching the running system:

```bash
nix flake check
```

## A warning about nixpkgs channels

`invernomuto` runs macOS 12 Monterey. Packages from 2025-or-later nixpkgs revisions can be
**fetched from the binary cache and run**, but anything that needs a **local build** with that
stdenv fails — its build tools call symbols Monterey doesn't have.

That's why the flake pins several channels at once:

- `nixpkgs` — the main pin, used to build everything custom
- `nixpkgs-up` / `nixpkgs-2511` — newer, cache-only, pulled in through overlays for recent binaries
- `nixpkgs-2505` — the last channel whose stdenv still builds locally here

So: take prebuilt packages from the newer channels via an overlay, but build anything of your own
against the pinned `nixpkgs` or `nixos-25.05`.
