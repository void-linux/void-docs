# Apple Silicon

Void's Apple Silicon support is based on Asahi Linux. See their
[website](https://asahilinux.org) and
[documentation](https://asahilinux.org/docs) for more information.

## Installation

Before installing, use the Asahi Linux install script to install "UEFI
environment only" from macOS:

```
macos $ curl https://alx.sh > alx.sh
macos $ sh ./alx.sh
```

When selecting the minimal UEFI environment installation option, the Asahi
Installer can be directed to create free space for a future root filesystem. You
must use this facility to prepare your disk for Void Linux, rather than
attempting to manually shrink or alter APFS containers via the Void Linux live
ISO.

Then, [create a Live USB](../../live-images/prep.md) using an [Apple Silicon
Void Linux ISO](https://voidlinux.org/download/#arm%20platforms). U-Boot
(installed by the Asahi installer) should show the external USB as a boot
option. If it does not, run these commands in the U-Boot prompt to boot:

```
U-Boot> setenv boot_targets "usb"
U-Boot> setenv bootmeths "efi"
U-Boot> boot
```

To install, follow the [chroot install guide](../chroot.md), using the "XBPS
method", observing the following modifications:

Do not alter or rearrange any disk structure other than the free space left by
Asahi Installer. For our purposes, the EFI System Partition is the one created
by Asahi Linux install script, and it should be mounted at `/mnt/boot/efi`.

For the base installation, install `base-system` and `asahi-base`. This package
provides important configurations and installs the necessary dependencies. When
running `grub-install`, add the `--removable` flag.

To use another bootloader with `m1n1`, ensure it installs the bootloader EFI
executable at `EFI/BOOT/BOOTAA64.EFI` within the EFI system partition. `m1n1`
can also be configured to boot a kernel and initramfs directly, without a
bootloader. To do this, change the `PAYLOAD` in `/etc/default/m1n1-kernel-hook`
to `kernel`.

## Audio

The `asahi-audio` package is required for audio. Ensure the speakersafetyd
service is [enabled](../../../config/services/index.md#enabling-services), and
set up [pipewire and wireplumber](../../../config/media/pipewire.md).

## Firmware

Firmware can be updated with `asahi-fwupdate` from `asahi-scripts`. It is
recommended to do so whenever the `asahi-firmware` package is updated.
