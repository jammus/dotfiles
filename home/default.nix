{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./kitty.nix
    ./zsh.nix
    ./fish.nix
    ./starship.nix
    ./tmux.nix
    ./neovim.nix
    ./git.nix
    ./taskwarrior.nix
    ./zoxide.nix
    ./fzf.nix
    ./bat.nix
    ./lsd.nix
    ./lazygit.nix
  ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      pkgs.lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0"
    ];
  };

  home.packages = with pkgs; [
    btop
    ack
    _1password
    wget
    tree
    gopass
    age
    p7zip
    ripgrep
    nb
    pandoc # For nb
    nmap # For nb
    w3m # For nb
    readability-cli # For nb
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
    yazi
    lazydocker
    fx
    devenv
    yt-dlp
    zellij
    pastel
    imagemagick
  ];


  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.gpg.enable = true;
}
