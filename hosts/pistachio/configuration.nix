# Initial version taken from: https://blog.hendrikmaus.dev/setup-nixos-on-a-raspberry-pi/

{ config, pkgs, lib, ... }:
{
  imports =
    [
      ../../common/base.nix
      ../../common/users.nix
      ../../common/networking.nix
      ./taskserver.nix
      ../../roles/pihole.nix
    ];

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
  };

  services.pihole = {
    enable = true;
    serverIp = "100.104.40.62";
    persistanceRoot = "/persistance/services/pihole";
  };

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;

  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # Installs Linux 5.15 kernel (July 2022). Pin until we know better
  boot.kernelPackages = pkgs.linuxPackages_5_15;

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # Adding a swap file is optional, but strongly recommended
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  # set a hostname
  networking.hostName = "pistachio";

  # users.users.root.openssh.authorizedKeys.keys = [
    # "your public key here"
  # ];

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_SG.utf8";

  # packages can be searched at https://search.nixos.org/packages
  environment.systemPackages = [
    pkgs.vim
    pkgs.libraspberrypi
  ];

  system.stateVersion = "22.05";
}
