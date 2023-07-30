{ ... }:
{
  users.users = {
    jellyfin = {
      group = "jellyfin";
      isNormalUser = true;
      extraGroups = [
        "render"
        "media"
      ];
    };
  };

  users.groups = {
    jellyfin = {};
    media = {};
  };

  # https://nixos.wiki/wiki/Samba
  networking.firewall.allowedTCPPorts = [
    5357 # wsdd
  ];
  networking.firewall.allowedUDPPorts = [
    3702 # wsdd
  ];

  services.samba.openFirewall = true;
}
