{ pkgs, inputs, ... }:
let
  llmPackages = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  nixpkgs.overlays = [
    (final: prev: {
      pi = llmPackages.pi;
      claude-agent-acp = llmPackages.claude-agent-acp;
      pi-acp = final.callPackage ../packages/pi-acp/package.nix {
        pi = final.pi;
      };
    })
  ];

  home.packages = [
    pkgs.pi
    pkgs.pi-acp
  ];
}
