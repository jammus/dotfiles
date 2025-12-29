{ config, ... }:
{
  services.pixelfed = {
    enable = true;
    domain = "pix.taskmaster.local";
    nginx = {};
    secretFile = "/run/agenix/pixelfed.env";
    settings."FORCE_HTTPS_URLS" = false;
    settings."SESSION_SECURE_COOKIE" = false;
    settings."APP_URL" = "http://pix.taskmaster.local";
    dataDir = "/nas/services/pixelfed";
  };
}
