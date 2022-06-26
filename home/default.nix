{ pkgs, ... }:
{
  imports = [
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
