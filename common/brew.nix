{ config, pkgs, ... }:
{
  homebrew = {
    enable = true;
    brews = [
      {
        name = "FelixKratz/homebrew-formulae/sketchybar";
        start_service = true;
        link = true;
      }
    ];
    casks = [
      "amethyst"
      "scroll-reverser"
    ];
  };
}
