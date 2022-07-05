{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    ../common/users.nix

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

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [ git vim ];
}
