{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    ../../common/base.nix
    ../../common/users.nix
    "${modulesPath}/profiles/minimal.nix"

    nixos-wsl.nixosModules.wsl
  ];

  networking.hostName = "nixos-wsl";

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "jammus";
    startMenuLaunchers = true;
    wslConf.network.hostname = "nixos-wsl";

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  environment.systemPackages = with pkgs; [ git vim ];

  system.stateVersion = "22.05";
}
