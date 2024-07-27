{ config, osConfig, ... }:
let bg0 = "#1d2021";
    fg0 = "#d4be98";
    fg1 = "#ddc7a1";

    bg4 = "#3c3836";
    bg5 = "#504945";
    bgStatusLine2 = "#32302f";

    red = "#ea6962";
    aqua = "#89b482";
    orange = "#e78a43";
    yellow = "#d8a657";
    green = "#a9b665";
    blue = "#7daea3";
    purple = "#d3869b";

    grey0 = "#7c6f64";
    grey1 = "#928374";
    grey2 = "#a89984";
    hostName = if builtins.isString osConfig.networking.hostName then osConfig.networking.hostName else "default";
in {
  config.colors = {
    accents = {
      primary = {
        "default" = orange;
        "pistachio" = green;
        "taskmaster" = orange;
        "time-eater" = aqua;
        "giant-head" = blue;
        "book-of-stabbing" = purple;
        "nemesis" = green;
        "reptomancer" = orange;
      }.${hostName};

      secondary = {
        "default" = yellow;
        "pistachio" = green;
        "taskmaster" = grey2;
        "time-eater" = purple;
        "giant-head" = grey1;
        "book-of-stabbing" = aqua;
        "nemesis" = fg0;
        "reptomancer" = orange;
      }.${hostName};
    };

    bg0 = bg0;
    fg0 = fg0;
    fg1 = fg1;

    bg4 = bg4;
    bg5 = bg5;
    bgStatusLine2 = bgStatusLine2;

    red = red;
    aqua = aqua;
    orange = orange;
    yellow = yellow;
    green = green;
    blue = blue;
    purple = purple;

    grey0 = grey0;
    grey1 = grey1;
    grey2 = grey2;
  };
}
