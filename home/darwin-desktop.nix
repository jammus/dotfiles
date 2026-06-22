{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./emacs.nix
  ];

  home.packages = with pkgs; [
    viu
    jetbrains.idea-ultimate
    obsidian
  ];
}
