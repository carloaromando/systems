{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # shell
    pinentry_mac # TODO move to macos only file
    pv
    entr
    coreutils-prefixed
    rlwrap

    # networking
    iperf
    websocat
    kcat
    shell2http
    tailscale

    ## nix 
    nixpkgs-fmt

    ## python
    python3

    ## go
    go

    ## agentic
    pi-coding-agent
    pi-acp

    # virtualization
    qemu

    # container
    docker
    kubernetes-helm
    kubectl
    kubectx
    k9s

    # media
    ffmpeg_5
    yt-dlp
    localsend
    mupdf
  ] ++ (with nixcasks; [
    iina
    vlc
    alfred
    orbstack
  ]);
}
