{ config, pkgs, ... }:
{
  homebrew = {
    enable = true;
    taps = [
      "d12frosted/emacs-plus"
    ];
    brews = [
      {
        name = "emacs-plus";
        args = ["with-spacemacs-icon" "with-native-comp"];
      }
    ];
    casks = [
      "amethyst"
      "scroll-reverser"
    ];
  };
}
