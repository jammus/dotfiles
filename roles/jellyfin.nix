{ pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
    ];
  };

  services.jellyfin.enable = true;

  users.users = {
    jellyfin = {
      extraGroups = [
        "render"
        "media"
      ];
    };
  };
}
