{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.immich;
in {
  options.services.immich = {
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
          ${pkgs.podman}/bin/podman pod create -n immich-pod -p '0.0.0.0:2283:8080'
      '';
    };

    virtualisation.oci-containers.containers = {
      immich = {
        autoStart = true;
        image = "ghcr.io/imagegenius/immich:v1.111.0-ig314";
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
        image = "tensorchord/pgvecto-rs:pg14-v0.2.0";
        volumes = [
          "/nas/photos/db:/var/lib/postgresql/data"
        ];
        environment = {
          POSTGRES_USER = "postgres";
          POSTGRES_PASSWORD = "postgres";
          POSTGRES_DB = "immich";
        };
        extraOptions = [ "--pod=immich-pod" ];
      };
    };
  };
}
