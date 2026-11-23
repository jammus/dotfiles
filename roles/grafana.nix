{ config, lib, pkgs, ... }:
let
  prometheusUid = "prometheus";
  communityDashboard =
    {
      id,
      revision,
      hash,
      name,
    }:
    pkgs.runCommand "grafana-dashboard-${name}.json" { nativeBuildInputs = [ pkgs.jq ]; } ''
      jq --arg uid ${lib.escapeShellArg prometheusUid} '
        walk(
          if type == "object" and has("datasource") then
            if (.datasource | type) == "object" then .datasource.uid = $uid
            else .datasource = $uid end
          else . end
        )
        | del(.__inputs, .id)
      ' ${
        pkgs.fetchurl {
          url = "https://grafana.com/api/dashboards/${toString id}/revisions/${toString revision}/download";
          inherit hash;
        }
      } > $out
    '';

  communityDashboards = pkgs.linkFarm "grafana-community-dashboards" [
    {
      name = "prometheus/node-exporter-full.json";
      path = communityDashboard {
        id = 1860;
        revision = 45; # dashboard version 101, 2023-01
        hash = "sha256-GExrdAnzBtp1Ul13cvcZRbEM6iOtFrXXjEaY6g6lGYY=";
        name = "node-exporter-full";
      };
    }
    {
      name = "storage/smartctl-exporter.json";
      path = communityDashboard {
        id = 22604;
        revision = 4;
        hash = "sha256-ah36BdFIcaprUz39hRzuYVzfp3diEBckmalMaOls5kY=";
        name = "smartctl-exporter";
      };
    }
    {
      name = "prometheus/alertmanager.json";
      path = communityDashboard {
        id = 9578;
        revision = 4;
        hash = "sha256-/scCKBKqTjRKKImIrEYLBKGweOUnkx+QsD5yLfdXW5o=";
        name = "alertmanager";
      };
    }
  ];
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

    provision = {
      enable = true;

      datasources.settings = {
        apiVersion = 1;
        datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            uid = prometheusUid;
            access = "proxy";
            url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            isDefault = true;
            editable = false;
            jsonData = {
              httpMethod = "POST";
              timeInterval = "60s"; # matches Prometheus' scrape interval
            };
          }
        ];
      };

      dashboards.settings = {
        apiVersion = 1;
        providers = [
          {
            name = "homelab"; # dashboards authored in this repo
            options.path = ./grafana-dashboards;
            foldersFromFilesStructure = true;
            allowUiUpdates = false;
            disableDeletion = true;
            updateIntervalSeconds = 60;
          }
          {
            name = "community"; # pinned grafana.com dashboards
            options.path = communityDashboards;
            foldersFromFilesStructure = true;
            allowUiUpdates = false;
            disableDeletion = true;
            updateIntervalSeconds = 60;
          }
        ];
      };
    };
  };

  services.prometheus.scrapeConfigs = [
    # node exporters
    {
      job_name = "taskmaster";
      static_configs = [
        { targets = [ "taskmaster:${toString config.services.prometheus.exporters.node.port}" ]; }
      ];
    }
    {
      job_name = "time-eater";
      static_configs = [
        { targets = [ "100.94.214.41:${toString config.services.prometheus.exporters.node.port}" ]; }
      ];
    }

    # taskmaster only exporters
    {
      job_name = "smartctl";
      static_configs = [
        { targets = [ "localhost:${toString config.services.prometheus.exporters.smartctl.port}" ]; }
      ];
    }
    {
      job_name = "zfs";
      static_configs = [
        { targets = [ "localhost:${toString config.services.prometheus.exporters.zfs.port}" ]; }
      ];
    }

    # prometheus itself + alertmanager
    {
      job_name = "prometheus";
      static_configs = [
        { targets = [ "localhost:${toString config.services.prometheus.port}" ]; }
      ];
    }
    {
      job_name = "alertmanager";
      static_configs = [
        { targets = [ "localhost:${toString config.services.prometheus.alertmanager.port}" ]; }
      ];
    }
  ];
}
