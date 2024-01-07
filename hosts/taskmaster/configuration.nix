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
      ../../roles/jellyfin.nix
      ../../roles/syncthing.nix
      ../../roles/nas.nix
      ../../roles/home-assistant.nix
    ];

  age.secrets."zfs.key".file = ../../secrets/zfs.key.age;

  services.zfs.autoScrub = {
    enable = true;
    interval = "*-*-1,15 02:30";
  };

  users.users = {
    gitea = {
      uid = 3001;
      group = "gitea";
      isNormalUser = true;
      extraGroups = [
      ];
    };
  };

  users.groups = {
    gitea = {
      gid = 3001;
    };
  };

  systemd.services.init-filerun-network-and-files = {
    description = "Create the network bridge for Immich.";
    after = [ "network.target" ];
    serviceConfig.Type = "oneshot";
    wantedBy = [
      "podman-immich.service" "podman-redis.service"
      "podman-postgres14.service"
    ];
    script = ''
      ${pkgs.podman}/bin/podman pod exists immich-pod || \
        ${pkgs.podman}/bin/podman pod create -n immich-pod -p '0.0.0.0:2283:8080'
    '';
  };

  # Immich
  virtualisation.oci-containers.containers = {
    immich = {
      autoStart = true;
      image = "ghcr.io/imagegenius/immich:latest";
      volumes = [
        "/nas/services/immich:/config"
        "/nas/services/immich-photos:/photos"
        "/nas/services/immich-ml:/config/machine-learning"
      ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Asia/Singapore"; # Change this to your timezone
        DB_HOSTNAME = "postgres14";
        DB_USERNAME = "postgres";
        DB_PASSWORD = "postgres";
        DB_DATABASE_NAME = "immich";
        REDIS_HOSTNAME = "redis";
      };
      extraOptions = [ "--pod=immich-pod" "--gpus=all" ];
    };

    redis = {
      autoStart = true;
      image = "redis";
      extraOptions = [ "--pod=immich-pod" ];
    };

    postgres14 = {
      autoStart = true;
      image = "tensorchord/pgvecto-rs:pg14-v0.1.11";
      volumes = [
        "pgdata:/var/lib/postgresql/data"
      ];
      environment = {
        POSTGRES_USER = "postgres";
        POSTGRES_PASSWORD = "postgres";
        POSTGRES_DB = "immich";
      };
      extraOptions = [ "--pod=immich-pod" ];
    };
  };


  virtualisation.oci-containers.containers = {
    gitea = {
      autoStart = true;
      image = "gitea/gitea:latest";
      environment = {
        USER_UID = "3001";
        USER_GID = "3001";
        DISABLE_REGISTRATION = "false";
      };
      volumes = [
        "/nas/services/gitea:/data"
      ];
      ports = [
        "3000:3000"
        "222:222"
      ];
      environment = {
        SSH_LISTEN_PORT = "222";
      };
      extraOptions = [
        "--network=host"
      ];
    };
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


  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      dockerSocket.enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      # For Nixos version > 22.11
      #defaultNetwork.settings = {
      #  dns_enabled = true;
      #};
    };
  };

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
  networking.interfaces.enp6s0.useDHCP = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-6501ce48-4b48-4dee-9552-55e836ead36c".device = "/dev/disk/by-uuid/6501ce48-4b48-4dee-9552-55e836ead36c";
  boot.initrd.luks.devices."luks-6501ce48-4b48-4dee-9552-55e836ead36c".keyFile = "/crypto_keyfile.bin";

  networking.hostId = "6d778fb4"; # Define your hostname.
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
