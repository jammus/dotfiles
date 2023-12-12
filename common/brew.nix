{ config, pkgs, ... }:
{
  homebrew = {
    enable = true;
    taps = [
      "d12frosted/emacs-plus"
    ];
    casks = [
      "amethyst"
      "scroll-reverser"
    ];
  };
}
