{ pkgs, ... }:
{
  imports = [
    ./linux.nix
    ./niri.nix
    ./alacritty.nix
    ./waybar.nix
    ./ghostty.nix
    ./wayland.nix
  ];

  home.packages = with pkgs; [
    firefox
    _1password-gui
    krita
    viu
    pavucontrol
    pamixer
    bluez
    bluez-tools
    obsidian
    nvtopPackages.full
    discord
    feishin
    librewolf
    nautilus
  ];

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
