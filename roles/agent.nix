{ pkgs, ... }:
let
  gitea-mcp-server = pkgs.gitea-mcp-server.overrideAttrs(attrs: rec {
    version = "0.3.0";
    src = pkgs.fetchFromGitea {
      domain = "gitea.com";
      owner = "gitea";
      repo = "gitea-mcp";
      tag = "v${version}";
      hash = "sha256-ZUnpE25XIYzSwdEilzXnhqGR676iBQcR2yiT3jhJApc=";
    };
  });
  publicKeys = import ../common/public-keys.nix;
in
{
  imports = [ ../modules/agent-container.nix ];
  
  devContainers.agent-host = {
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    enableFirewallFiltering = true;
    allowedDomains = [
      "api.anthropic.com"
      "console.anthropic.com"
      "github.com"
      "api.github.com"
      "nixos.org"
      "channels.nixos.org"
      "codeload.github.com"
      "files.pythonhosted.org"
    ];
    allowedIps = [
      "192.168.88.0/24"
      "192.168.100.0/24"
    ];
    config = {
      environment.systemPackages = [
        gitea-mcp-server
        pkgs.claude-code
        pkgs.bind
        pkgs.git
        pkgs.direnv
        pkgs.devenv
        pkgs.vi
      ];
      services = {
        openssh.enable = true;
      };
      programs = {
        fish.enable = true;
        bash = {
          interactiveShellInit = ''
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
            then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
          '';
        };
      };
      networking.hosts = {
        "192.168.100.10" = ["taskmaster"];
      };
      users.users.agent = {
        uid = 1047;
        initialHashedPassword = "*";
        isNormalUser = true;
        description = "Agent";
        extraGroups = [
          "agents"
        ];
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = publicKeys.authorizedKeys;
      };
    };
  };
}
