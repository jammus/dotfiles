{ pkgs, ... }:
{
  services.kativa = {
    enable = true;
    dataDir = "/nas/services/kavita";
  };
}
