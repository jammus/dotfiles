{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    viu
    jetbrains.idea-ultimate
    obsidian
  ];
}
