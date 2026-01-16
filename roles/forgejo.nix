{ pkgs, config, ... }:
{
  users = {
    users = {
      gitea = {
        uid = 3001;
        group = "gitea";
        isNormalUser = true;
        extraGroups = [
        ];
      };
    };

    groups = {
      gitea = {
        gid = 3001;
      };
    };
  };

  services.forgejo = {
    enable = true;
    user = "gitea";
    group = "gitea";
    package = pkgs.forgejo;
    lfs.enable = true;
    stateDir = "/nas/services/forgejo";
    settings = {
      server = {
        DOMAIN = "taskmaster";
        SSH_PORT = 2222;
        HTTP_PORT = 3000;
        START_SSH_SERVER = true;
      };
      actions = {
        ENABLED = true;
      };
    };
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "mono";
      url = "http://taskmaster:3000";
      tokenFile = "/run/agenix/forgejo-runner.token";
      labels = [
        "python3.12:docker://ghcr.io/astral-sh/uv:python3.12-bookworm"
        "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-latest"
      ];
      settings = {
        container = {
          network = "host";  # Use existing podman network instead of creating new ones
          options = "--add-host=taskmaster:100.72.171.50";
        };
      };
    };
  };
}
