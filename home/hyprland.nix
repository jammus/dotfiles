{ config, pkgs, inputs, ... }:
{
  xdg.configFile."hypr/hyprland.conf".source = ../config/hyprland.conf;

  # imports = [
    # inputs.hyprland.homeManagerModules.default
  # ];

  # wayland.windowManager.hyprland = {
    # enable = true;
    # package = pkgs.hyprland;
    # systemdIntegration = true;
    # extraConfig = ''
      # bind=SUPER,j,cyclenext,prev
      # bind=SUPER,k,cyclenext,next
    # '';
    # xwayland = {
      # enable = true;
      # hidpi = true;
    # };
  # };
  programs.wofi = {
    enable = true;
  };
} 
