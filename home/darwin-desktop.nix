{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    postman
    viu
    jetbrains.idea-ultimate
  ];
}
