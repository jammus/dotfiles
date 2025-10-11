{ pkgs, config, ... }:
{
  services.prometheus = {
    enable = true;
    port = 9001;
    stateDir = "prometheus2";
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" "zfs" ];
        port = 9002;
      };
    };
  };
}
