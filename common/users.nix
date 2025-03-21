
{ config, lib, pkgs, ... }:

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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCMGaXGzSmTVtHge03IKCx1UHvCUPHFCqRGuOTuJloCiaJSn0VOPkgPUhaGEji5huWvM3DqIA0BuqJmP6DgfAKhM39OjnvybixyBMTsXQa2z7wEYCZy5aSjnxzHV2jpfbI+dULYo8g9CzhOeDYx7qj+pkvgbUSucygeu8I1NYOl9+oXQjHp9PaT9u5wNoRXbdBQ5r0FINw+IijdnYL1fDGknylRFORWv/qyMau9nSPhe0oLNsnQE9N04DDCAj3xiL5YbbzOTZIVrwkb1aPrijHPERE2TBsv+u6YuZkvEBk0+le9SFysfDuZkSzHxyC+wmrIIsZ2kvTnlffQ3D0CQZFOSwrZKd7d04qt5L/b9wMXfvt6vzVdlZZcfwcMUCpvBrS6GydhiXzRD5Ymv5y9E2eNSwWwYCdVMB7xOKFfDRJUbQVhuJAadeTWGOJwWxGEMMpCu4MzrKwgnZ9ehmqefqfTp5xuhSsXRVEFdM9qZMEEYihvi5HYo2dbNCUfqdfAw0= jammus@gianthead"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDH8dbdz97PqWxUmQQJzW+G7np6uNkQMYFCA/KYdv42vVscZ7KhEqqlLUSFOo6TFdyV687b7MrJH0sd05EUdiZmlgcewhRqz847Eai8mw6CfJ9g6qBUiTme1Cozj2MtfpY0BFYwJrE6GgqKjl31XvksUJUcdJQwbvekVP9Q3go7OIZKkp8K0rMe6NUKir7bIcNoFxEDz5LBRSeES1mKJ9AFFjKFleIonwtiZ1iDCziec6Bd8omyAZ33fkWLbsgDIfqXNfiYLOi37OOKlSzVFudA/qJHbLKUp7cPCGhwvkGRWiSnPX2gRPL6fSDEgQNpQO3Rfxaz1/5KDOTilviExKwOGNZT4fDDi5TdbLuR323CRg4nF1QqV4y8Ij+l96XC0On4L7zr9vnTRqYwRhrniIB458SI18FB7zElhz9XYrmHFmtCYCstyRseQIxW2WKtvBSmbedL2zAoERb3UixOlGh8TEbqs5/2klTLjNcoonYnEF/yanLvjGe5omm42zqvQac= jammus@pistachio"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYIfbjBP8hyIhqwg+sBSL0mCZ4+/1uzZ5ndj/7qe13A jammus@giant-head"
    ];
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
