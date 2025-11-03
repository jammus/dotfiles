{ pkgs, ... }:
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
        SSH_PORT = 222;
        HTTP_PORT = 3000;
      };
    };
  };
}
