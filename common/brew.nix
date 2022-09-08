{ config, pkgs, ... }:
{
  homebrew = {
    enable = true;
    casks = [
      "amethyst"
    ];
  };
}
