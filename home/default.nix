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
    tig
    bat
    nb
    pandoc # For nb
    nmap # For nb
    w3m # For nb
    visidata
    magic-wormhole
    wakeonlan
    jq
    lsd
    fd
  ];


  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.gpg.enable = true;
}
