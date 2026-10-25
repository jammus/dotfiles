{ pkgs, lib, config, inputs, ... }:
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
        "192.168.100.10" = [ "taskmaster" "forge.int.r12.sh" ];
      };
      networking.nameservers = [ "192.168.100.10" ];
      networking.useHostResolvConf = lib.mkForce false;
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
      services.forgejo-runner = {
        package = pkgs.forgejo-runner;
        instances.default = {
          enable = true;
          secrets.server.connections.default = {
            token_url = "/run/agenix/forgejo-runner-token";
          };
          settings = {
            server.connections.default = {
              url = "https://forge.int.r12.sh";
              uuid = "e5db7236-bc68-49c3-891d-d9d12e23ea9c";
            };
            runner = {
              labels = [
                "nixos:host"
              ];
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
