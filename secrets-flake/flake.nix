{
  description = "Private secrets for NixOS configurations";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, agenix, ... }: {
    nixosModules.secrets = { config, ... }: {
      imports = [ agenix.nixosModules.default ];
      
      age.secrets = {
        "zfs.key" = {
          file = ./secrets/zfs.key.age;
          owner = "root";
          group = "root";
        };
        "zfs-junk.key" = {
          file = ./secrets/zfs-junk.key.age;
          owner = "root";
          group = "root";
        };
        "backup_ed25519" = {
          file = ./secrets/backup_ed25519.age;
          owner = "root";
          group = "root";
        };
        "backup.passphrase" = {
          file = ./secrets/backup.passphrase.age;
          owner = "root";
          group = "root";
        };
      };
    };
  };
}
