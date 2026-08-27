{ pkgs, ... }:
let
  # niri's Mod is Super. On macOS cmd alone is unusable as a Mod (cmd-1..9 are
  # tabs, cmd-h/l/f/r/q are all claimed), so Mod maps to cmd-alt and niri's
  # Mod+Alt tier maps to cmd-ctrl-alt.
  kitty = "${pkgs.kitty}/Applications/kitty.app";

  # focus-column-or-monitor-*: cross to the adjacent monitor at the edge
  focus = dir: "focus --boundaries all-monitors-outer-frame --boundaries-action stop ${dir}";
  move = dir: "move --boundaries all-monitors-outer-frame ${dir}";

  # Mod+N / Mod+Shift+N for workspaces 1..9
  workspaces = builtins.foldl' (acc: n: acc // {
    "cmd-alt-${n}" = "workspace ${n}";
    "cmd-alt-shift-${n}" = "move-node-to-workspace ${n}";
  }) { } (map toString (builtins.genList (i: i + 1) 9));
in
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      # cmd-alt-h is macOS "Hide Others"; if it ever leaks past AeroSpace
      # every other app vanishes. This makes that recoverable.
      automatically-unhide-macos-hidden-apps = true;

      # niri: layout.gaps = 8
      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 8;
        outer.right = 8;
        outer.top = 8;
        outer.bottom = 8;
      };

      # niri is columns-first; force horizontal so new windows split side by side
      default-root-container-layout = "tiles";
      default-root-container-orientation = "horizontal";

      mode.main.binding = workspaces // {
        "cmd-alt-enter" = "exec-and-forget open -na '${kitty}'";
        "cmd-alt-shift-c" = "close";

        # Mod+H/L/Left/Right — focus-column-or-monitor-{left,right}
        "cmd-alt-h" = focus "left";
        "cmd-alt-left" = focus "left";
        "cmd-alt-l" = focus "right";
        "cmd-alt-right" = focus "right";

        # Mod+J/K/Down/Up — focus-window-or-workspace-{down,up}
        "cmd-alt-j" = focus "down";
        "cmd-alt-down" = focus "down";
        "cmd-alt-k" = focus "up";
        "cmd-alt-up" = focus "up";

        # Mod+Shift+H/L — move-column-{left,right}-or-to-monitor-*
        "cmd-alt-shift-h" = move "left";
        "cmd-alt-shift-left" = move "left";
        "cmd-alt-shift-l" = move "right";
        "cmd-alt-shift-right" = move "right";

        # Mod+Shift+J/K — move-column-to-workspace-{down,up}
        "cmd-alt-shift-j" = move "down";
        "cmd-alt-shift-down" = move "down";
        "cmd-alt-shift-k" = move "up";
        "cmd-alt-shift-up" = move "up";

        # Mod+Comma/Period — consume/expel window into column
        "cmd-alt-comma" = "join-with down";
        "cmd-alt-period" = "flatten-workspace-tree";
        "cmd-alt-leftSquareBracket" = "join-with left";
        "cmd-alt-rightSquareBracket" = "join-with right";

        # Mod+R — nearest thing to switch-preset-column-width
        "cmd-alt-r" = "balance-sizes";
        "cmd-alt-minus" = "resize smart -50";
        "cmd-alt-equal" = "resize smart +50";

        # Mod+F / Mod+Shift+F / Mod+Alt+Shift+F
        "cmd-alt-f" = "fullscreen";
        "cmd-alt-shift-f" = "macos-native-fullscreen";
        "cmd-ctrl-alt-shift-f" = "fullscreen --no-outer-gaps";

        # Mod+Shift+Escape — power off monitors
        "cmd-alt-shift-esc" = "exec-and-forget pmset displaysleepnow";
      };
    };
  };

  # niri: layout.border { enable = true; width = 2; }
  services.jankyborders = {
    enable = true;
    settings = {
      style = "round";
      width = 2.0;
      hidpi = "on";
      active_color = "0xffe78a43";
      inactive_color = "0xff3c3836";
    };
  };
}
