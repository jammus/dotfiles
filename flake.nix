{
  description = "NixOS configuration and home-manager configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { home-manager, nixpkgs, ...}:
  {
    nixosConfigurations.playground = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/playground/configuration.nix
        ./common/desktop.nix
        home-manager.nixosModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.users.jammus = {
            imports = [
              ./home/default.nix
              ./home/gui.nix
            ];
          };
        } 
      ];
    };
    nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/nixos-wsl/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.users.jammus = {
            imports = [
              ./home/default.nix
            ];
          };
        } 
      ];
    };
    nixosConfigurations.moosebird = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/moosebird/configuration.nix
        ./common/desktop.nix
        home-manager.nixosModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.users.jammus = {
            imports = [
              ./home/default.nix
              ./home/gui.nix
            ];
          };
        } 
      ];
    };
  };
}
