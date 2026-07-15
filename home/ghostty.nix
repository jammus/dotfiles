{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      theme = "Gruvbox Material Dark";
      window-decoration = "none";
      font-size = 15;
    };
  };
}
