{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    #./i3.nix
    ./xmonad.nix
  ];

  home.packages = with pkgs; [
    firefox
    _1password-gui
  ];
}
