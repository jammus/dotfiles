{ pkgs, ... }:
let font = import ./terminal-font.nix;
in
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      theme = "Gruvbox Material Dark";
      window-decoration = "none";
      font-family = font.family;
      font-size = font.size;
    };
  };
}
