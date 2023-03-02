{
  programs.kitty = {
    enable = true;
    theme = "Gruvbox Material Dark Hard";
    font = {
      name = "Fira Code";
      size = 16;
    };
    extraConfig = ''
      draw_minimal_borders no
      hide_window_decorations titlebar-only
      enable_audio_bell yes
      close_on_child_death yes
      askpass unless-set
    '';
  };
}
