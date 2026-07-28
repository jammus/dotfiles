# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common/base.nix
      ../../common/users.nix
      ../../common/networking.nix
    ];

  services.avahi.enable = false;
  networking.firewall.allowedTCPPorts = [ 22 ];
  services.openssh.settings.PasswordAuthentication = false;

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = ["nodev"];
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "byrd";
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYIfbjBP8hyIhqwg+sBSL0mCZ4+/1uzZ5ndj/7qe13A'' ];
  
  system.stateVersion = "24.05"; # Did you read the comment?
}

