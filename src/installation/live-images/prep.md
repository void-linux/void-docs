# Prepare Installation Media

After [downloading a live image](../downloading.md), it must be written to
bootable media, such as a USB drive, SD card, or CD/DVD.

## Create a bootable USB drive or SD card on Linux

### Identify the Device

Before writing the image, identify the device you'll write it to. You can do
this using [fdisk(8)](https://man.voidlinux.org/man8/fdisk.8). After connecting
the storage device, identify the device path by running:

```
# fdisk -l
Disk /dev/sda: 7.5 GiB, 8036286464 bytes, 15695872 sectors
Disk model: Your USB Device's Model
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

In the example above, the output shows the USB device as `/dev/sda`. On Linux,
the path to the device will typically be in the form of `/dev/sdX` (where X is a
number) for USB devices, `/dev/mmcblkX` for SD cards, or other variations
depending on the device. You can use the model and size (`7.5GiB` above, after
the path) to identify the device if you're not sure what path it will have.

Once you've identified the device you'll use, ensure it's not mounted by
unmounting it with [umount(8)](https://man.voidlinux.org/man8/umount.8):

```
# umount /dev/sdX
umount: /dev/sdX: not mounted.
```

### Write the live image

The [dd(1)](https://man.voidlinux.org/man1/dd.1) command can be used to copy a
live image to a storage device. Using dd, write the live image to the device:

> **Warning**: this will destroy any data currently on the referenced device.
> Exercise caution.

```
# dd bs=4M if=/path/to/void-live-ARCH-DATE-VARIANT.iso of=/dev/sdX
90+0 records in
90+0 records out
377487360 bytes (377 MB, 360 MiB) copied, 0.461442 s, 818 MB/s
```

dd won't print anything until it's completed (or if it failed), so depending on
the device, this can take a few minutes or longer.

Finally, ensure all data is flushed before disconnecting the device:

```
$ sync
```

The number of records, amount copied, and rates will all vary depending on the
device and the live image you chose.

## Burning to a CD or DVD

Any disk burning application should be capable of writing the `.iso` file to a
CD or DVD. The following free software applications are available
(cross-platform support may vary):

- [Brasero](https://wiki.gnome.org/Apps/Brasero/)
- [K3B](https://userbase.kde.org/K3b)
- [Xfburn](https://goodies.xfce.org/projects/applications/xfburn)

> Note: with a CD or DVD, live sessions will be less responsive than with a USB
> or hard drive.
