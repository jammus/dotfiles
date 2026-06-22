{ config, pkgs, ... }:
{
  homebrew = {
    enable = true;
    casks = [
      "amethyst"
      "scroll-reverser"
    ];
  };
}
