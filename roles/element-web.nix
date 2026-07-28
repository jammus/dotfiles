{ pkgs, ... }:
{
  services.internalProxy.routes.element = "localhost:8009";

  services.nginx = {
    enable = true;
    virtualHosts."taskmaster" = {
      listen = [ { addr = "0.0.0.0"; port = 8009; } ];
      root = pkgs.element-web.override {
        conf = {
          default_server_config."m.homeserver" = {
            base_url = "https://matrix.int.r12.sh";
            server_name = "taskmaster";
          };
          # Skip the homeserver-picker screen.
          disable_custom_urls = true;
        };
      };
    };
  };
}
