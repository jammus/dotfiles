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
      height = 32;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "cpu" "temperature" "memory" "pulseaudio" "clock" ];
      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "󰖁";
        format-icons = {
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };
      "hyprland/workspaces" = {
        active-only = false;
        persistent-workspaces = {
          "*" = 9;
        };
        format = "{icon}";
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
          "11" = "一";
          "12" = "二";
          "13" = "三";
          "14" = "四";
          "15" = "五";
          "16" = "六";
          "17" = "七";
          "18" = "八";
          "19" = "九";
          "20" = "十";
          # "urgent" = "";
          # "active" = "";
          # "default" = "";
        };
      };
      "cpu" = {
        format = "  {usage}%";
      };
      "memory" = {
        format = "󰘚  {percentage}%";
      };
    }];
  };
} 
