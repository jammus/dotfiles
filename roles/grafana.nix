{ pkgs, config, ... }:
{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "taskmaster";
        http_port = 2342;
        http_addr = "0.0.0.0";
      };
    };
    dataDir = "/nas/services/grafana";
  };

  services.prometheus = {
    scrapeConfigs = [
      {
        job_name = "taskmaster";
        static_configs = [{
          targets = [ "taskmaster:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
      {
        job_name = "time-eater";
        static_configs = [{
          targets = [ "100.94.214.41:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };
}
