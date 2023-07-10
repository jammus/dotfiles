
{ config, pkgs, ... }:

{
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jammus = {
    isNormalUser = true;
    description = "James Scott";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };
}
