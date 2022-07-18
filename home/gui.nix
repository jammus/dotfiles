{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./i3.nix
  ];

  home.packages = with pkgs; [
    firefox
    _1password-gui
  ];
}
