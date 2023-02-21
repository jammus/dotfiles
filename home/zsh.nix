{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ls = "exa";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history-substring-search" ];
    };
  };
}
