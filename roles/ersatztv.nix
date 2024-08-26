{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.ersatztv;
in {
  options.services.ersatztv = {
    enable = mkEnableOption "ersatztv docker service";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      ersatztv = {
        autoStart = true;
        image = "jasongdove/ersatztv:latest-vaapi";
        volumes = [
          "/nas/services/ersatztv:/root/.local/share/ersatztv"
          "/nas/media/videos:/nas/media/videos"
        ];
        ports = [
          "8409:8409"
        ];
        environment = {
          TZ = "Asia/Singapore";
        };
        extraOptions = [ 
          "--network=host" 
          "--device=/dev/dri"
        ];
      };
    };
  };
}
