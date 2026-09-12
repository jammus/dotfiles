{ pkgs, inputs, ... }:
let
  llmPackages = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [
    llmPackages.openclaw
    llmPackages.hermes-agent
  ];
}
