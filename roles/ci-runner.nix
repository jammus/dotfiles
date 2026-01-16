{ pkgs, inputs, ... }:
let
  publicKeys = import ../common/public-keys.nix;
in
{
  imports = [ ../modules/dev-container.nix ];
  
  devContainers.ci-runner = {
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.12";
    enableFirewallFiltering = false;
    autoStart = true;
    config = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
      ];
      age = {
        secrets = {
          forgejo-runner-token = {
            file = ../secrets/forgejo-runner.token.age;
            owner = "root";
            group = "root";
          };
        };
      };
      environment.systemPackages = with pkgs; [
        git
        devenv
        nodejs
      ];
      services = {
        openssh.enable = true;
      };
      networking.hosts = {
        "192.168.100.10" = ["taskmaster"];
      };
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 22 ];
      };
      users.users.runner = {
        uid = 1048;
        initialHashedPassword = "*";
        isNormalUser = true;
        description = "Runner";
        extraGroups = [
          "runner"
        ];
        openssh.authorizedKeys.keys = publicKeys.authorizedKeys;
      };
      services.gitea-actions-runner = {
        package = pkgs.forgejo-runner;
        instances.default = {
          enable = true;
          name = "nix-runner";
          url = "http://taskmaster:3000";
          tokenFile = "/run/agenix/forgejo-runner-token";
          labels = [
            "nixos:host"
          ];
          settings = {
            runner = {
              envs = {
                PATH = "/run/current-system/sw/bin:/usr/bin:/bin";
              };
            };
          };
        };
      };
    };
  };
}
