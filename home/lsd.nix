{ lib, pkgs, ... }:
{
  programs.lsd = {
    enable = true;
    colors = {
      date = {
        hour-old = [231 138 78];
        day-old = [216 166 87];
        older = [169 153 132];
      };
    };
  };
}
