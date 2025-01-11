{ pkgs, ... }:
{
  services.kavita = {
    enable = true;
    dataDir = "/nas/services/kavita";
    tokenKeyFile = "/run/agenix/kavita.token";
  };
}
