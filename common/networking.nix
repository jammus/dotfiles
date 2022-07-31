{ config, pkgs, ... }:
{
  # Enable networking
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
