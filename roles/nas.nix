{ pkgs, ... }:
{
  # https://nixos.wiki/wiki/Samba
  services.samba = {
    enable = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "taskmaster";
        "netbios name" = "taskmaster";
        "security" = "user";
        "use sendfile" = "yes";
        "hosts allow" = "192.168.88. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "media" = {
        path = "/nas/media";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "media";
        "force group" = "media";
      };
    };
  };

  services.samba.openFirewall = true;
  networking.firewall.allowedTCPPorts = [
    5357 # wsdd
  ];
  networking.firewall.allowedUDPPorts = [
    3702 # wsdd
  ];

  users.users = {
    media = {
      group = "media";
      isNormalUser = true;
      extraGroups = [
        "media"
      ];
    };
  };

  users.groups = {
    media = {
      gid = 989;
    };
  };

  services.sanoid = {
    enable = true;
    templates.backup = {
      hourly = 36;
      daily = 30;
      monthly = 3;
      autoprune = true;
      autosnap = true;
    };

    datasets."taskpool/services" = {
      useTemplate = [ "backup" ];
    };

    datasets."taskpool/photos" = {
      useTemplate = [ "backup" ];
    };
  };
}
