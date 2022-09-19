{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./kitty.nix
    #./i3.nix
    ./rofi.nix
    ./xmonad.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    firefox
    _1password-gui
  ];
}