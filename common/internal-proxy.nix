{ lib, ... }:
{
  options.services.internalProxy = {
    domain = lib.mkOption {
      type = lib.types.str;
      default = "int.r12.sh";
      description = ''
        Base domain for internal, Tailscale-only services. Each route <name>
        is served at <name>.<domain> behind a single wildcard certificate.
      '';
    };
    routes = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = { matrix = "localhost:8008"; };
      description = ''
        Map of subdomain label to backend (host:port). Set from each service's
        own role; consumed by the Caddy role on hosts that run it.
      '';
    };
  };
}
