{ config, ... }:
{
  services = {
    syncthing = {
      enable = true;
      user = "jammus";
      dataDir = "/home/jammus/.local/syncthing";    # Default folder for new synced folders
      configDir = "/home/jammus/.config/syncthing";   # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "giant-head" = { id = "SRSZLOH-7TBRX3J-BB6VSTX-FJHBNN3-VNJHJ3A-CM4MMNA-A77TAP6-XYRMZQG"; };
          "taskmaster" = { id = "2ECO2VV-2RWO6XR-6YNQTF5-4PDYNUV-L26NTQY-V7IJ5NR-UOAEUAV-VRYOSA7"; };
          "book-of-stabbing" = { id = "GOQ5RV6-IENWWXR-WCB3SNT-7HNT5MV-RWJISIE-FQ75IPO-ORNR3P3-VSCNQA4"; };
        };
        folders = {
          "nb" = {
            path = "/home/jammus/nb";
            devices = [ "giant-head" "taskmaster" "book-of-stabbing" ];
          };
        };
      };
    };
  };
}
