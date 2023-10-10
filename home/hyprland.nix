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

  programs.waybar = {
    enable = true;
    settings = [{
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "temperature" "cpu" "memory" "pulseaudio" "clock" ];
      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "󰖁";
        format-icons = {
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };
      "wlr/workspaces" = {
        active-only = false;
        format = "{name}";
        format-icons = {
          "1" = "一";
          "2" = "二";
          "3" = "三";
          "4" = "四";
          "5" = "五";
          "6" = "六";
          "7" = "七";
          "8" = "八";
          "9" = "九";
          "10" = "十";
          # "urgent" = "";
          # "active" = "";
          # "default" = "";
        };
      };
    }];
  };
} 
