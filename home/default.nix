{ pkgs, ... }:
{
  imports = [
    ./direnv.nix
    ./zsh.nix
    ./starship.nix
    ./neovim.nix
    ./git.nix
    ./taskwarrior.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    htop
    ack
    _1password
  ];

  home.stateVersion = "22.05";

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
