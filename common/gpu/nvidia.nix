{ lib, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia.modesetting.enable = true;
}
