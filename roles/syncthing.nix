{ config, ... }:
{
  services = {
    syncthing = {
      enable = true;
      user = "jammus";
      dataDir = "/home/jammus/docs";    # Default folder for new synced folders
      configDir = "/home/jammus/docs/.config/syncthing";   # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      devices = {
        "giant-head" = { id = "A42RQCE-7M67JCX-2VSR2TU-HLZXZVG-KAXTVP7-L6BS4OX-L5FYWVW-WUTDFQI"; };
      };
      folders = {
        "nb" = {
          path = "/home/jammus/nb";
          devices = [ "giant-head" ];
        };
      };
    };
  };
}
