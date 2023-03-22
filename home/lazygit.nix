{
  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never --syntax-theme=gruvbox-dark";
      };
    };
  };
}
