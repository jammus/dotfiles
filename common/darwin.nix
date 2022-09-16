{ config, pkgs, ...}:
{
  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.TrackpadRightClick = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
}
