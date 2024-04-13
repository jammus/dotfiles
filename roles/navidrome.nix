{ pkgs, ... }:
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/nas/media/music";
      DataFolder = "/nas/services/navidrome";
    };
  };
}
