{ config, pkgs, ...}:
{
  imports =
    [
      ./fonts.nix
    ];

  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadRightClick = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.defaults.dock.autohide = true;

  system.defaults.spaces.spans-displays = false;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.expose-animation-duration = 0.1;

  services.skhd = {
    enable = true;

    skhdConfig = ''
      # Open terminal
      shift + alt - return : kitty
    '';
  };
}
