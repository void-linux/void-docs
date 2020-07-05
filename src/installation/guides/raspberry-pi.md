# Raspberry Pi

You can either:

- write a prebuilt image directly to your SD card (e.g. `dd if=<void-rpi.img>
   of=/dev/sdX bs=4M ; sync`), but that might give you a limited partition
   layout that has to be expanded manually afterwards;

or:

- prepare the partition layout of your SD card manually and extract a tarball to
   your SD card, as described by this guide.

The `rpi-kernel` packages for all Raspberry Pi variants are built from the
Raspberry Pi Foundation's kernel tree, which should enable you to use all
special functionality, such as Wi-Fi and Bluetooth. The RPi kernel packages also
have their own header packages, `rpi-kernel-headers`.

## Raspberry Pi 3: 32-bit or 64-bit?

It is possible (and to some extent advised) to run the RPi 2 images on your RPi
3, as the RPi 3's CPU supports both Armv8 and Armv7 instructions.

With the RPi 2 image you obviously just get a 32-bit Armv7 system. That is
totally fine in general, and is what the popular Raspbian does too.

Be aware that some packages are not available for Armv7 and others are not
available for AArch64, so that might be a guide for your decision which one to
pick.

## rootfs-install

Grab the latest platformfs tarball (containing the rootfs as well as
architecture-specific files) for your device from
<https://alpha.de.repo.voidlinux.org/live/current/>, e.g.
`void-rpi2-musl-PLATFORMFS-<date>.tar.xz`.

### Preparing the SD card

The SD card must have at least two partitions, one as `FAT` (with partition type
`0c`) for `/boot` and another one as `ext4`/`f2fs` for `/`.

Prepare the partitions and mount them in a directory:

```
$ parted /dev/mmcblk0 # change this to match your SD card
```

Create the FAT partition of 256MB and make it bootable:

```
$ parted mktable msdos
$ parted mkpart primary fat32 2048s 256MB
$ parted toggle 1 boot
```

Create the rootfs partition, extending to the end of the device:

```
$ parted mkpart primary ext4 256MB -1
$ parted quit
```

Create the filesystems in the SD card:

```
$ mkfs.vfat /dev/mmcblk0p1 # change this to match your SD card and FAT32 partition
$ mkfs.ext4 -O '^has_journal' /dev/mmcblk0p2 # change this to match your SD card and ext4 partition
```

The `-O ^has_journal` option disables journaling on ext4 partition, which will
extend the life of your drive (usually Flash drives).

### Preparing target rootfs directory

```
$ mkdir rootfs
# mount /dev/mmcblk0p2 rootfs/
# mkdir rootfs/boot
# mount /dev/mmcblk0p1 rootfs/boot
```

Unpack the tarball into the target rootfs directory and sync to make sure files
are written to storage:

```
# tar xvfJp void-rpi*-PLATFORMFS-%DATE.tar.xz -C rootfs
# sync
```

Do not forget to unpack the rootfs as `root`, and with the `-p` flag, to set
appropriate permissions.

The `/boot` partition must be added to `/etc/fstab`:

```
# echo '/dev/mmcblk0p1 /boot vfat defaults 0 0' >> rootfs/etc/fstab
```

Umount the SD card filesystems from target rootfs directory.

You can tweak kernel boot cmdline arguments in the `rootfs/boot/cmdline.txt`
file.

Insert the SD card and test that the Raspberry PI boots correctly.

## First Boot

The `root` password is `voidlinux`.

### Set the system time

Before it is possible to install or upgrade packages, it is necessary to set the
clock, or you will see HTTPS certificate errors. The Raspberry Pi does not have
a battery-backed clock, so you must set the time manually.

Install and enable [an NTP server](../../config/date-time.md#ntp) and wait for
the date and time to be set.

??? However, if you still encounter SSL related errors or the time is still not
correct, it might be worth to reconfigure package chrony (`xbps-reconfigure -f
chrony`) because some images tend to not create chrony user and group, often
required by ntpd. ???

### Enabling hardware RNG device

By default the
[HWRNG](https://en.wikipedia.org/wiki/Hardware_random_number_generator) device
is not usedm which may result in the random devices taking long to seed on boot
(annoying if you want to start `sshd` and expect to be able to connect
immediately).

First, add the RPi's HWRNG kernel module (`bcm2835_rng`) to a file in
`/etc/modules-load.d`, such as `/etc/modules-load.d/rng.conf`.

Then install `rng-tools` and
[enable](../../config/services/index.md#enabling-services) the `rngd` service so
that the kernel's randomness will be seeded by the `hwrng` device.

## Applications

### X

For information about setting up X, refer to the
"[Xorg](../../config/graphical-session/xorg.md)" section.

Make sure the user running X is part of the groups `audio` and `video`.

## Hardware

### Audio

To get the soundchip to work, add `dtparam=audio=on` to `/boot/config.txt`.

### Serial

To enable serial console logins:

```
# mkdir ~/rootfs
# mount /dev/sdX2 ~/rootfs
# ln -s /etc/sv/agetty-ttyAMA0 ~/rootfs/etc/runit/runsvdir/default
# umount ~/rootfs
```

Notes:

- See `/boot/cmdline.txt` for start-up configuration of serial port (device and
   baud).
- See `/etc/securetty` for interfaces that allow root login, ttyAMA0 should
   already be listed.

### I2C

To enable [I2C](https://en.wikipedia.org/wiki/I%C2%B2C), add
`device_tree_param=i2c_arm=on` to `/boot/config.txt`, and
`bcm2708.vc_i2c_override=1` at the end of `/boot/cmdline.txt`.

If the latter doesn't exist, create a
[modules-load(8)](https://man.voidlinux.org/modules-load.8) directory named
`/etc/modules-load.d`, and in that directory, create the file `i2c.conf` with a
line `i2c-dev`. Then reboot.

Install the `i2c-tools` package and run `i2cdetect -l`. It should show:

```
i2c-1i2c          bcm2835 I2C adapter                 I2C adapter
```

## Miscellaneous

### DKMS

Building kernel modules (like `wireguard` or `zfs`) should generally work by
installing the package in question, but due to current limitations, you need to
install the `rpi-kernel-headers` package manually as well.
