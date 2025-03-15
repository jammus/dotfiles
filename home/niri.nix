{ pkgs, ... }:
{
  programs.niri.settings = {
    animations = {
      workspace-switch = null;
      window-movement = null;
    };

    binds = {
      "Mod+Return".action.spawn = "kitty";
      "Mod+Space".action.spawn = ["wofi" "--show" "drun" "-o" "DP-3"];

      "Mod+Shift+C".action.close-window = {};

      "Mod+Left".action.focus-column-or-monitor-left = {};
      "Mod+H".action.focus-column-or-monitor-left = {};
      "Mod+Right".action.focus-column-or-monitor-right = {};
      "Mod+L".action.focus-column-or-monitor-right = {};

      "Mod+Shift+Left".action.move-column-left-or-to-monitor-left = {};
      "Mod+Shift+H".action.move-column-left-or-to-monitor-left = {};
      "Mod+Shift+Right".action.move-column-right-or-to-monitor-right = {};
      "Mod+Shift+L".action.move-column-right-or-to-monitor-right = {};

      "Mod+Down".action.focus-window-or-workspace-down = {};
      "Mod+J".action.focus-window-or-workspace-down = {};
      "Mod+Up".action.focus-window-or-workspace-up = {};
      "Mod+K".action.focus-window-or-workspace-up = {};

      "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = {};
      "Mod+Shift+J".action.move-window-down-or-to-workspace-down = {};
      "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = {};
      "Mod+Shift+K".action.move-window-up-or-to-workspace-up = {};

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;
      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;

      "Mod+Comma".action.consume-window-into-column = {};
      "Mod+Period".action.expel-window-from-column = {};
      "Mod+BracketLeft".action.consume-or-expel-window-left = {};
      "Mod+BracketRight".action.consume-or-expel-window-right = {};

      "Mod+R".action.switch-preset-column-width = {};
      "Mod+F".action.maximize-column = {};

      "Mod+Alt+1".action.maximize-column = {};
      "Mod+Alt+2".action.set-column-width = "50%";
      "Mod+Alt+3".action.set-column-width = "33.333333%";
      "Mod+Alt+4".action.set-column-width = "25%";
      "Mod+Alt+5".action.set-column-width = "20%";
    };

    layout = {
      border = {
        width = 2;
        active = "#7daea3";
      };
      default-column-width = {
        proportion = 0.5;
      };
      preset-column-widths = [
        { proportion = 1. / 2; }
        { proportion = 1. / 3.; }
        { proportion = 1. / 4.; }
        { proportion = 2. / 3.; }
      ];
    };

    outputs.DP-1 = {
      variable-refresh-rate = true;
    };

    outputs.DP-2 = {
      transform = {
        rotation = 270;
      };
    };

    spawn-at-startup = [
      { command = ["waybar"]; }
      { command = ["xwayland-satellite"]; }
    ];
  };
}
