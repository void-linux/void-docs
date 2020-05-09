# Live USB To Full Install

This installation guide shows how to convert a Live USB of Void Linux into a
Full Pervasive Install. It's recommended to use a machine with at least 4GB of
RAM, and a USB with at least 4GB of storage.

## Setup

If it has not been done so already, [download](./../live-images/downloading.md)
a Void Live iso and [write it to a USB](./../live-images/prep.md).

To begin, boot into the RAM option when prompted in GRUB.

```
Void Linux
**Void Linux(RAM)**
Boot First HD Found by BIOS
```

Then un-mount the USB from the system, which allows the machine to continue
running even without the media (as root has been placed entirely in RAM), which
in turn allows for modifications to be made to the USB.

```
# umount /run/initramfs/live
```

Locate the USB using [fdisk(8)](https://man.voidlinux.org/fdisk) or
[lsblk(8)](https://man .voidlinux.org/lsblk):

`# fdisk -l`

> **Important:**
> 
> *Before creating the partition tables it's essential to remove the existing
> GRUB install, this can be done using one of the following commands.*
> 
> *For BIOS/MBR use:*
> 
> `# dd if=/dev/zero of=/dev/sdc seek=1 count=2047`
> 
> *For BIOS/GPT use:*
> 
> `# dd if=/dev/zero of=/dev/sdc seek=1 count=6143`

## Installation

To continue, follow the [chroot installation guide](), which details the rest of
the installation process.
