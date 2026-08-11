{
  programs.lazygit = {
    enable = true;
    settings = {
      git.diffRenderers = [{
        colorArg = "always";
        command = "delta --dark --paging=never --syntax-theme=gruvbox-dark";
      }];
    };
  };
}
