{ ... }:
{
  services.mastodon = {
    enable = true;
    localDomain = "return12.net";
    configureNginx = true;
    smtp.fromAddress = "";
    extraConfig = {
      WEB_DOMAIN = "mastodon.return12.net";
      SINGLE_USER_MODE = "true";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "james@return12.net";
  };
}
