let
  personal = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCMGaXGzSmTVtHge03IKCx1UHvCUPHFCqRGuOTuJloCiaJSn0VOPkgPUhaGEji5huWvM3DqIA0BuqJmP6DgfAKhM39OjnvybixyBMTsXQa2z7wEYCZy5aSjnxzHV2jpfbI+dULYo8g9CzhOeDYx7qj+pkvgbUSucygeu8I1NYOl9+oXQjHp9PaT9u5wNoRXbdBQ5r0FINw+IijdnYL1fDGknylRFORWv/qyMau9nSPhe0oLNsnQE9N04DDCAj3xiL5YbbzOTZIVrwkb1aPrijHPERE2TBsv+u6YuZkvEBk0+le9SFysfDuZkSzHxyC+wmrIIsZ2kvTnlffQ3D0CQZFOSwrZKd7d04qt5L/b9wMXfvt6vzVdlZZcfwcMUCpvBrS6GydhiXzRD5Ymv5y9E2eNSwWwYCdVMB7xOKFfDRJUbQVhuJAadeTWGOJwWxGEMMpCu4MzrKwgnZ9ehmqefqfTp5xuhSsXRVEFdM9qZMEEYihvi5HYo2dbNCUfqdfAw0="  # jammus@gianthead
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrMN78xfUybhtW0IqtFu41ZqoILsGS+39cMVDkNYx+S"  # jammus@taskmaster
  ];
  hosts = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPh+5vY1kvt2be0uIaQeN8WmHfcYiKuDogdSi04ctG1g"  # giant-head
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMF699TRTcCpCdPZ+s0ZWHQXhFHeTIM4vUhXKeK/htFr"  # taskmaster
  ];
  keys = personal ++ hosts;
in {
  "zfs.key.age".publicKeys = keys;
}
