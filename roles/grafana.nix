{ config, ... }:
let
  prometheusPort = config.services.prometheus.port;
  alertmanagerPort = config.services.prometheus.alertmanager.port;
  nodeExporterPort = config.services.prometheus.exporters.node.port;
  smartctlExporterPort = config.services.prometheus.exporters.smartctl.port;
  zfsExporterPort = config.services.prometheus.exporters.zfs.port;
in
{
  services.internalProxy.routes.grafana = "localhost:2342";

  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "taskmaster";
        http_port = 2342;
        http_addr = "0.0.0.0";
      };
      security = {
        secret_key = "$__file{/run/agenix/grafana-secret-key}";
      };
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "taskmaster";
      static_configs = [
        { targets = [ "taskmaster:${toString nodeExporterPort}" ]; }
      ];
    }
    {
      job_name = "time-eater";
      static_configs = [
        { targets = [ "100.94.214.41:${toString nodeExporterPort}" ]; }
      ];
    }

    {
      job_name = "smartctl";
      static_configs = [
        { targets = [ "localhost:${toString smartctlExporterPort}" ]; }
      ];
    }
    {
      job_name = "zfs";
      static_configs = [
        { targets = [ "localhost:${toString zfsExporterPort}" ]; }
      ];
    }

    {
      job_name = "prometheus";
      static_configs = [
        { targets = [ "localhost:${toString prometheusPort}" ]; }
      ];
    }
    {
      job_name = "alertmanager";
      static_configs = [
        { targets = [ "localhost:${toString alertmanagerPort}" ]; }
      ];
    }
  ];
}
