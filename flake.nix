{
  description = "NixOS configuration and home-manager configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.follows = "nixos-cosmic/nixpkgs";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprsome = {
      url = "github:sopa0/hyprsome";
    };
    agenix = {
      url = "github:ryantm/agenix";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    stylix = {
      url = "github:danth/stylix";
    };
    backlog-md = {
      url = "github:MrLesk/Backlog.md";
    };
    secrets = {
      url = "git+ssh://git@github.com/jammus/secrets.git";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.agenix.follows = "agenix";
    };
  };
  outputs = inputs@{
    home-manager, nixpkgs, darwin,
    hyprsome, agenix, nixos-cosmic,
    niri, stylix, secrets,
    ...}:
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
              ./home/linux-desktop.nix
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
              ./home/linux-desktop.nix
            ];
          };
        } 
      ];
    };
    nixosConfigurations.giant-head = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        agenix.nixosModules.default
        secrets.nixosModules.secrets
        stylix.nixosModules.stylix
        nixos-cosmic.nixosModules.default
        niri.nixosModules.niri
        ./hosts/giant-head/configuration.nix
        ./common/desktop.nix
        home-manager.nixosModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.users.jammus = {
            imports = [
              ./home/default.nix
              ./home/linux-desktop.nix
            ];
            home.packages = [
              hyprsome.packages.x86_64-linux.default
            ];
          };
        } 
      ];
    };
    nixosConfigurations.taskmaster = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        agenix.nixosModules.default
        secrets.nixosModules.secrets
        ./hosts/taskmaster/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.jammus = {
            imports = [
              ./home/default.nix
              ./home/linux.nix
              ./home/taskmaster.nix
            ];
          };
        }
      ];
      specialArgs = {
        inherit inputs;
      };
    };
    nixosConfigurations.pistachio = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./hosts/pistachio/configuration.nix
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
    darwinConfigurations.chuckd = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/chuckd/configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.users."james.scott" = {
            imports = [
              ./home/default.nix
              ./home/darwin-desktop.nix
            ];
          };
        }
      ];
    };
    darwinConfigurations.book-of-stabbing = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./hosts/book-of-stabbing/configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager.useUserPackages = true;
          home-manager.users.jammus = {
            imports = [
              ./home/default.nix
              ./home/darwin-desktop.nix
            ];
          };
        }
      ];
    };
    nixosConfigurations.time-eater = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/time-eater/configuration.nix
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
  };
}
