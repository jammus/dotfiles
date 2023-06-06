{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./kitty.nix
    ./zsh.nix
    ./starship.nix
    ./tmux.nix
    ./neovim.nix
    ./git.nix
    ./taskwarrior.nix
    ./zoxide.nix
    ./fzf.nix
    ./helix.nix
    ./bat.nix
    ./lsd.nix
    ./lazygit.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    htop
    btop
    ack
    _1password
    wget
    tree
    gopass
    age
    p7zip
    ripgrep
    bat
    nb
    pandoc # For nb
    nmap # For nb
    w3m # For nb
    visidata
    magic-wormhole
    wakeonlan
    jq
    fd
    cachix
    unzip
    mosh
    duf
    du-dust
  ];


  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.gpg.enable = true;
}
