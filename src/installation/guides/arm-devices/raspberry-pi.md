# Raspberry Pi

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

## Supported Models

| Model                                                | Architecture |
|------------------------------------------------------|--------------|
| 1 A, 1 B, 1 A+, 1 B+, Zero, Zero W, Zero WH          | armv6l       |
| 2 B                                                  | armv7l       |
| 3 B, 3 A+, 3 B+, Zero 2W, 4 B, 400, CM4, 5, 500, CM5 | aarch64      |

> It is possible to run the armv7l images on an RPi 3, as the RPi 3's CPU
> supports both the Armv8 and Armv7 instruction sets. The difference between
> these images is that the armv7l image provides a 32-bit system while the
> aarch64 image provides a 64-bit system.

## Raspberry Pi 5 Kernel

The `rpi5-kernel` and `rpi5-kernel-headers` packages provide a kernel and
headers optimized for the Raspberry Pi 5 with 16KB pages. To switch from the
generic `rpi-kernel`, install `rpi5-kernel`. This will remove `rpi-kernel` and
replace it with `rpi5-kernel`.

> Note: not all software is compatible with kernels that have larger page-sizes.
> View any known issues and report any compatibility problems found in the
> [tracking issue](https://github.com/void-linux/void-packages/issues/48260).

## Enabling hardware RNG device

By default, the
[HWRNG](https://en.wikipedia.org/wiki/Hardware_random_number_generator) device
is not used by the system, which may result in the random devices taking long to
seed on boot. This can be annoying if you want to start `sshd` and expect to be
able to connect immediately.

In order to fix this, install the `rng-tools` package and
[enable](../../../config/services/index.md#enabling-services) the `rngd`
service, which uses the `/dev/hwrng` device to seed `/dev/random`.

## Graphical session

The `mesa-dri` package contains drivers for all the Raspberry Pi variants, and
can be used with the [modesetting Xorg
driver](../../../config/graphical-session/xorg.md#modesetting) or
[Wayland](../../../config/graphical-session/wayland.md).

You may also need to uncomment the `dtoverlay=vc4-kms-v3d` line in
`/boot/config.txt`.

For Xorg, an [Xorg configuration file](https://man.voidlinux.org/xorg.conf.5)
may be needed, with the contents:

```
Section "OutputClass"
	Identifier "vc4"
	MatchDriver "vc4"
	Driver "modesetting"
	Option "PrimaryGPU" "true"
EndSection
```

## Hardware

More configuration information can be found in the Raspberry Pi Foundation's
[official
documentation](https://www.raspberrypi.com/documentation/computers/configuration.html).
The `raspi-config` utility isn't available for Void Linux, so editing the
`/boot/config.txt` file is usually required.

### Audio

To enable audio, you may need to uncomment `dtparam=audio=on` in
`/boot/config.txt`.

### Serial

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
