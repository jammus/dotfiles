{ config, lib, ... }:
# Metrics exporters for a host scraped by the central Prometheus on taskmaster.
# Import this on every monitored host; import roles/prometheus.nix only on the
# host that actually runs Prometheus itself.
{
  services.prometheus.exporters = {
    node = {
      enable = lib.mkDefault true;
      port = lib.mkDefault 9002; # same port everywhere, so scrape configs can reuse it
      enabledCollectors = lib.mkDefault (
        [ "systemd" ] ++ lib.optional config.boot.zfs.enabled "zfs"
      );
    };

    # Auto-detected: on where ZFS is actually in use, off elsewhere.
    # Override per host with `services.prometheus.exporters.zfs.enable = <bool>;`.
    zfs.enable = lib.mkDefault config.boot.zfs.enabled;

    # Cannot be auto-detected (needs smartctl access to real disks), so opt in
    # per host with `services.prometheus.exporters.smartctl.enable = true;`.
    smartctl = {
      enable = lib.mkDefault false;
      maxInterval = lib.mkDefault "60s";
    };
  };
}
