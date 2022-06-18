{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font = {
        normal.family = "Fira Code";
        size = 13;
      };
    };
  };
}
