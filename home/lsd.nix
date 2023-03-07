{ lib, pkgs, ... }:
with lib;
let yamlFormat = pkgs.formats.yaml { };
    theme = {
      date = {
        hour-old = [231 138 78];
        day-old = [216 166 87];
        older = [169 153 132];
      };
    };
in
{
  programs.lsd = {
    enable = true;
    settings = {
      color = {
        theme = "custom";
      };
    };
  };
  xdg.configFile."lsd/themes/custom.yaml" = mkIf (theme != { }) {
    source = yamlFormat.generate "lsd-theme" theme;
  };
}
