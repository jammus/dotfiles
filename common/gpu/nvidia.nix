{ lib, pkgs, ... }:
{
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];

  hardware.opengl.enable = true;
}
