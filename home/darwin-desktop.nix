{ pkgs, inputs, ... }:
{
  imports = [
    ./kitty.nix
    ./emacs.nix
    ./ghostty.nix
    ./llms.nix
  ];

  home.packages = with pkgs; [
    viu
    # jetbrains.idea-ultimate
    obsidian
    grc
    # virtualbox
    claude-code
    # inputs.backlog-md.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
