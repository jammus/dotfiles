{ pkgs, inputs, config, ... }:
let
  publicKeys = import ../common/public-keys.nix;
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
    "openrouter.ai"
    "pi.dev"
    "api.deepseek.com"
  ];
  allowedIps = [
    "192.168.88.0/24"
    "192.168.100.0/24"
  ];
  systemPackages = [
    pkgs.claude-code
    pkgs.bind
    pkgs.git
    pkgs.direnv
    pkgs.devenv
    pkgs.vim
    inputs.backlog-md.packages.x86_64-linux.default
  ];
  imports = [
    ../home/default.nix
    ../home/emacs.nix
    ../home/llms.nix
  ];
  interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';
  hosts = {
    "192.168.100.10" = ["taskmaster"];
  };
in
{
  imports = [
    ../modules/dev-container.nix
  ];
  
  devContainers.agent-host = {
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    enableFirewallFiltering = true;
    allowedDomains = allowedDomains;
    allowedIps = allowedIps;
    config = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager.useUserPackages = true;
      home-manager.users.agent = {
        imports = imports;
      };
      environment.systemPackages = systemPackages;
      services = {
        openssh.enable = true;
      };
      programs = {
        fish.enable = true;
        bash = {
          interactiveShellInit = interactiveShellInit;
        };
      };
      networking.hosts = hosts;
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
  devContainers.research = {
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.13";
    enableFirewallFiltering = false;
    config = {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager.useUserPackages = true;
      home-manager.users.agent = {
        imports = imports;
      };
      environment.systemPackages = systemPackages;
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
      networking.hosts = hosts;
			networking.resolvconf.enable = false;
			environment.etc."resolv.conf".text = "nameserver 1.1.1.1";
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
