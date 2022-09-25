{
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark Hard";
    font = {
      name = "monospace";
      size = 14;
    };
    extraConfig = ''
      draw_minimal_borders no
    '';
  };
}
