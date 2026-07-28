{ pkgs, ... }:
{
  services.internalProxy.routes.forge = "localhost:3000";

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
        DOMAIN = "forge.int.r12.sh";
        ROOT_URL = "https://forge.int.r12.sh/";
        SSH_PORT = 2222;
        HTTP_PORT = 3000;
        START_SSH_SERVER = true;
      };
      actions = {
        ENABLED = true;
      };
    };
  };
}
