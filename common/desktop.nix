{ config, pkgs, ... }:

{
  imports =
    [
      ./fonts.nix
    ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.windowManager.xmonad = {
    enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  security.polkit.enable = true;
  programs.sway.enable = true;

  services.desktopManager.cosmic.enable = false;
  services.displayManager.cosmic-greeter.enable = false;
}
