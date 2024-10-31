# Supported Platforms

## Raspberry Pi

The `rpi-kernel` packages for all Raspberry Pi variants are built from the
Raspberry Pi Foundation's kernel tree, which should enable all special
functionality that isn't available with mainline kernels. The RPi kernel
packages also have their own header packages, `rpi-kernel-headers`. These
packages should be installed if you want to use any DKMS packages. Void ships
`rpi-base` meta-packages that install the relevant `rpi-kernel` and
`rpi-firmware` packages. Together, these packages enable Wi-Fi and Bluetooth
functionality.

The [command line](../../../config/kernel.md#cmdline) parameters passed to the
kernel are in the `/boot/cmdline.txt` file. Some of the relevant parameters are
documented in the [official
documentation](https://www.raspberrypi.com/documentation/computers/configuration.html#the-kernel-command-line).

### Supported Models

| Model                                       | Architecture |
|---------------------------------------------|--------------|
| 1 A, 1 B, 1 A+, 1 B+, Zero, Zero W, Zero WH | armv6l       |
| 2 B                                         | armv7l       |
| 3 B, 3 A+, 3 B+, Zero 2W, 4 B, 400, CM4, 5  | aarch64      |

> It is possible to run the armv7l images on an RPi 3, as the RPi 3's CPU
> supports both the Armv8 and Armv7 instruction sets. The difference between
> these images is that the armv7l image provides a 32-bit system while the
> aarch64 image provides a 64-bit system.

### Raspberry Pi 5 Kernel

The `rpi5-kernel` and `rpi5-kernel-headers` packages provide a kernel and
headers optimized for the Raspberry Pi 5 with 16KB pages. To switch from the
generic `rpi-kernel`, install `rpi5-kernel`. This will remove `rpi-kernel` and
replace it with `rpi5-kernel`.

> Note: not all software is compatible with kernels that have larger page-sizes.
> View any known issues and report any compatibility problems found in the
> [tracking issue](https://github.com/void-linux/void-packages/issues/48260).

### Enabling hardware RNG device

By default, the
[HWRNG](https://en.wikipedia.org/wiki/Hardware_random_number_generator) device
is not used by the system, which may result in the random devices taking long to
seed on boot. This can be annoying if you want to start `sshd` and expect to be
able to connect immediately.

In order to fix this, install the `rng-tools` package and
[enable](../../../config/services/index.md#enabling-services) the `rngd`
service, which uses the `/dev/hwrng` device to seed `/dev/random`.

### Graphical session

The `mesa-dri` package contains drivers for all the Raspberry Pi variants, and
can be used with the [modesetting Xorg
driver](../../../config/graphical-session/xorg.md#modesetting) or
[Wayland](../../../config/graphical-session/wayland.md).

### Hardware

More configuration information can be found in the Raspberry Pi Foundation's
[official
documentation](https://www.raspberrypi.com/documentation/computers/configuration.html).
The `raspi-config` utility isn't available for Void Linux, so editing the
`/boot/config.txt` file is usually required.

#### Audio

To enable the soundchip, add `dtparam=audio=on` to `/boot/config.txt`.

#### Serial

To enable serial console logins,
[enable](../../../config/services/index.md#enabling-services) the
`agetty-ttyAMA0` service. See
[securetty(5)](https://man.voidlinux.org/securetty.5) for interfaces that allow
root login. For configuration of the serial port at startup, refer to the kernel
command line in `/boot/cmdline.txt` - in particular, the
`console=ttyAMA0,115200` parameter.

### I2C

To enable [I2C](https://en.wikipedia.org/wiki/I%C2%B2C), add
`device_tree_param=i2c_arm=on` to `/boot/config.txt`, and
`bcm2708.vc_i2c_override=1` to `/boot/cmdline.txt`. Then create a
[modules-load(8)](https://man.voidlinux.org/modules-load.8) `.conf` file with
the following content:

```
i2c-dev
```

Finally, install the `i2c-tools` package and use
[i2cdetect(8)](https://man.voidlinux.org/i2cdetect.8) to verify your
configuration. It should show:

```
$ i2cdetect -l
i2c-1i2c          bcm2835 I2C adapter                 I2C adapter
```

### Memory cgroup

The kernel from the `rpi-kernel` package [disables the memory cgroup by
default](https://github.com/raspberrypi/linux/commit/28aec65bb1743c9bfa53b036999f9835c889704e).

This breaks workloads which use containers. Therefore, if you want to use
containers on your Raspberry Pi, you need to enable memory cgroups by adding
`cgroup_enable=memory` to `/boot/cmdline.txt`.

## Lenovo X13s

The Lenovo X13s Snapdragon-based laptop is supported on kernel 6.8 and higher,
with some caveats. See [jhovold's
wiki](https://github.com/jhovold/linux/wiki/X13s) for the current feature
support status.

### Installation

Before installing, [update the UEFI
firmware](https://support.lenovo.com/ca/en/downloads/ds556845-bios-update-utility-bootable-cd-for-windows-11-thinkpad-x13s-gen-1-type-21bx-21by)
from Windows, then disable "Secure Boot" and enable "Linux Boot" in the UEFI
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

The `void-installer` script provided on Void live ISOs currently is not
compatible with this device.

### WWAN (LTE)

To enable the WWAN modem, install `ModemManager` and unlock it:

```
# mkdir -p /etc/ModemManager/fcc-unlock.d
# ln -s /usr/share/ModemManager/fcc-unlock.available.d/105b /etc/ModemManager/fcc-unlock.d/105b:e0c3
```
