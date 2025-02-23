{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    historySubstringSearch = { 
      enable = true;
    };
    syntaxHighlighting = {
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
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };
}
