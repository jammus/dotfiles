{ config, ... }:
{
  services.prometheus = {
    enable = true;
    port = 9001;

    ruleFiles = [ ./prometheus-alerts.yaml ];

    # Send firing alerts to the local alertmanager.
    alertmanagers = [
      {
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.alertmanager.port}" ];
          }
        ];
      }
    ];
  };

  services.prometheus.alertmanager = {
    enable = true;
    listenAddress = "127.0.0.1";

    checkConfig = false;
    configuration = {
      route = {
        receiver = "pushover";
        group_by = [ "alertname" "instance" ];
        group_wait = "0s";
        repeat_interval = "4h";
      };

      receivers = [
        {
          name = "pushover";
          pushover_configs = [
            {
              # Systemd credentials, not /run/agenix: the unit runs with
              # DynamicUser and cannot read root-only agenix files
              user_key_file = "/run/credentials/alertmanager.service/pushover-user-key";
              token_file = "/run/credentials/alertmanager.service/pushover-app-token";
              title = "{{ .CommonLabels.alertname }}";
              priority = ''{{ if eq .CommonLabels.severity "critical" }}2{{ else }}1{{ end }}'';
              retry = "1m";
              expire = "1h";
              sound = "siren";
              monospace = true;
            }
          ];
        }
      ];
    };
  };

  systemd.services.alertmanager.serviceConfig.LoadCredential = [
    "pushover-user-key:/run/agenix/pushover-user.token"
    "pushover-app-token:/run/agenix/prometheus-pushover.token"
  ];
}
