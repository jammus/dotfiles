# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common/base.nix
      ../../common/users.nix
      ../../common/networking.nix
      ../../common/gpu/nvidia.nix
      ../../common/games.nix
      ../../common/sound.nix
      ../../common/bluetooth.nix
      ../../roles/syncthing.nix
    ];


  services.syncthing.settings.folders = {
    finance-data = {
      path = "/home/jammus/code/finances/data";
      devices = [ "taskmaster" ];
    };
    giant-head-docs = {
      path = "/home/jammus/docs";
      devices = [ "taskmaster" ];
    };
    datasette-data = {
      path = "/home/jammus/code/datasette-runner/data";
      devices = [ "taskmaster" ];
    };
  };

  services.openssh = {
    hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  services.udev.extraRules = ''
    # DualShock 4 over Bluetooth
    KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"
  '';

  hardware.xone.enable = true;

  virtualisation.docker.enable = true;

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    configurationLimit = 20;
  };
  boot.loader.efi.canTouchEfiVariables = true;


  # ZFS

  networking.hostId = "56d0d77b";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  networking.hostName = "giant-head"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.interfaces.enp38s0.wakeOnLan.enable = true;
  networking.nat.externalInterface = "enp38s0";

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_SG.UTF-8";

  programs.hyprland.enable = true;
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  environment.sessionVariables = rec {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Configure keymap and monitor setup in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
    screenSection = ''
      Option         "metamodes" "DP-2: nvidia-auto-select +0+0 {rotation=right, viewportin=1800x3200}, DP-0: nvidia-auto-select +1945+520 {AllowGSYNCCompatible=On}"
    '';
  };

  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cifs-utils  # for mounting samba share
  ];

  fileSystems."/nas/media" = {
    device = "//taskmaster/media";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},uid=1000,gid=100"];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This will save you money and possibly your life!
  services.thermald.enable = true;



  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
