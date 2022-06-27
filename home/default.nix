{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./starship.nix
    ./neovim.nix
    ./git.nix
    ./taskwarrior.nix
  ];

  home.packages = with pkgs; [
    htop
    ack
  ];

  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
