{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "lsd";
      cat = "bat";
      bl = "nb notes:backlog/";
      bm = "nb notes:bookmarks/";
    };
    interactiveShellInit = ''
      set fish_greeting
      fish_vi_key_bindings
      bind ctrl-r _fzf_search_history
      bind -M insert ctrl-r _fzf_search_history
      bind ctrl-t _fzf_search_directory
      bind -M insert ctrl-t _fzf_search_directory
    '';
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];
  };
}
