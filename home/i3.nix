{ lib, config, ... }:

let
  mod = "Mod4";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      fonts =  ["Fira Code"];
      terminal = "alacritty";
    };
  };
}
