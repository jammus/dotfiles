{ pkgs, lib, config, ... }:
let
  cfg = config.services.internalProxy;

  routeBlock = name: backend: ''
    @${name} host ${name}.${cfg.domain}
    handle @${name} {
      reverse_proxy ${backend}
    }
  '';
  routesConfig = lib.concatStringsSep "\n" (lib.mapAttrsToList routeBlock cfg.routes);
in {
  services.caddy = {
    enable = true;

    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-7GoH8YLCoPmPExQxoga2FHB58zQDoZVf1BBwkVi0SsQ=";
    };

    virtualHosts."*.${cfg.domain}".extraConfig = ''
      tls {
        dns cloudflare {env.CF_API_TOKEN}
        resolvers 1.1.1.1
      }
      ${routesConfig}
    '';
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile =
    "/run/agenix/cloudflare-int.r12.sh";
}
