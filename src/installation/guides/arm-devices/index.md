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
- [Live images](../../live-images/index.md) (for aarch64 UEFI devices only).

This guide also outlines [configuration steps](#configuration) that are mostly
specific to such devices.

Platform-specific documentation is available for:

- [Apple Silicon](./apple-silicon.md)
- [Lenovo ThinkPad X13s](./thinkpad-x13s.md)
- [Pinebook Pro](./pinebook-pro.md)
- [Raspberry Pi](./raspberry-pi.md)

Since most of the commands in this guide will be run on external storage, it is
important to run [sync(1)](https://man.voidlinux.org/sync.1) before removing the
device.

## Installation

If you are installing Void Linux on one of the officially supported ARM devices,
make sure to read its page thoroughly.

### Pre-built images

The pre-built images provided are prepared for 1GB storage devices. After
[downloading and verifying](../../index.md#downloading-installation-media) an
image, it can be uncompressed with [unxz(1)](https://man.voidlinux.org/unxz.1)
and written to the relevant media with
[cat(1)](https://man.voidlinux.org/cat.1),
[pv(1)](https://man.voidlinux.org/pv.1), or
[dd(1)](https://man.voidlinux.org/dd.1). For example, to flash it onto an SD
card located at `/dev/mmcblk0`:

```
$ unxz -k <image>.img.xz
# dd if=<image>.img of=/dev/mmcblk0 bs=4M status=progress
```

On first boot, the root partition and filesystem will automatically expand to
fill available contiguous space in the storage device using
[growpart(1)](https://man.voidlinux.org/man1/growpart.1). This can be disabled
by commenting out `ENABLE_ROOT_GROWPART=yes` in `/etc/default/growpart`.

This can also be done manually after flashing with
[cfdisk(8)](https://man.voidlinux.org/cfdisk.8),
[fdisk(8)](https://man.voidlinux.org/fdisk.8), or another partitioning tool, and
the filesystem can be resized to fit the expanded partition with
[resize2fs(8)](https://man.voidlinux.org/resize2fs.8).

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
   chance of data loss.

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

It is also possible to perform a [chroot installation](../chroot.md) using the
appropriate architecture and base packages. Make sure to [prepare your storage
medium](#custom-partition-layout) properly for the device.

If doing this from a computer with an incompatible architecture (such as
x86_64), install `binfmt-support`, enable the `binfmt-support` service, and
install the relevant QEMU user emulator (like `qemu-user-aarch64` for aarch64 or
`qemu-user-arm` for 32-bit ARM) before installing. If `binfmt-support` was
installed after the QEMU user emulator, use `xbps-reconfigure -f
qemu-user-<arch>` to enable the relevant binfmts.

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
[date(1)](https://man.voidlinux.org/date.1) utility. In order to fix this issue
for subsequent boots, install and enable [an NTP
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
