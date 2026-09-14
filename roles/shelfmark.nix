{ config, lib, pkgs, ... }:

{
  services.shelfmark = {
    enable = true;
    environment = {
      CONFIG_DIR = "/nas/services/shelfmark";
    };
  };
}
