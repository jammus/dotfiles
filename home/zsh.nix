{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    initExtra = if pkgs.stdenv.hostPlatform.isDarwin then ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '' else "";
    enableCompletion = true;
    shellAliases = {
      ls = "lsd";
      cat = "bat";
      bl = "nb notes:backlog/";
      bm = "nb notes:bookmarks/";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "history-substring-search" ];
    };
  };
}
