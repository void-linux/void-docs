# Pinebook Pro

The Pinebook Pro is a Rockchip RK3399-based laptop.

See Pine64's [documentation](https://pine64.org/documentation/Pinebook_Pro) for
more information.

## Installation

The live ISO provided by Void is generic and does not have U-Boot integrated.
You need to provide your own firmware installed on the internal SPI flash, eMMC,
or an SD card, such as
[Tow-Boot](https://tow-boot.org/devices/pine64-pinebookPro.html) or
[rk2aw](https://xnux.eu/rk2aw/).

Boot an aarch64 Void Linux live ISO using one of the "Void Linux for Pinebook
Pro" menu entries in GRUB.

To install, follow the [chroot install guide](../chroot.md), using the "XBPS
method", observing the following modifications:

For the base installation, install both `base-system` and `pinebookpro-base`.
This package provides important configurations and installs the necessary
dependencies.

Before running `grub-install`, append the following to `/etc/default/grub`:

```
GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT console=ttyS2,115200 video=eDP-1:1920x1080x60"
GRUB_DEFAULT_DTB="rockchip/rk3399-pinebook-pro.dtb"
```

> Note: if using another bootloader, ensure the kernel cmdline arguments
> `console=ttyS2,115200 video=eDP-1:1920x1080x60` are used.
