{ pkgs, ... }:
{
  programs.fish = {
    enable = false;
    shellAliases = {
      ls = "lsd";
      cat = "bat";
      bl = "nb notes:backlog/";
      bm = "nb notes:bookmarks/";
    };
    interactiveShellInit = ''
      fish_vi_key_bindings
    '';
  };
}
