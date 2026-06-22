{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.symbols-only  # "Symbols Nerd Font Mono" — nerd-icons / doom-modeline glyphs
      unifont
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
    ];
  };
}
