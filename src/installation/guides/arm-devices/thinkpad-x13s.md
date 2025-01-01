# Lenovo ThinkPad X13s

The Lenovo ThinkPad X13s Snapdragon-based laptop is supported on kernel 6.8 and
higher, with some caveats. See [jhovold's
wiki](https://github.com/jhovold/linux/wiki/X13s) for the current feature
support status.

## Installation

Before installing, update the UEFI firmware to at least version 1.59 from
Windows, then disable "Secure Boot" and enable "Linux Boot" in the UEFI
firmware.

Boot an aarch64 Void Linux live ISO using one of the "Void Linux for Thinkpad
X13s" menu entries in GRUB.

To install, follow the [chroot install guide](../chroot.md), using the "XBPS
method", observing the following modifications:

For the base installation, install both `base-system` and `x13s-base`. This
package provides important configurations and installs the necessary
dependencies.

Before running `grub-install`, append the following to `/etc/default/grub`:

```
GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT arm64.nopauth clk_ignore_unused pd_ignore_unused"
GRUB_DEFAULT_DTB="qcom/sc8280xp-lenovo-thinkpad-x13s.dtb"
```

> Note: if using another bootloader, ensure the kernel cmdline arguments
> `arm64.nopauth clk_ignore_unused pd_ignore_unused` are used.

## WWAN (LTE)

To enable the WWAN modem, install `ModemManager` and unlock it:

```
# mkdir -p /etc/ModemManager/fcc-unlock.d
# ln -s /usr/share/ModemManager/fcc-unlock.available.d/105b /etc/ModemManager/fcc-unlock.d/105b:e0c3
```
