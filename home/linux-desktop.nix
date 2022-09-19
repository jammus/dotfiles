{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./kitty.nix
    ./rofi.nix
    ./xmonad.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    firefox
    _1password-gui
    krita
    (ranger.override { imagePreviewSupport = true; })
    jetbrains.idea-ultimate
  ];
}
