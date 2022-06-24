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

  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
