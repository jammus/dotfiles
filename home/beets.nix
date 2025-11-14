{ pkgs, ... }:
{
  programs.beets = {
    enable = true;
    settings = {
      directory = "/nas/media/music";
      library = "/nas/services/beet/beets.db";
      plugins = [
        "autobpm"
        "edit"
        "embedart"
        "fetchart"
        "lyrics"
        "mbsubmit"
        "musicbrainz"
      ];
      autobpm = {
        auto = true;
      };
      embedart = {
        auto = true;
        ifempty = true;
      };
      fetchart = {
        auto = true;
        cover_names = "cover front art album folder back";
      };
      lyrics = {
        auto = true;
        sources ="lrclib";
        synced = true;
      };
      import = {
        duplicate_action = "ask";
        log = "/nas/services/beet/import.log";
        move = false;
        copy = true;
        write = true;
      };
      paths = {
        default = "$albumartist/$album%aunique{}/$artist - $album - $track $title";
        singleton = "$albumartist/Singles/$artist - $title";
        comp = "Various Artists/$album%aunique{}/$artist - $album - %if{$track,$track }$title";
      };
    };
  };
}
