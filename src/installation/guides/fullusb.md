# Live USB To Full Install

This installation guide explains how to convert a Live USB of Void Linux into a
Full Install. It is recommended to use a machine that has at least 4GB of RAM,
and a USB drive with more than 4GB of storage to perform the installation.

## Setup

To begin, [download](./../downloading.md) a Void Live ISO and [write it to a USB
drive](./../live-images/prep.md).

In order to modify the device that the operating system was booted from, the
root filesystem must first be placed elsewhere. In this case, it's placed into
the machine's RAM. This can be done from the Live USB by choosing the RAM option
when prompted at boot:

```
Void Linux
**Void Linux(RAM)**
Boot First HD Found by BIOS
```

and then un-mounting the remaining connection between the USB and the system:

```
# umount /run/initramfs/live
```

Then locate the USB using [fdisk(8)](https://man.voidlinux.org/fdisk.8), with
the `-l` argument, or [lsblk(8)](https://man.voidlinux.org/lsblk.8).

**Important:** Before creating the partition tables it is essential to remove
the existing GRUB install. This can be done using one of the following commands.

For BIOS/MBR use:

```
# dd if=/dev/zero of=/dev/sdc seek=1 count=2047
```

For BIOS/GPT use:

```
# dd if=/dev/zero of=/dev/sdc seek=1 count=6143
```

## Installation

To continue the installation, follow the [chroot install guide](./chroot.md),
which details the rest of the process.
