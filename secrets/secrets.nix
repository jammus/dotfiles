let
  personal = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCMGaXGzSmTVtHge03IKCx1UHvCUPHFCqRGuOTuJloCiaJSn0VOPkgPUhaGEji5huWvM3DqIA0BuqJmP6DgfAKhM39OjnvybixyBMTsXQa2z7wEYCZy5aSjnxzHV2jpfbI+dULYo8g9CzhOeDYx7qj+pkvgbUSucygeu8I1NYOl9+oXQjHp9PaT9u5wNoRXbdBQ5r0FINw+IijdnYL1fDGknylRFORWv/qyMau9nSPhe0oLNsnQE9N04DDCAj3xiL5YbbzOTZIVrwkb1aPrijHPERE2TBsv+u6YuZkvEBk0+le9SFysfDuZkSzHxyC+wmrIIsZ2kvTnlffQ3D0CQZFOSwrZKd7d04qt5L/b9wMXfvt6vzVdlZZcfwcMUCpvBrS6GydhiXzRD5Ymv5y9E2eNSwWwYCdVMB7xOKFfDRJUbQVhuJAadeTWGOJwWxGEMMpCu4MzrKwgnZ9ehmqefqfTp5xuhSsXRVEFdM9qZMEEYihvi5HYo2dbNCUfqdfAw0="  # jammus@gianthead
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrMN78xfUybhtW0IqtFu41ZqoILsGS+39cMVDkNYx+S"  # jammus@taskmaster
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYIfbjBP8hyIhqwg+sBSL0mCZ4+/1uzZ5ndj/7qe13A" # jammus@giant-head (2024)
  ];
  hosts = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPh+5vY1kvt2be0uIaQeN8WmHfcYiKuDogdSi04ctG1g"  # giant-head (olde)
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMF699TRTcCpCdPZ+s0ZWHQXhFHeTIM4vUhXKeK/htFr"  # taskmaster
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK63++s3m6yAsqwmZnqH4gSQYeW0W0Mc7tQtiLtgzyV+" # giant-head (2024)
  ];
  keys = personal ++ hosts;
in {
  "zfs.key.age".publicKeys = keys;
  "zfs-junk.key.age".publicKeys = keys;
  "backup_ed25519.age".publicKeys = keys;
}
