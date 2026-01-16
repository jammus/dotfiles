let
  publicKeys = import ../common/public-keys.nix;
in
{
  "forgejo-runner.token.age".publicKeys = publicKeys.userKeys ++ publicKeys.hosts;
}
