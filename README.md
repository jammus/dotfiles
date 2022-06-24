# Installation

Set /etc/nixos/configuration to
```
{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  imports =
    [
      /home/jammus/.dotfiles/configuration.nix
    ];
}
```
