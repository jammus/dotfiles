{ config, pkgs, ... }:
{
  # Enable networking
  networking.networkmanager.enable = true;

  # Disable wait online as it's causing trouble at rebuild
  # See: https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  # ssh access
  services.openssh.enable = true;

  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    checkReversePath = "loose";

    # Tailscale can always connect
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];

    # Any device can connect via ssh (seems like openssh enables anyway, but no
    # harm being double sure)
    allowedTCPPorts = [ 22 ];
  };

  networking.wireguard.enable = true;
  services.mullvad-vpn.enable = true;

  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
