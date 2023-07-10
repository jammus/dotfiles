{ pkgs, lib, config, ... }:
{
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };

  services.polybar = {
    enable = true;
    script = ''
      polybar main &
    '';
    package = pkgs.polybar.override {
      pulseSupport = true;
    };
    settings = {
      "bar/main" = {
        monitor = "\${env:MONITOR:DP-0}";
        width = "100%";
        height = 36;
        radius = 0.0;
        fixed.center = true;
        modules.left = "ewmh";
        modules.right = "volume date";
        background = "#282828";
        foreground = "#d4be98";
        padding = 0;
        font = ["FiraCode Nerd Font Mono:style=Regular"];
      };
      "module/date" = {
        type = "internal/date";
        format = "<label>";
        date = "%Y-%m-%d%";
        time = "%H:%M";
        label = "%date% %time%";
        label-padding = 2;
        label-font = 0;
      };
      "module/ewmh" = {
        type = "internal/xworkspaces";
        label.active.text = "%name%";
        label.active.foreground = "#1d2021";
        label.active.background = "#d8a657";
        label.active.padding = 2;
        label.occupied.text = "%name%";
        label.occupied.foreground = "#d4be98";
        label.occupied.background = "#504945";
        label.occupied.padding = 2;
        label.empty.text = "%name%";
        label.empty.foreground = "#3c3836";
        label.empty.padding = 2;
      };
      "module/volume" = {
        type = "internal/pulseaudio";
        format.volume = "<ramp-volume> <label-volume>";
        label.muted.text = "󰖁";
        label.muted.foreground = "#666";
        ramp.volume = ["󰕿" "󰖀" "󰕾"];
        click.right = "pavucontrol &";
      };
    };
  };

  programs.xmobar = {
    enable = false;
    extraConfig = ''
      Config { overrideRedirect = False
       , font     = "xft:iosevka-9"
       , bgColor  = "#928374"
       , fgColor  = "#1d2021"
       , position = TopH 25
       , commands = [ Run Weather "WSSS"
                        [ "--template", "<weather> <tempC>°C"
                        , "-L", "0"
                        , "-H", "25"
                        , "--low"   , "lightblue"
                        , "--normal", "#f8f8f2"
                        , "--high"  , "red"
                        ] 36000
                    , Run Cpu
                        [ "-L", "3"
                        , "-H", "50"
                        , "--high"  , "red"
                        , "--normal", "green"
                        ] 10
                    , Run Alsa "default" "Master"
                        [ "--template", "<volumestatus>"
                        , "--suffix"  , "True"
                        , "--"
                        , "--on", ""
                        ]
                    , Run Memory ["--template", "Mem: <usedratio>%"] 10
                    , Run Swap [] 10
                    , Run Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10
                    , Run XMonadLog
                    ]
       , sepChar  = "%"
       , alignSep = "}{"
       , template = "%XMonadLog% }{ %alsa:default:Master% | %cpu% | %memory% * %swap% | %WSSS% | %date% "
       }
    '';
  };

  services.dunst = {
    enable = true;
  };

  services.picom = {
    enable = true;

    activeOpacity = 1.0;
    inactiveOpacity = 0.95;

    vSync = true;
    backend = "glx";

    settings = {
      blur = {
        method = "gaussian";
        size = 10;
        deviation = 5.0;
      };
    };

    opacityRules = [
      "90:class_g *?= 'Rofi'"
      "100:class_g *?= 'Firefox'"
    ];
  };
}
