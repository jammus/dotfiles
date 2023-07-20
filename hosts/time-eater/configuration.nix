{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../common/base.nix
    ../../common/users.nix
    ../../common/networking.nix
    ../../roles/mastodon.nix
  ];

  boot.tmp.cleanOnBoot  = true;
  zramSwap.enable = true;
  networking.hostName = "time-eater";
  networking.domain = "";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCMGaXGzSmTVtHge03IKCx1UHvCUPHFCqRGuOTuJloCiaJSn0VOPkgPUhaGEji5huWvM3DqIA0BuqJmP6DgfAKhM39OjnvybixyBMTsXQa2z7wEYCZy5aSjnxzHV2jpfbI+dULYo8g9CzhOeDYx7qj+pkvgbUSucygeu8I1NYOl9+oXQjHp9PaT9u5wNoRXbdBQ5r0FINw+IijdnYL1fDGknylRFORWv/qyMau9nSPhe0oLNsnQE9N04DDCAj3xiL5YbbzOTZIVrwkb1aPrijHPERE2TBsv+u6YuZkvEBk0+le9SFysfDuZkSzHxyC+wmrIIsZ2kvTnlffQ3D0CQZFOSwrZKd7d04qt5L/b9wMXfvt6vzVdlZZcfwcMUCpvBrS6GydhiXzRD5Ymv5y9E2eNSwWwYCdVMB7xOKFfDRJUbQVhuJAadeTWGOJwWxGEMMpCu4MzrKwgnZ9ehmqefqfTp5xuhSsXRVEFdM9qZMEEYihvi5HYo2dbNCUfqdfAw0=" 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHKI/Fa2TPriXo9wFuIekjy0ZeY6/r5O52MEbVI+nKWx" 
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTkjPO4wxJq43HFVEKbcdwHDxFgcYOFnXyBnuT1eUNRlBvntlGWtMFfvuxkmgqs77Jkd8W4S9nr6fGwbUiOKB8OP1oq57Itl46NctlPAQAkE4G2eC+wKsRZYCglaoDX7dDpvRYDOVVO2OpC1oem/qtLpusnofUPyXjONTUd301BLLlq6NXP/7aTSOZAFwqJgzUFLNQs4LjbtV+VnPNwmS6EXgpxEZQtLOXV73aUx4kW5NmEEWPWH4Koj90TpNNzo9OVEOxLlQGHwxN3WaUCS6vLjR5mvgH+kM5cWkh0/I6/sAej/9wmpXdPz4iBKULjjeC7OQxozTmzBHrRTvLYzYv"
  ];

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  services.openssh.settings.PasswordAuthentication = false;

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  environment.systemPackages = with pkgs; [
    vim
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
