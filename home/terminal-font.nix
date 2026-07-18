# Single source of truth for the terminal / editor font. Referenced by
# home/kitty.nix, home/ghostty.nix, and home/emacs.nix (the vanilla init.el and
# the Doom config, via generated elisp). Change it here to switch fonts
# everywhere at once.
#
# `family' must be an installed family name (see `fc-list'); the Nerd Font
# packages are in common/fonts.nix. Swap to the "… Nerd Font Mono" variant if
# you want every glyph forced to a single cell width.
{
  family = "FiraCode Nerd Font";
  size = 15;
}
