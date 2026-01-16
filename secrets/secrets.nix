{ config, lib, pkgs, ... }:
let
  publicKeys = import ./public-keys.nix;
in
{
  "forgejo-runner.token.age".publicKeys = publicKeys.userKeys ++ publicKeys.hosts;
}
