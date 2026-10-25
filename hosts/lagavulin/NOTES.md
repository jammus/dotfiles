# lagavulin — MacBook Pro 16" (2019), NixOS

`MacBookPro16,1`: i9-9980HK, Radeon Pro 5500M (Navi 14), Apple T2, 300M shared
ESP, macOS Tahoe kept on the APFS partition.

Role: desk-bound x86 workstation. The M1 (`chuckd`) stays on macOS as the
portable daily driver — see the reasoning in the chat that produced this host.

## Layout

| Part | Size | FS | Mount |
|---|---|---|---|
| nvme0n1p1 | 300M | vfat | `/boot` (shared with macOS — do not delete) |
| nvme0n1p2 | — | APFS | macOS Tahoe, untouched |
| nvme0n1p3 | rest | LUKS2 → btrfs | `/`, `/nix`, `/home`, `/persist` |
| nvme0n1p4 | 8G | LUKS2 swap | optional, see Hibernation |

btrfs subvolumes: `@`, `@nix`, `@home`, `@persist` (same logical shape as
giant-head, minus ZFS).

Why not ZFS: the T2 module replaces `boot.kernelPackages` with a patched
kernel, so ZFS becomes an out-of-tree module compiled against a forked
kernel, and ZFS root rules out swap/hibernate. One disk, no redundancy — the
only thing we actually wanted was snapshots, which btrfs gives us in-tree.

## Pre-install (macOS side)

1. Full Time Machine backup. The T2 partition work is not reversible.
2. Shrink APFS to make room: Disk Utility, or
   `diskutil apfs resizeContainer disk1 600g` (leave room for Linux + swap).
3. Security: hold **Cmd+R** into Recovery → Utilities → Startup Security
   Utility → set secure boot to **No Security** and allow booting from
   external media. This is what disables FileVault; there is no way around it
   for Linux on a T2 Mac.
4. Follow <https://wiki.t2linux.org/guides/preinstall/> — it covers the
   partition creation and the `bless` step that makes Linux appear in the
   power-button boot picker.
5. Wi-Fi/BT firmware: we get it declaratively
   (`hardware.apple-t2.firmware.enable`), so nothing to do here unless
   `nixos-install` needs network and the live ISO has no driver — in that case
   use the imperative `get-apple-firmware` from the install guide.

## Install

```bash
# in the live environment
cryptsetup luksFormat /dev/nvme0n1p3
cryptsetup open /dev/nvme0n1p3 cryptroot
mkfs.btrfs /dev/mapper/cryptroot
mount /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/@{,nix,home,persist}
umount /mnt
mount -o subvol=@,compress=zstd:1 /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{nix,home,persist,boot}
mount -o subvol=@nix,compress=zstd:1 /dev/mapper/cryptroot /mnt/nix
mount -o subvol=@home,compress=zstd:1 /dev/mapper/cryptroot /mnt/home
mount -o subvol=@persist,compress=zstd:1 /dev/mapper/cryptroot /mnt/persist
mount /dev/nvme0n1p1 /mnt/boot          # existing ESP, do not reformat

blkid                                   # fill in the UUIDs in
                                        # hardware-configuration.nix
```

Then the usual:

```bash
nixos-generate-config --root /mnt       # to sanity-check initrd modules
# merge, don't overwrite, hardware-configuration.nix
nixos-install --flake .#lagavulin
```

## First boot checklist

- [ ] `df /boot` — a 300M ESP with macOS on it. If generations start failing
      to build, lower `boot.loader.systemd-boot.configurationLimit` (currently
      5) before touching anything else.
- [ ] Internal display up, backlight adjust works.
- [ ] Keyboard, trackpad (no force-touch/palm-rejection — expected on Linux).
- [ ] `tiny-dfr` running: `systemctl status tiny-dfr`, Touch Bar shows media
      keys.
- [ ] Wi-Fi + Bluetooth up; BT is glitchy when also on 2.4 GHz Wi-Fi.
- [ ] Audio out + mic (mic is quiet by design without DSP).
- [ ] Suspend/resume: `systemctl suspend`. Expect trouble; see below.
- [ ] External display over USB-C, then hot-plug, then suspend/resume docked.

## Known quirks

**amdgpu freeze on mode change.** The t2linux wiki lists crashes on
resolution changes and `DRI_PRIME` as partially-working. Symptom: freeze,
fans to max, sudden shutdown. Fix:

```bash
echo low | sudo tee /sys/bus/pci/drivers/amdgpu/0000:0?:00.0/power_dpm_force_performance_level
```

...as a udev rule in `configuration.nix` (the commented block explains why it
is not on by default: `low` clamps the dGPU and you would notice in games).
Switch to `high` before GPU-heavy work.

**External displays.** One display per USB-C port; there is no MST, so no
daisy-chaining and no two-monitors-off-one-hub. 4K60 per port is comfortable,
5K/6K needs DSC and has known flicker bugs. Internal panel on the iGPU plus
externals on the dGPU means Wayland (niri/Plasma) — avoid Xorg for multi-GPU.

**Thunderbolt.** Marked working, but docks are the flakiest part: booting
docked is fine, undock/suspend/monitor-power-cycle can wedge the DP path. If
devices misbehave, add `pcie_ports=native` to `boot.kernelParams`. Prefer
direct USB-C→DP cables over a dock.

**Battery mode (experiment, not default).** Idle is ~20W with the dGPU
primary; writing `OFF` via vgaswitcheroo drops it to ~9W, but it is a
boot-time choice, not a hot toggle, and it may cost external display output
on this model. To try it: set `hardware.apple-t2.enableIGPU = true` and add
the `amdgpu-off.service` from
<https://wiki.t2linux.org/guides/hybrid-graphics/>, then test with a monitor
attached before relying on it.

**Hibernation.** `zramSwap` only. If you want a real hibernate, create a
second LUKS2 partition for swap during the pre-install (you will not get
another chance once APFS is grown back), add it as `boot.initrd.luks.devices`
+ `swapDevices` + `boot.resumeDevice`. Untested on T2 — measure before
depending on it.

**Shared ESP with macOS.** Never let anything format `/boot`. Apple's
`/EFI/BOOT/BOOTX64.EFI` may be reused by systemd-boot; keep a copy before the
first install if the boot picker stops showing macOS.

## Deliberately not here (vs giant-head)

No `common/gpu/nvidia.nix` (amdgpu), no ZFS/`hostId`, no `services.printing`,
no syncthing folders, no CIFS `/nas/media` mount, no agenix/secrets. Add
`agenix.nixosModules.default` + `secrets.nixosModules.secrets` to the flake
entry when this host needs real secrets — note the SSH host keys would then
want to live in `/persist/ssh` rather than the default.
