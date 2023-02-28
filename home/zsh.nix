{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ls = "lsd";
      cat = "bat";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history-substring-search" ];
    };
  };
}
