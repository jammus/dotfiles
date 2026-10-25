# Written by hand ahead of the install. Do NOT trust the UUIDs below — they
# are placeholders. On the target machine either:
#
#   1) run `nixos-generate-config --root /mnt` and merge the fileSystems /
#      initrd sections over this one, or
#   2) fill in the UUIDs from `blkid` after the LUKS + btrfs setup in NOTES.md.
#
# Expected layout (single disk, nvme0n1):
#
#   p1  300M   vfat   ESP, shared with macOS        -> /boot
#   p2         APFS   macOS Tahoe (kept)            -> untouched
#   p3         LUKS2  -> btrfs, subvolumes          -> /, /nix, /home, /persist
#   p4  8G     LUKS2  swap (optional, for hibernate; see NOTES.md)
#
# Subvolumes: @ (root), @nix, @home, @persist — same logical shape as
# giant-head, minus ZFS.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # --- LUKS ---------------------------------------------------------------
  # Replace with the LUKS2 container UUID from `blkid /dev/nvme0n1p3`.
  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";

  # Run `cryptsetup luksDump` and put the *inner* LUKS2 header here so the
  # disk can only be unlocked with the right passphrase + header pair.
  # boot.initrd.luks.devices."cryptroot".crypttabExtraOpts = [ ];

  # --- btrfs subvolumes ---------------------------------------------------
  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd:1" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
    options = [ "subvol=@persist" "compress=zstd:1" "noatime" ];
    neededForBoot = true;
  };

  # --- ESP (shared with macOS) -------------------------------------------
  # 300M, not ours alone. systemd-boot lives here; macOS files must survive.
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0000-0000";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # Swap: zramSwap is on in configuration.nix. A disk swap partition is a
  # separate decision — see the hibernation section of NOTES.md.
  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
