{ pkgs, ... }:
{
  services.internalProxy.routes.matrix = "localhost:8008";

  services.matrix-synapse = {
    enable = true;
    dataDir = "/nas/services/matrix-synapse";

    settings = {
      # User IDs become @name:taskmaster. Reachable over Tailscale MagicDNS.
      server_name = "taskmaster";
      public_baseurl = "https://matrix.int.r12.sh/";

      # SQLite is Synapse's default; spelled out here to be explicit.
      database.name = "sqlite3";

      # Listen on 8008 for both client and (unused) federation traffic.
      # Bound to all interfaces, but only reachable over tailscale0 since
      # 8008 is not in networking.firewall.allowedTCPPorts.
      listeners = [
        {
          port = 8008;
          bind_addresses = [ "0.0.0.0" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = false;
            }
          ];
        }
      ];

      # No open federation for a local test server.
      enable_registration = true;
      enable_registration_without_verification = true;
    };
  };
}
