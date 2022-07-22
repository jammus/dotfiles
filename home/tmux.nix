{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    prefix = "C-a";

    keyMode = "vi";
    customPaneNavigationAndResize = true;

    extraConfig = ''
      set-window-option -g window-status-current-style bg=red
    '';
  };
}

