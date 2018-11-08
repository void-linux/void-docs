# Preparing installation media

All supported installation images are available on the Void Linux
[download page](https://voidlinux.org/download/). After obtaining an
image, it must be written to a storage device, such as a USB drive, SD
card, or CD/DVD.

## Create a bootable USB drive or SD card on Linux or UNIX

The `dd` command can be used to copy a live image to a storage device.

After connecting the storage device, identify the device path by
running:

```
# fdisk -l
```

> Note: on Linux, the path will typically be in the form `/dev/sdX`.

Next, ensure the device is not currently mounted:

```
# umount /dev/sdX
```

Write the live image to the device:

> **Warning**: this will destroy any data currently on the referenced
> device. Exercise caution.

```
# dd bs=4M if=/path/to/void-live-ARCH-DATE-VARIANT.iso of=/dev/sdX
```

Ensure all data is flushed before disconnecting the device:

```
$ sync
```

## Create a bootable USB drive or SD card on Windows

The [USBWriter](https://sourceforge.net/projects/usbwriter/) program
is the only recommended method of creating a bootable drive on
Windows. Other programs may mangle the data and make the drive
ultimately unable to boot.

## Burning to a CD or DVD

Any disk burning application should be capable of writing the `.iso`
file to a CD or DVD. The following free software applications are
available (cross-platform support may vary):

* [Brasero](https://wiki.gnome.org/Apps/Brasero/)
* [K3B](https://userbase.kde.org/K3b)
* [Xfburn](https://goodies.xfce.org/projects/applications/xfburn)

> Note: with a CD or DVD, live sessions will be less responsive than
> with a USB or hard drive.
