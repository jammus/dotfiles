{ pkgs, inputs, ... }:
let
  publicKeys = import ../common/public-keys.nix;
in
{
  imports = [ ../modules/dev-container.nix ];
  
  devContainers.agent-host = {
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    enableFirewallFiltering = true;
    allowedDomains = [
      "cache.nixos.org"
      "nix-community.cachix.org"
      "devenv.cachix.org"
      "api.anthropic.com"
      "console.anthropic.com"
      "github.com"
      "api.github.com"
      "raw.githubusercontent.com"
      "nixos.org"
      "channels.nixos.org"
      "codeload.github.com"
      "files.pythonhosted.org"
      "static.crates.io"
      "huggingface.co"
      "cas-server.xethub.hf.co"
      "transfer.xethub.hf.co"
      "pypi.org"
      "registry.npmjs.org"
      "repo1.maven.org"
      "repo.clojars.org"
    ];
    allowedIps = [
      "192.168.88.0/24"
      "192.168.100.0/24"
    ];
    config = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager.useUserPackages = true;
      home-manager.users.agent = {
        imports = [
          ../home/default.nix
        ];
      };
      environment.systemPackages = [
        pkgs.claude-code
        pkgs.bind
        pkgs.git
        pkgs.direnv
        pkgs.devenv
        pkgs.vim
        inputs.backlog-md.packages.x86_64-linux.default
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
