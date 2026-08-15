{ pkgs, ... }:
{
  imports = [
    ./linux.nix
    ./niri.nix
    ./xmonad.nix
    ./hyprland.nix
    ./alacritty.nix
    ./rofi
    ./waybar.nix
    ./ghostty.nix
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
    awww
    nvtopPackages.full
    discord
    feishin
    oterm
    librewolf
    xwayland-satellite
    fuzzel
    swaybg
    nautilus
  ];

  wayland.windowManager.sway = {
    enable = false;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
    };
  };

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
    image = ../assets/wallpaper_r.jpg;
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
