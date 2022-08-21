{
  services.taskserver.enable = true;
  services.taskserver.fqdn = "pistachio";
  services.taskserver.listenHost = "::";
  services.taskserver.organisations.return12.users = [ "jammus" ];
}
