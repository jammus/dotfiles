{ pkgs, inputs, ... }:
{
  imports = [
    ./emacs.nix
    ./llms.nix
  ];

  home.packages = [
    # (llama-cpp.override { cudaSupport = true; })
    pkgs.grc
    pkgs.claude-code
    inputs.backlog-md.packages.x86_64-linux.default
  ];
}
