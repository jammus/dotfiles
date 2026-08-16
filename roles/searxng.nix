{ lib, ... }:
{
  services.searx = {
    enable = true;
    environmentFile = "/run/agenix/searxng.env";
    settings = {
      server = {
        secret_key = "@SEARX_SECRET_KEY@";
        bind_address = "127.0.0.1";
        port = 7327;
      };
    };
    # uncomment for rate limiting / bot protection:
    # redisCreateLocally = true;
  };

  services.internalProxy.routes.searx = "localhost:7327";
}
