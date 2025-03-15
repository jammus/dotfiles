{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./rofi
    ./xmonad.nix
    ./hyprland.nix
    ./waybar.nix
    ./niri.nix
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
    obsidian
    waypaper
    swww
    nvtopPackages.full
    discord
    feishin
    ollama-cuda
    xwayland-satellite
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
    };
  };
}
