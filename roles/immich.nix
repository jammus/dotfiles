{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.immich-docker;
in {
  options.services.immich-docker = {
    enable = mkEnableOption "immich monodocker service";
  };

  config = mkIf cfg.enable {
    systemd.services.init-filerun-network-and-files = {
      description = "Create the network bridge for Immich.";
      after = [ "network.target" ];
      serviceConfig.Type = "oneshot";
      wantedBy = [
        "podman-immich.service"
        "podman-redis.service"
        "podman-postgres14.service"
      ];
      script = ''
        ${pkgs.podman}/bin/podman pod exists immich-pod || \
          ${pkgs.podman}/bin/podman pod create -n immich-pod -p '0.0.0.0:2283:2283'
      '';
    };

    virtualisation.oci-containers.containers = {
      immich = {
        autoStart = true;
        image = "ghcr.io/imagegenius/immich:v2.0.1-ig427";
        dependsOn = [ "redis" "postgres14" ];
        volumes = [
          "/nas/services/immich:/config"
          "/nas/photos/library:/photos"
          "/nas/services/immich-ml:/config/machine-learning"
        ];
        environment = {
          PUID = "1000";
          PGID = "100";
          TZ = "Asia/Singapore"; # Change this to your timezone
          DB_HOSTNAME = "postgres14";
          DB_USERNAME = "postgres";
          DB_PASSWORD = "postgres";
          DB_DATABASE_NAME = "immich";
          REDIS_HOSTNAME = "redis";
          SERVER_PORT = "2283";
        };
        extraOptions = [ "--pod=immich-pod" ];
      };

      redis = {
        autoStart = true;
        image = "redis";
        extraOptions = [ "--pod=immich-pod" ];
      };

      postgres14 = {
        autoStart = true;
        image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0";
        volumes = [
          "/nas/photos/db:/var/lib/postgresql/data"
        ];
        environment = {
          POSTGRES_USER = "postgres";
          POSTGRES_PASSWORD = "postgres";
          POSTGRES_DB = "immich";
          POSTGRES_INITDB_ARGS = "--data-checksums";
          DB_STORAGE_TYPE = "HDD";
        };
        extraOptions = [ "--pod=immich-pod" "--shm-size=128mb" ];
      };
    };
  };
}
