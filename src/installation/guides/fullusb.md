# Live USB To Full Install

This installation guide shows how to convert a Live USB of Void Linux into a
Full Pervasive Install. It's recommended to use a machine with at least 4GB of
RAM, and a USB with at least 4GB of storage to perform the installation.

## Setup

To begin [download](./../live-images/downloading.md) a Void Live ISO and [write
it to a USB](./../live-images/prep.md).

To modify the same device that the Operating System was booted from the root
filesystem must first be placed elsewhere, in this case the RAM. This can be
done from the Live USB by choosing the RAM option when prompted at boot:

```
Void Linux
**Void Linux(RAM)**
Boot First HD Found by BIOS
```

And un-mounting the remaining connection between the USB and the system:

`# umount /run/initramfs/live`

Then locate the USB using [fdisk(8)](https://man.voidlinux.org/fdisk) or
[lsblk(8)](https://man.voidlinux.org/lsblk):

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

To continue the installation, follow the [chroot install guide](./), which
continues to detail the rest of the installation process.
