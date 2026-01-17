{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.devContainers;
  
  devContainerOptions = {
    options = {
      hostAddress = mkOption {
        type = types.str;
        default = "192.168.100.10";
        description = "Host address for the container";
      };
      
      localAddress = mkOption {
        type = types.str;
        default = "192.168.100.11";
        description = "Local address for the container";
      };
      
      allowedDomains = mkOption {
        type = types.listOf types.str;
        default = [
          "nixos.org"
        ];
        description = "List of domains to allow through firewall (resolved to IPs at boot time)";
      };
      
      autoStart = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to auto-start the container";
      };
      
      config = mkOption {
        type = types.attrs;
        default = {};
        description = "Additional configuration to merge into the container";
      };
      
      enableFirewallFiltering = mkOption {
        type = types.bool;
        default = false;
        description = "Enable firewall-based IP filtering for allowed domains";
      };
      
      allowedIps = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Additional IP addresses to allow (backup if DNS fails)";
      };
    };
  };
  
  mkDevContainer = name: containerCfg:
  {
    autoStart = containerCfg.autoStart;
    privateNetwork = true;
    hostAddress = containerCfg.hostAddress;
    localAddress = containerCfg.localAddress;
    privateUsers = "pick";
    config = { config, pkgs, lib, ... }:
    lib.recursiveUpdate {
      imports = [ ../common/base.nix ];
      users = {
        mutableUsers = false;
        allowNoPasswordLogin = true;
      };
      networking.firewall = mkIf containerCfg.enableFirewallFiltering {
        enable = true;
        allowedTCPPorts = [ 22 ];
        checkReversePath = "loose";

        extraCommands = ''
          # Allow static IPs (supports both individual IPs and CIDR ranges)
          ${lib.concatMapStringsSep "\n" (ip: 
            "iptables -A OUTPUT -d ${ip} -j ACCEPT"
          ) containerCfg.allowedIps}
          iptables -A OUTPUT -j REJECT
        '';
      };
      
      systemd.timers.resolve-domains = mkIf containerCfg.enableFirewallFiltering {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "30s";  # Run 30 seconds after boot
          Unit = "resolve-domains.service";
        };
      };

      systemd.services.resolve-domains = mkIf containerCfg.enableFirewallFiltering {
        serviceConfig = {
          Type = "oneshot";
        };
        script = ''
          echo "Starting domain resolution..."
          echo "Nameservers: $(cat /etc/resolv.conf)"
          
          # Test DNS resolution first
          echo "Testing DNS resolution..."
          ${pkgs.dnsutils}/bin/dig +short +time=5 +tries=2 google.com || echo "DNS test failed"
          
          # Resolve domains and add iptables rules
          ${lib.concatMapStringsSep "\n" (domain: ''
            echo "Resolving ${domain}..."
            for ip in $(${pkgs.dnsutils}/bin/dig +short +time=5 +tries=2 ${domain}); do
              echo "Result: $ip"
              if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                echo "Adding IP: $ip for ${domain}"
                ${pkgs.iptables}/bin/iptables -I OUTPUT -d $ip -j ACCEPT || echo "Failed to add rule for $ip"
              fi
            done
          '') containerCfg.allowedDomains}
          
          echo "Domain resolution completed"
          echo "Final iptables OUTPUT rules:"
          ${pkgs.iptables}/bin/iptables -L OUTPUT -n
        '';
      };
      system.stateVersion = "25.11";
    } containerCfg.config;
  };
in

{
  options = {
    devContainers = mkOption {
      type = types.attrsOf (types.submodule devContainerOptions);
      default = {};
      description = "Development containers configuration";
    };
  };

  config = {
    containers = mapAttrs mkDevContainer cfg;
  };
}
