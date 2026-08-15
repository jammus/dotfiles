let font = import ./terminal-font.nix;
in {
  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkMedium";
    font = {
      name = font.family;
      inherit (font) size;
    };
    extraConfig = ''
      draw_minimal_borders no
      hide_window_decorations titlebar-only
      enable_audio_bell yes
      close_on_child_death yes
      askpass unless-set

      tab_fade 1
      active_tab_background #d8a657
      active_tab_foreground #1d2021
      active_tab_font_style normal
      inactive_tab_foreground #d4be98
      inactive_tab_background #504945

      disable_ligatures always

      shell /etc/profiles/per-user/jammus/bin/fish
    '';
  };
}
