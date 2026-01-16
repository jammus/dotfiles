  let
  userKeys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCMGaXGzSmTVtHge03IKCx1UHvCUPHFCqRGuOTuJloCiaJSn0VOPkgPUhaGEji5huWvM3DqIA0BuqJmP6DgfAKhM39OjnvybixyBMTsXQa2z7wEYCZy5aSjnxzHV2jpfbI+dULYo8g9CzhOeDYx7qj+pkvgbUSucygeu8I1NYOl9+oXQjHp9PaT9u5wNoRXbdBQ5r0FINw+IijdnYL1fDGknylRFORWv/qyMau9nSPhe0oLNsnQE9N04DDCAj3xiL5YbbzOTZIVrwkb1aPrijHPERE2TBsv+u6YuZkvEBk0+le9SFysfDuZkSzHxyC+wmrIIsZ2kvTnlffQ3D0CQZFOSwrZKd7d04qt5L/b9wMXfvt6vzVdlZZcfwcMUCpvBrS6GydhiXzRD5Ymv5y9E2eNSwWwYCdVMB7xOKFfDRJUbQVhuJAadeTWGOJwWxGEMMpCu4MzrKwgnZ9ehmqefqfTp5xuhSsXRVEFdM9qZMEEYihvi5HYo2dbNCUfqdfAw0= jammus@gianthead"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDH8dbdz97PqWxUmQQJzW+G7np6uNkQMYFCA/KYdv42vVscZ7KhEqqlLUSFOo6TFdyV687b7MrJH0sd05EUdiZmlgcewhRqz847Eai8mw6CfJ9g6qBUiTme1Cozj2MtfpY0BFYwJrE6GgqKjl31XvksUJUcdJQwbvekVP9Q3go7OIZKkp8K0rMe6NUKir7bIcNoFxEDz5LBRSeES1mKJ9AFFjKFleIonwtiZ1iDCziec6Bd8omyAZ33fkWLbsgDIfqXNfiYLOi37OOKlSzVFudA/qJHbLKUp7cPCGhwvkGRWiSnPX2gRPL6fSDEgQNpQO3Rfxaz1/5KDOTilviExKwOGNZT4fDDi5TdbLuR323CRg4nF1QqV4y8Ij+l96XC0On4L7zr9vnTRqYwRhrniIB458SI18FB7zElhz9XYrmHFmtCYCstyRseQIxW2WKtvBSmbedL2zAoERb3UixOlGh8TEbqs5/2klTLjNcoonYnEF/yanLvjGe5omm42zqvQac= jammus@pistachio"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYIfbjBP8hyIhqwg+sBSL0mCZ4+/1uzZ5ndj/7qe13A jammus@giant-head"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrMN78xfUybhtW0IqtFu41ZqoILsGS+39cMVDkNYx+S # jammus@taskmaster"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHKI/Fa2TPriXo9wFuIekjy0ZeY6/r5O52MEbVI+nKWx" # op
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJOIdnD23MLA/0op5ZNuMzC6WE3FzCAwwKGtCaOvwhme" # op
  ];
  devices = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCDfNnlBIBcuvxnEW7s+92l2D9KDEltEIHeK15cg+OsNC/IEddl9YDQsxknKSfAe9BwM6vB1cacskuxIg3xHrzQ= ShellFish@iPhone-28022024"
  ];
  hosts = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPh+5vY1kvt2be0uIaQeN8WmHfcYiKuDogdSi04ctG1g"  # giant-head (olde)
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMF699TRTcCpCdPZ+s0ZWHQXhFHeTIM4vUhXKeK/htFr"  # taskmaster
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK63++s3m6yAsqwmZnqH4gSQYeW0W0Mc7tQtiLtgzyV+" # giant-head (2024)
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGohYKS+oTfPE1YhlQqG/SqEoemO4+vv0gec/UMJC2d" #ci-runner
  ];
  in {
    authorizedKeys = userKeys ++ devices;
    hosts = hosts;
    userKeys = userKeys;
  }
