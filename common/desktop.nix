{ config, pkgs, ... }:

{
  imports =
    [
      ./fonts.nix
    ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
  };
  security.polkit.enable = true;
  programs.sway.enable = true;
}
