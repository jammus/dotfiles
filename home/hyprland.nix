{ config, pkgs, inputs, ... }:
{
  xdg.configFile."hypr/hyprlock.conf".source = ../config/hyprlock.conf;

  xdg.configFile."hypr/hypridle.conf".source = ../config/hypridle.conf;
  xdg.configFile."waybar/style.css".source = ../config/waybar.css;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mainMod" = "SUPER";

      monitor = [
        "DP-1,preferred,auto,auto,vrr,1"
        "DP-2,preferred,0x0,auto,transform,3"
      ];
      workspace = [
        "DP-1,2"
        "DP-2,12"

        "1,monitor:DP-1"
        "2,monitor:DP-1"
        "3,monitor:DP-1"
        "4,monitor:DP-1"
        "5,monitor:DP-1"
        "6,monitor:DP-1"
        "7,monitor:DP-1"
        "8,monitor:DP-1"
        "9,monitor:DP-1"

        "11,monitor:DP-2"
        "12,monitor:DP-2"
        "13,monitor:DP-2"
        "14,monitor:DP-2"
        "15,monitor:DP-2"
        "16,monitor:DP-2"
        "17,monitor:DP-2"
        "18,monitor:DP-2"
        "19,monitor:DP-2"
      ];

      input = {
          kb_file = "";
          kb_layout = "";
          kb_variant = "";
          kb_model = "";
          kb_options = "caps:escape";
          kb_rules = "";

          follow_mouse = 0;

          touchpad = {
              natural_scroll = "no";
          };

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "0xff7daea3";
          "col.inactive_border" = "0x667daea3";
          apply_sens_to_raw = 0; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
          layout = "dwindle";
      };

      decoration = {
          rounding = 8;
          dim_inactive = true;
          dim_strength = 0.1;
          drop_shadow = false;
          blur = {
            enabled = true;
            size = 3; # minimum 1
            passes = 1; # minimum 1
          };
      };

      animations = {
          enabled = 1;
          animation = [
            "windows,1,5,default"
            "border,1,10,default"
            "fade,1,10,default"
            "workspaces,0,6,default"
          ];
      };

      dwindle = {
          pseudotile = 0; # enable pseudotiling on dwindle
      };

      gestures = {
          workspace_swipe = "no";
      };

      misc = {
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = false;
        disable_hyprland_logo = true;
        vrr = 1;
      };

      # sets repeatable binds for moving and resizing the active window
      binde=[
        "$mainMod ALT,right,resizeactive,10 0"
        "$mainMod ALT,left,resizeactive,-10 0"
        "$mainMod ALT,up,resizeactive,0 -10"
        "$mainMod ALT,down,resizeactive,0 10"

        "$mainMod CTRL ALT,right,moveactive,10 0"
        "$mainMod CTRL ALT,left,moveactive,-10 0"
        "$mainMod CTRL ALT,up,moveactive,0 -10"
        "$mainMod CTRL ALT,down,moveactive,0 10"
      ];

      xwayland = {
        use_nearest_neighbor = false;
      };

      exec-once = [
        "waybar"
        "waypaper --restore --backend swww"
        "hypridle"
      ];

      bind = [
        "$mainMod,RETURN,exec,kitty"
        "$mainMod,C,killactive,"
        "$mainMod,M,exit,"
        "$mainMod,E,exec,dolphin"
        "$mainMod,V,togglefloating,"
        "$mainMod,space,exec,wofi --show drun -o DP-3"
        "$mainMod,P,pseudo,"

        "$mainMod,left,movefocus,l"
        "$mainMod,right,movefocus,r"
        "$mainMod,up,movefocus,u"
        "$mainMod,down,movefocus,d"
        "$mainMod,j,cyclenext,prev"
        "$mainMod,k,cyclenext,next"

        "$mainMod SHIFT,left,movewindow,l"
        "$mainMod SHIFT,right,movewindow,r"
        "$mainMod SHIFT,up,movewindow,u"
        "$mainMod SHIFT,down,movewindow,d"

        "$mainMod,1,exec,hyprsome workspace 1"
        "$mainMod,2,exec,hyprsome workspace 2"
        "$mainMod,3,exec,hyprsome workspace 3"
        "$mainMod,4,exec,hyprsome workspace 4"
        "$mainMod,5,exec,hyprsome workspace 5"
        "$mainMod,6,exec,hyprsome workspace 6"
        "$mainMod,7,exec,hyprsome workspace 7"
        "$mainMod,8,exec,hyprsome workspace 8"
        "$mainMod,9,exec,hyprsome workspace 9"

        "$mainMod SHIFT,1,exec,hyprsome move 1"
        "$mainMod SHIFT,2,exec,hyprsome move 2"
        "$mainMod SHIFT,3,exec,hyprsome move 3"
        "$mainMod SHIFT,4,exec,hyprsome move 4"
        "$mainMod SHIFT,5,exec,hyprsome move 5"
        "$mainMod SHIFT,6,exec,hyprsome move 6"
        "$mainMod SHIFT,7,exec,hyprsome move 7"
        "$mainMod SHIFT,8,exec,hyprsome move 8"
        "$mainMod SHIFT,9,exec,hyprsome move 9"

        "$mainMod,mouse_down,workspace,e+1"
        "$mainMod,mouse_up,workspace,e-1"
      ];
    };
  };

  programs.wofi = {
    enable = true;
  };

  programs.waybar = {
    enable = true;
    settings = [{
      position = "bottom";
      height = 52;
      modules-left = [ "hyprland/workspaces" ];
      modules-right = [ "cpu" "temperature" "memory" "pulseaudio" "clock" ];
      pulseaudio = {
        format = " <span color=\"#89b482\">:vol</span> <span color=\"#a9b665\">\"{volume}%\"</span>";
        format-muted = "󰖁 ";
        format-icons = {
          default = [" " " " " "];
        };
        on-click = "pavucontrol";
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
        format = " <span color=\"#89b482\">:now</span> [<span color=\"#d3869b\">{:%H %M}</span>]}}";
      };
    }];
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
} 
