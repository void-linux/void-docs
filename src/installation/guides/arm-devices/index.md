# ARM Devices

Void Linux provides packages and images for several ARM devices. Installing Void
on such devices can be done in several ways:

- [Pre-built images](#pre-built-images): images that can be flashed directly
   onto an SD card or other storage medium, but which give you a limited
   partition layout, and require manual expansion if you wish to increase the
   size of the partitions;
- [Tarball installation](#tarball-installation): PLATFORMFS and ROOTFS tarballs
   that can be extracted to a previously prepared partition scheme; and
- [Chroot installation](#chroot-installation): follows most of the steps
   outlined in [the chroot guide](../chroot.md).

This guide also outlines [configuration steps](#configuration) that are mostly
specific to such devices.

Since most of the commands in this guide will be run on external storage, it is
important to run [sync(1)](https://man.voidlinux.org/sync.1) before removing the
device.

## Installation

If you are installing Void Linux on one of the ARM devices covered in the
"[Supported platforms](./platforms.md)" page, make sure to read its section
thoroughly.

### Pre-built images

After [downloading and verifying](../../index.md#downloading-installation-media)
an image, it can be written to the relevant media with
[cat(1)](https://man.voidlinux.org/cat.1),
[pv(1)](https://man.voidlinux.org/pv.1), or
[dd(1)](https://man.voidlinux.org/dd.1). For example, to flash it onto an SD
card located at `/dev/mmcblk0`:

```
# dd if=<image>.img of=/dev/mmcblk0 bs=4M status=progress
```

### Custom partition layout

Customizing an installation - for example, with a custom partition layout -
requires a more involved process. Two available options are:

- [Tarball installation](#tarball-installation); and
- [Chroot installation](#chroot-installation).

To prepare the storage for these installation methods, it is necessary to
partition the storage medium and then mount the partitions at the correct mount
points.

The usual partitioning scheme for ARM devices requires at least two partitions,
on a drive formatted with an MS-DOS partition table:

- one formatted as FAT32 with partition type `0c`, which will be mounted on
   `/boot`;
- one that can be formatted as any file system that Linux can boot from, such as
   ext4, which will be mounted on `/`. If you're using an SD card, you can
   create the ext4 file system with the `^has_journal` option - this disables
   journaling, which might increase the drive's life, at the cost of a higher
   chance of data loss. If e2fsprogs version is >= 1.47.0 (may happen if not
   using Void), you must use the `^metadata_csum_seed,^orphan_file` option, so
   `e2fsck` shipped with Void could properly check the disk.

There are a variety of tools available for partitioning, e.g.
[cfdisk(8)](https://man.voidlinux.org/cfdisk.8).

To access the newly created file systems, it is necessary to mount them. This
guide will assume that the second partition will be mounted on `/mnt`, but you
may mount it elsewhere. To mount these filesystems, you can use the commands
below, replacing the device names with the appropriate ones for your setup:

```
# mount /dev/mmcblk0p2 /mnt
# mkdir /mnt/boot
# mount /dev/mmcblk0p1 /mnt/boot
```

#### Tarball installation

First, [download and verify](../../index.md#downloading-installation-media) a
PLATFORMFS or ROOTFS tarball for your desired platform and [prepare your storage
medium](#custom-partition-layout). Then, unpack the tarball onto the file system
using [tar(1)](https://man.voidlinux.org/tar.1):

```
# tar xvfp <image>.tar.xz -C /mnt
```

#### Chroot installation

It is also possible to perform a chroot installation, which can require the
`qemu-user-static` package together with either the `binfmt-support` or `proot`
package if a computer with an incompatible architecture (such as i686) is being
used. This guide explains how to use the `qemu-<platform>-static` program from
`qemu-user-static` with [proot(1)](https://man.voidlinux.org/proot.1).

First, [prepare your storage medium](#custom-partition-layout). Then, follow
either the [XBPS chroot installation](../chroot.md#the-xbps-method) or the
[ROOTFS chroot installation](../chroot.md#the-rootfs-method) steps, using the
appropriate architecture and base packages, some of which are listed in the
"[Supported Platforms](./platforms.md)" section.

Finally, follow the [chroot configuration steps](../chroot.md#configuration)
steps, but instead of using the [chroot(1)](https://man.voidlinux.org/chroot.1)
command to [enter the chroot](../chroot.md#entering-the-chroot), use the
following command, replacing `<platform>` with `arm` for armv6l and armv7l
devices, and with `aarch64` for aarch64 devices:

```
# proot -q qemu-<platform>-static -r /mnt -w /
```

## Configuration

Some additional configuration steps need to be followed to guarantee a working
system. Configuring a [graphical
session](../../../config/graphical-session/index.md) should work as normal.

### Logging in

For the pre-built images and tarball installations, the `root` user password is
`voidlinux`.

### fstab

The `/boot` partition should be added to `/etc/fstab`, with an entry similar to
the one below. It is possible to boot without that entry, but updating the
kernel package in that situation can lead to breakage, such as being unable to
find kernel modules, which are essential for functionality such as wireless
connectivity. If you aren't using an SD card, replace `/dev/mmcblk0p1` with the
appropriate device path.

```
/dev/mmcblk0p1 /boot vfat defaults 0 0
```

### System time

Several of the ARM devices supported by Void Linux don't have battery powered
real time clocks (RTCs), which means they won't keep track of time once powered
off. This issue can present itself as HTTPS errors when browsing the Web or
using the package manager. It is possible to set the time manually using the
[date(1)](https://man.voidlinux.org/date.1) utility. Chrony is configured by
default, but it's possible to install and enable [aother NTP
client](../../../config/date-time.md#ntp). Furthermore, it is possible to
install the `fake-hwclock` package, which provides the `fake-hwclock` service.
[fake-hwclock(8)](https://man.voidlinux.org/fake-hwclock.8) periodically stores
the current time in a configuration file and restores it at boot, leading to a
better initial approximation of the current time, even without a network
connection.

**Warning**: Images from before 2020-03-16 might have an issue where the
installation of the `chrony` package, the default NTP daemon, is incomplete, and
the system will be missing the `chrony` user. This can be checked in the output
of the [getent(1)](https://man.voidlinux.org/getent.1) command, which will be
empty if it doesn't exist:

```
$ getent group chrony
chrony:x:997
```

In order to fix this, it is necessary to reconfigure the `chrony` package using
[xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure).

### Graphical session

The `xf86-video-fbturbo` package ships a modified version of the [DDX Xorg
driver](../../../config/graphical-session/xorg.md#ddx) found in the
`xf86-video-fbdev` package, which is optimized for ARM devices. This can be used
for devices which lack more specific drivers.
