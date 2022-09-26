{ lib, config, ... }:
{
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };

  services.picom = {
    enable = true;

    activeOpacity = 1.0;
    inactiveOpacity = 0.98;

    settings = {
      blur = {
        method = "gaussian";
        size = 10;
        deviation = 5.0;
      };
    };

    experimentalBackends = true;

    opacityRules = [
      "90:class_g *?= 'Rofi'"
      "100:class_g *?= 'Firefox'"
    ];
  };
}
