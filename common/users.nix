
{ config, lib, pkgs, ... }:

let
  publicKeys = import ./public-keys.nix;
in
{
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.jammus = {
    uid = 1000;
    initialHashedPassword = "\$6\$L3VMq4TrbbNUbNgI\$A3xT231qXg6FqMt.J3xZx.rb4cqj7QdsNcvBO1E2TIUzwu6968VrRPGl0bulVciH0GZnjHCTdHhp.KzOps.Sv0";
    isNormalUser = true;
    description = "James Scott";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "media"
    ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = publicKeys.authorizedKeys;
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
