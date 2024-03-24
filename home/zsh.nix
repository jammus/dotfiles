{
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    enableCompletion = true;
    shellAliases = {
      ls = "lsd";
      cat = "bat";
      bl = "nb backlog/";
      bm = "nb bookmarks/";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history-substring-search" ];
    };
  };
}
