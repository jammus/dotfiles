{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awww
    xwayland-satellite
    swaybg
  ];

  programs.wofi = {
    enable = true;
  };

  xdg.configFile."hypr/hyprlock.conf".source = ../config/hyprlock.conf;
  xdg.configFile."hypr/hypridle.conf".source = ../config/hypridle.conf;

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
}
