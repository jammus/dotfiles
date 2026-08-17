{ pkgs, ... }:
{
  # home-manager evaluates its own nixpkgs instance (useGlobalPkgs is unset),
  # so allowUnfree must be set here rather than in the NixOS nixpkgs.config.
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./direnv.nix
    ./kitty.nix
    ./zsh.nix
    ./fish.nix
    ./starship.nix
    ./tmux.nix
    ./neovim.nix
    ./git.nix
    ./zoxide.nix
    ./fzf.nix
    ./bat.nix
    ./lsd.nix
    ./lazygit.nix
  ];

  home.packages = with pkgs; [
    btop
    ack
    _1password-cli
    wget
    tree
    age
    p7zip
    ripgrep
    nb
    pandoc # For nb
    nmap # For nb
    # w3m # For nb  # Removed because of https://github.com/xwmx/nb/issues/407
    readability-cli # For nb
    visidata
    wakeonlan
    jq
    fd
    cachix
    unzip
    mosh
    duf
    dust
    yazi
    lazydocker
    fx
    devenv
    yt-dlp
    zellij
    jujutsu
    imagemagick
    glow
    offpunk
    chafa
  ];


  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.gpg.enable = true;
}
