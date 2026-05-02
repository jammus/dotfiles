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
  programs.sway.enable = false;

  services.desktopManager.cosmic.enable = false;
  services.displayManager.cosmic-greeter.enable = false;

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
    cursor = {
      name = "vanilla-dmz";
      size = 24;
      package = pkgs.vanilla-dmz;
    };
  };
}
