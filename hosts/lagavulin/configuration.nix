# MacBook Pro 16" (2019) — Intel i9 + Radeon Pro 5500M, Apple T2 chip.
# Desktop-role machine: stays docked, keeps macOS in a partition for the
# occasional Mac-only job, does the heavy x86 work.
#
# T2 support comes from nixos-hardware/apple-t2, imported in flake.nix.
# Install steps, dual-boot, suspend and GPU quirks: ./NOTES.md

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/base.nix
    ../../common/users.nix
    ../../common/networking.nix
    ../../common/bluetooth.nix
    ../../common/sound.nix
    ../../common/games.nix
    # ../../common/desktop.nix is imported from flake.nix, same as giant-head.
  ];

  networking.hostName = "lagavulin";

  # --- Apple T2 ---------------------------------------------------------
  # Wi-Fi/Bluetooth firmware pulled from Apple recovery images at build time.
  hardware.apple-t2.firmware.enable = true;

  # Real Touch Bar buttons (media/brightness) rather than F-keys only.
  hardware.apple.touchBar = {
    enable = true;
    settings.MediaLayerDefault = true;
  };

  # The dGPU stays the primary display adapter. On the 16" the external
  # outputs hang off the Radeon, and that is the configuration that modesets
  # at boot. Flipping to iGPU-primary costs external display support and is
  # documented in NOTES.md as a battery experiment, not the default.
  # hardware.apple-t2.enableIGPU = true;

  # --- Graphics ---------------------------------------------------------
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steam / Proton
  };

  # --- Boot -------------------------------------------------------------
  # The ESP is shared with macOS and is only 300M, and systemd-boot keeps
  # kernels inside it. Keep generations low and watch `df /boot`.
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    configurationLimit = 5;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # --- Power / thermal --------------------------------------------------
  services.thermald.enable = true;
  zramSwap.enable = true;

  # --- Desktop ----------------------------------------------------------
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Gamepads
  hardware.xone.enable = true;
  services.udev.extraRules = ''
    # DualShock 4 over Bluetooth
    KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"
  '';

  # NOTE: if plugging in a monitor ever freezes the machine (fans to max,
  # sudden shutdown), that is the known amdgpu mode-change crash. The fix is
  # an udev rule pinning power_dpm_force_performance_level — see NOTES.md.
  # Left off by default because it clamps the dGPU and you would feel it in
  # games.

  virtualisation.libvirtd.enable = true;

  system.stateVersion = "26.11";
}
