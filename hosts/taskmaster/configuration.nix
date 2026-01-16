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
      ../../roles/jellyfin.nix
      ../../roles/syncthing.nix
      ../../roles/nas.nix
      ../../roles/home-assistant.nix
      ../../roles/pihole.nix
      ../../roles/navidrome.nix
      ../../roles/grafana.nix
      ../../roles/prometheus.nix
      ../../roles/immich.nix
      ../../roles/ersatztv.nix
      ../../roles/agent.nix
      ../../roles/forgejo.nix
      ../../roles/ci-runner.nix
    ];

  systemd.tmpfiles.rules = [
    "D /nas/services/prometheus2/data 0751 prometheus prometheus - -"
    "L+ /var/lib/${config.services.prometheus.stateDir}/data - - - - /nas/services/prometheus2/data"
  ];

  boot.kernelParams = [
    "i915.enable_guc=2"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };

  services.logrotate.checkConfig = false;  # temp during rescue

  services.pihole = {
    enable = true;
    serverIp = "100.72.171.50";
    persistanceRoot = "/nas/services/pihole";
  };

  services.immich-docker.enable = true;

  services.ersatztv-docker.enable = true;

  services.syncthing.settings.folders = {
    finance-data = {
      path = "/nas/junk/finance-data";
      devices = [ "giant-head" ];
    };
    giant-head-docs = {
      path = "/nas/junk/giant-head/docs";
      devices = [ "giant-head" ];
    };
    datasette-data = {
      path = "/nas/junk/data/datasette/data";
      devices = [ "giant-head" ];
    };
    music-download = {
      path =  "/nas/media/temp/music";
      devices = [ "giant-head" ];
    };
  };

  systemd.timers."archive-video" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "6h";
      OnUnitActiveSec = "6h";
      Unit = "archive-video.service";
    };
  };

  systemd.services."archive-video" = {
    path = [ pkgs.yt-dlp ];
    script = ''
      set -eu
      /nas/junk/data/videos/archive-videos.sh /nas/junk/data/videos /nas/media/videos
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "jellyfin";
    };
  };


  services.zfs.autoScrub = {
    enable = true;
    interval = "*-*-1,15 02:30";
  };

  services.borgbackup.jobs."borgbase" = {
    paths = [
      "/home/jammus/nb"
      "/home/jammus/dots"
      "/mnt/borgjobs/services"
      "/mnt/borgjobs/photos"
      "/mnt/borgjobs/junk"
      "/nas/media/audiobooks"
      "/nas/media/podcasts"
      "/nas/media/music"
      "/nas/media/books"
    ];
    exclude = [
    ];
    repo = "t51c4lr9@t51c4lr9.repo.borgbase.com:repo";
    preHook = ''
      ${pkgs.zfs}/bin/zfs destroy taskpool/services@borgbase && true
      ${pkgs.zfs}/bin/zfs snapshot taskpool/services@borgbase
      /run/wrappers/bin/mount --bind /nas/services/.zfs/snapshot/borgbase /mnt/borgjobs/services

      ${pkgs.zfs}/bin/zfs destroy taskpool/photos@borgbase && true
      ${pkgs.zfs}/bin/zfs snapshot taskpool/photos@borgbase
      /run/wrappers/bin/mount --bind /nas/photos/.zfs/snapshot/borgbase /mnt/borgjobs/photos

      ${pkgs.zfs}/bin/zfs destroy taskpool/junk@borgbase && true
      ${pkgs.zfs}/bin/zfs snapshot taskpool/junk@borgbase
      /run/wrappers/bin/mount --bind /nas/junk/.zfs/snapshot/borgbase /mnt/borgjobs/junk
    '';
    postHook = ''
      /run/wrappers/bin/umount /mnt/borgjobs/services
      ${pkgs.zfs}/bin/zfs destroy taskpool/services@borgbase

      /run/wrappers/bin/umount /mnt/borgjobs/photos
      ${pkgs.zfs}/bin/zfs destroy taskpool/photos@borgbase

      /run/wrappers/bin/umount /mnt/borgjobs/junk
      ${pkgs.zfs}/bin/zfs destroy taskpool/junk@borgbase
    '';
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /run/agenix/backup.passphrase";
    };
    environment.BORG_RSH = "ssh -i /run/agenix/backup_ed25519";
    compression = "auto,lzma";
    startAt = "daily";
  };

  users.users = {
    photos = {
      uid = 3002;  
      group = "photos";
      isSystemUser = true;
    };
    audiobookshelf = {
      uid = 3003;
      group = "media";
      isSystemUser = true;
    };
    calibre = {
      uid = 3005;
      group = "media";
      isSystemUser = true;
    };
    backup = {
      uid = 4001;
      group = "backup";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfkhhWt2ibQdKFhdWpcwywq+NVLAmZ8/lnpgjbVdEN4"
      ];
    };
  };

  users.groups = {
    photos = {
      gid = 3002;
    };
    backup = {
      gid = 4001;
    };
  };

  virtualisation.oci-containers.containers = {
    audiobookshelf = {
      autoStart = true;
      image = "ghcr.io/advplyr/audiobookshelf:latest";
      volumes = [
        "/nas/media/audiobooks:/audiobooks"
        "/nas/media/podcasts:/podcasts"
        "/nas/services/audiobookshelf/config:/config"
        "/nas/services/audiobookshelf/metadata:/metadata"
      ];
      ports = [
        "13378:80"
      ];
      environment = {
        AUDIOBOOKSHELF_UID = "${toString config.users.users.audiobookshelf.uid}";
        AUDIOBOOKSHELF_GID = "${toString config.users.groups.media.gid}";
        TZ = "Asia/Singapore"; # Change this to your timezone
      };
    };
  };

  virtualisation.oci-containers.containers = {
    podgrab = {
      autoStart = true;
      image = "akhilrex/podgrab";
      volumes = [
        "/nas/services/podgrab:/config"
        "/nas/media/podcasts:/assets"
      ];
      ports = [
        "3080:3080"
      ];
      environment = {
        CHECK_FREQUENCY = "240";
        PORT = "3080";
      };
      extraOptions = [
        "--network=host"
      ];
    };
  };


  virtualisation.oci-containers.containers = {
    calibre-web-automated = {
      autoStart = true;
      image = "crocodilestick/calibre-web-automated:latest";
      volumes = [
        "/nas/media/books:/calibre-library"
        "/nas/services/calibre-web-automated:/config"
        "/nas/media/temp/books:/cwa-book-ingest"
      ];
      ports = [
        "5084:8083"
      ];
      environment = {
        PUID = "${toString config.users.users.calibre.uid}";
        PID = "${toString config.users.groups.media.gid}";
        DOCKER_MODS = "lscr.io/linuxserver/mods:universal-calibre-v7.16.0";
        TZ = "Asia/Singapore"; # Change this to your timezone
      };
    };
  };

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
  };

  networking.hostId = "6d778fb4"; # Define your hostname.

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    configurationLimit = 20;
  };
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  boot.initrd = {
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;
        hostKeys = [ "/etc/ssh/initrd_ssh_host_ed25519_key" ];
        authorizedKeys = config.users.users.jammus.openssh.authorizedKeys.keys;
      };
    };
    availableKernelModules = [ "r8169" ];
  };
  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.nat.externalInterface = "enp7s0";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-6501ce48-4b48-4dee-9552-55e836ead36c".device = "/dev/disk/by-uuid/6501ce48-4b48-4dee-9552-55e836ead36c";
  boot.initrd.luks.devices."luks-6501ce48-4b48-4dee-9552-55e836ead36c".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "taskmaster"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_SG.UTF-8";
    LC_IDENTIFICATION = "en_SG.UTF-8";
    LC_MEASUREMENT = "en_SG.UTF-8";
    LC_MONETARY = "en_SG.UTF-8";
    LC_NAME = "en_SG.UTF-8";
    LC_NUMERIC = "en_SG.UTF-8";
    LC_PAPER = "en_SG.UTF-8";
    LC_TELEPHONE = "en_SG.UTF-8";
    LC_TIME = "en_SG.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    yt-dlp
    ffmpeg
  ];

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
  system.stateVersion = "23.05"; # Did you read the comment?

}
