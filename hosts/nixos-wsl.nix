{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"

    nixos-wsl.nixosModules.wsl
  ];

  networking.hostName = "nixos-wsl";

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;
    wslConf.network.hostname = "nixos-wsl";

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jammus = {
    isNormalUser = true;
    description = "James Scott";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  services.tailscale.enable = true;

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [ git vim ];
}
