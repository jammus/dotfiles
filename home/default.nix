{ pkgs, ... }:
{
  imports = [
    ./i3.nix
    ./zsh.nix
    ./neovim.nix
    ./git.nix
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
