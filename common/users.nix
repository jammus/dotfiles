
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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCMGaXGzSmTVtHge03IKCx1UHvCUPHFCqRGuOTuJloCiaJSn0VOPkgPUhaGEji5huWvM3DqIA0BuqJmP6DgfAKhM39OjnvybixyBMTsXQa2z7wEYCZy5aSjnxzHV2jpfbI+dULYo8g9CzhOeDYx7qj+pkvgbUSucygeu8I1NYOl9+oXQjHp9PaT9u5wNoRXbdBQ5r0FINw+IijdnYL1fDGknylRFORWv/qyMau9nSPhe0oLNsnQE9N04DDCAj3xiL5YbbzOTZIVrwkb1aPrijHPERE2TBsv+u6YuZkvEBk0+le9SFysfDuZkSzHxyC+wmrIIsZ2kvTnlffQ3D0CQZFOSwrZKd7d04qt5L/b9wMXfvt6vzVdlZZcfwcMUCpvBrS6GydhiXzRD5Ymv5y9E2eNSwWwYCdVMB7xOKFfDRJUbQVhuJAadeTWGOJwWxGEMMpCu4MzrKwgnZ9ehmqefqfTp5xuhSsXRVEFdM9qZMEEYihvi5HYo2dbNCUfqdfAw0= jammus@gianthead"
    ];
  };
}
