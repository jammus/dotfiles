{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };
  programs.direnv.nix-direnv.enable = true;
}
