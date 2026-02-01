{ pkgs, ... }:
{
  xdg.configFile."waybar/style.css".source = ../config/waybar.css;

  programs.waybar = {
    enable = true;
    settings = [{
      position = "bottom";
      height = 52;
      modules-left = [ "hyprland/workspaces" "niri/workspaces" ];
      modules-right = [ "cpu" "temperature" "memory" "pulseaudio" "clock" ];
      pulseaudio = {
        format = " <span color=\"#89b482\">:vol</span> <span color=\"#a9b665\">\"{volume}%\"</span>";
        format-muted = "󰖁 ";
        format-icons = {
          default = [" " " " " "];
        };
        on-click = "pavucontrol";
      };
      "niri/workspaces" = {
        active-only = false;
        persistent-workspaces = {
          "DP-1" = [ 1 2 3 4 5 6 7 8 9];
          "DP-2" = [ 11 12 13 14 15 16 17 18 19];
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
      "hyprland/workspaces" = {
        active-only = false;
        persistent-workspaces = {
          "DP-1" = [ 1 2 3 4 5 6 7 8 9];
          "DP-2" = [ 11 12 13 14 15 16 17 18 19];
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
        format = "{{<span color=\"#89b482\">:cpu</span> <span color=\"#a9b665\">\"{usage}%\"</span>";
      };
      "temperature" = {
        format = " <span color=\"#89b482\">:temp</span> <span color=\"#a9b665\">\"{temperatureC}°C\"</span>";
      };
      "memory" = {
        format = " <span color=\"#89b482\">:mem</span> <span color=\"#a9b665\">\"{percentage}%\"</span>";
      };
      "clock" = {
        format = " <span color=\"#89b482\">:now</span> [[<span color=\"#d3869b\">{0:%Y %m %d}</span>] [<span color=\"#d3869b\">{0:%H %M}</span>]]}}";
      };
    }];
  };
}
