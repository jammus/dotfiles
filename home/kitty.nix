{
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark Hard";
    font = {
      name = "Fira Code";
      size = 14;
    };
    extraConfig = ''
      draw_minimal_borders no
      hide_window_decorations titlebar-only
    '';
  };
}
