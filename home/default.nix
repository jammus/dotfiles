{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./zsh.nix
    ./starship.nix
    ./tmux.nix
    ./neovim.nix
    ./git.nix
    ./taskwarrior.nix
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
  ];

  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "vim";
    TMUX_TMPDIR = "/tmp";
  };
}
