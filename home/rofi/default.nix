{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;
    package = with pkgs; rofi.override { plugins = [ rofi-calc rofi-emoji ]; };
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = ./gruvbox-dark-hard.rasi;
  };
}
