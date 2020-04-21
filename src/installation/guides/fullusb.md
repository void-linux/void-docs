# Live USB To Full Install

This installation guide converts a Live USB of Void Linux into a Full Pervasive
Void Install. It's recommended to use a machine with at least 4GB of RAM, and a
USB with at least 4GB of storage.

> **Note:**
> 
> All commands in this guide are utilizing the
> [BASH(1)](https://man.voidlinux.org/bash) shell. Other shells may be used, but
> results may vary.

## Setup

If it has not been done so already, [download](./../live-images/downloading.md)
a Void Live iso and [write it to a USB](./../live-images/prep.md).

To begin, boot into the RAM option when prompted in GRUB.

```
Void Linux
**Void Linux(RAM)**
Boot First HD Found by BIOS
```

Then un-mount the USB from the system, leaving the entire root filesystem in
RAM, which allows it to continue running even when the media is disconnected:

```
# umount /run/initramfs/live
```

Locate the USB using [fdisk(8)](https://man.voidlinux.org/fdisk):

```
# fdisk -l
Disk /dev/sdc: 28.66 GiB, 30752636928 bytes, 60063744 sectors
Disk model: Ultra           
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 20E776A8-6DB3-6449-B740-0E080C28A890

Device     Start      End  Sectors  Size Type
/dev/sdc2   2048 60063710 60057567 28.7G Linux filesystem
```

## Partitioning

Prepare the USB for installation by creating one of the following partition
schemes using [cfdisk(8)](https://man.voidlinux.org/cfdisk) or another
partitioning tool:

`# cfdisk -z /dev/sdc`

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

For a BIOS/MBR system using GRUB:

```
Partition    Size       Type
1             ?G     Linux (83)
```

For a BIOS/GPT system using GRUB:

```
Partition    Size       Type
1             2M     BIOS Boot
2             ?G     Linux Filesystem
```

Then make the file system on the new Linux partition:

`# mkfs.ext4 /dev/sdcX`

## Base Installation

To begin installing the new system mount the USB stick to a directory which
allows its contents to be modified by another system:

`# mount /dev/sdc1 /mnt/void`

Populate the USB with the following directories, which will provide mountpoints
to the current system's devices:

`# mkdir /mnt/void{proc.sys.dev}`

Then mount the required directories for a succesfull installation:

```
# mount -B /dev /mnt/void/dev
# mount -t devpts pts /mnt/void/dev/pts
# mount -t proc proc /mnt/void/proc
# mount -t sysfs sys /mnt/void/sys
```

Install the base system onto the USB along with any other packages needed to
assist in configuration: (ie. NetworkManager, Vim, Nano, etc.)

`# xbps-install -S -R http://alpha.de.repo.voidlinux.org/current -r /mnt/void
base-system grub`

Or for Musl systems use:

`# XBPS_ARCH=$(uname -m)-musl xbps-install -S -R
http://alpha.de.repo.voidlinux.org/current/musl -r /mnt/void base-system grub`

## GRUB Installation

[Chroot(1)](https://man.voidlinux.org/chroot) into the main mounted directory,
invoking BASH to replace DASH as a more feature complete terminal, and
specifying the terminal emulator to avoid errant behavior:

`# TERM=linux chroot /mnt/void bash`

Set the root password using [passwd(1)](https://man.voidlinux.org/passwd), which
will prevent the user from being locked out at restart:

`(chroot)# passwd root`

Set the new machine's hostname, replacing voidhost being the name of the new
machine:

`(chroot)# echo voidhost >/etc/hostname`

Install GRUB onto the USB stick specifying the path to the USB:

```
(chroot)# grub-install /dev/sdc
Installing for i386-pc platform.
Installation finished. No error reported.
```

Reconfigure Linux to update GRUB's configuration:

> **Note:**
> 
> If the Linux version on the system is unknown use a query to find the
> installed version on the new system:
> 
> `xbps-query -s linux | grep modules`

```
(chroot)# xbps-reconfigure -f linux5.4
linux5.4: configuring ...
Executing post-install kernel hook: 10-dkms ...
Executing post-install kernel hook: 20-dracut ...
Executing post-install kernel hook: 50-grub ...
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.4.32_1
Found initrd image: /boot/initramfs-5.4.32_1.img
Found void on /dev/sdc1
done
linux5.4: configured successfully.
```

## Configuration

For a general system configuration please consult the [Date and
Time](./../../config/date-time.md), [Rc Files](./../../config/rc-files.md), and
[Locales](./../../config/locales.md) pages of the handbook.

## Cleanup

Exit chroot:

`(chroot)$ exit`

And un-mount the chroot environment:

```
# umount /mnt/void/dev/pts
# umount /mnt/void/{dev,proc,sys}
# umount /mnt/void
```

Restart the system using [reboot(8)](https://man.voidlinux.org/reboot) and log
in:

`# reboot`
