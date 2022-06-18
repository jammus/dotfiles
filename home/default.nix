{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./i3.nix
    ./zsh.nix
    ./starship.nix
    ./neovim.nix
    ./git.nix
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
