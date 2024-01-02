{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./rofi
    ./xmonad.nix
    ./hyprland.nix
    ./linux.nix
  ];

  home.packages = with pkgs; [
    firefox
    _1password-gui
    krita
    (ranger.override { imagePreviewSupport = true; })
    viu
    nitrogen
    betterlockscreen
    pavucontrol
    spotify
    spotify-tui
    obsidian
    waypaper
    swww
    nvtop
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
    };
  };
}
