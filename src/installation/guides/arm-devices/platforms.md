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
kernel are in the `rootfs/boot/cmdline.txt` file. Some of the relevant
parameters are documented in the [official
documentation](https://www.raspberrypi.org/documentation/configuration/cmdline-txt.md).

### Supported Models

| Model          | Architecture | Live Image/PLATFORMFS/Kernel |
|----------------|--------------|------------------------------|
| 1 A, B, A+, B+ | armv6l       | `rpi`                        |
| Zero, 0W, 0WH  | armv6l       | `rpi`                        |
| 2 B            | armv7l       | `rpi2`                       |
| 3 B, A+, B+    | aarch64      | `rpi3`                       |
| Zero 2W        | aarch64      | `rpi3`                       |
| 4 B, 400       | aarch64      | `rpi4`                       |

> It is possible to run the RPi 2 images on an RPi 3, as the RPi 3's CPU
> supports both the Armv8 and Armv7 instruction sets. The difference between
> these images is that the RPi 2 provides a 32-bit system with packages from the
> Void `armv7l` repositories, while the RPi 3 image provides a 64-bit system
> with packages from the Void `aarch64` repositories.

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
documentation](https://www.raspberrypi.org/documentation/configuration/). The
`raspi-config` utility isn't available for Void Linux, so editing the
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
default](https://github.com/raspberrypi/linux/commit/9b0efcc1ec497b2985c6aaa60cd97f0d2d96d203#diff-f1d702fa7c504a2b38b30ce6bb098744).

This breaks workloads which use containers. Therefore, if you want to use
containers on your Raspberry Pi, you need to enable memory cgroups by adding
`cgroup_enable=memory` to `/boot/cmdline.txt`.
