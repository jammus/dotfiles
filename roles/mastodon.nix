{ config, ... }:
{
  services.mastodon = {
    enable = true;
    localDomain = "return12.net";
    configureNginx = false;
    smtp.fromAddress = "";
    enableUnixSocket = false;
    extraConfig = {
      WEB_DOMAIN = "mastodon.return12.net";
      SINGLE_USER_MODE = "true";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "james@return12.net";
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  services.nginx.virtualHosts."return12.net" = {
    forceSSL = true;
    enableACME = true;

    locations."/" = {
      extraConfig = ''
        return 301 https://www.return12.net$request_uri;
      '';
    };

    locations."/.well-known/webfinger" = {
      extraConfig = ''
        return 301 https://mastodon.return12.net$request_uri;
      '';
    };
  };

  services.nginx.virtualHosts."mastodon.return12.net" = {
    forceSSL = true;
    enableACME = true;

    root = "${config.services.mastodon.package}/public/";

    locations."/system/".alias = "/var/lib/mastodon/public-system/";

    locations."/" = {
      tryFiles = "$uri @proxy";
    };

    locations."@proxy" = {
      proxyPass = (if config.services.mastodon.enableUnixSocket then "http://unix:/run/mastodon-web/web.socket" else "http://127.0.0.1:${toString(config.services.mastodon.webPort)}");
      proxyWebsockets = true;
    };

    locations."/api/v1/streaming/" = {
      proxyPass = (if config.services.mastodon.enableUnixSocket then "http://unix:/run/mastodon-streaming/streaming.socket" else "http://127.0.0.1:${toString(config.services.mastodon.streamingPort)}/");
      proxyWebsockets = true;
    };
  };

  users.groups.${config.services.mastodon.group}.members =
    [config.services.nginx.user];
}
