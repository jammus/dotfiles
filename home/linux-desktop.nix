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
    pamixer
    bluez
    bluez-tools
    spotify
    obsidian
    waypaper
    swww
    nvtopPackages.full
    discord
    feishin
    ollama-cuda
    librewolf
    xwayland-satellite
    swaybg
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
    };
  };

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
    cursor = {
      name = "vanilla-dmz";
      size = 24;
      package = pkgs.vanilla-dmz;
    };
    targets = {
      wofi.enable = true;
      fuzzel.enable = true;
      zellij.enable = true;
      lazygit.enable = true;
      hyprlock.enable = true;
      btop.enable = true;
    };
  };
}
