{ pkgs, ... }:
let
  llama-cpp = pkgs.llama-cpp.overrideAttrs(attrs: rec {
    version = "5869";
    src = pkgs.fetchFromGitHub {
      owner = "ggml-org";
      repo = "llama.cpp";
      tag = "b${version}";
      hash = "sha256-sQK5OHuzRaT5wiz6+6ZBQxpzCLhYjdWy1ZsPcLrvMe4=";
    };
  });
in
{
  home.packages = [
    # (llama-cpp.override { cudaSupport = true; })
    pkgs.emacs
    pkgs.grc
    pkgs.ollama-cuda
  ];
}
