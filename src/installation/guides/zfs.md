# ZFS On Root

This installation guide is assuming that an already existing Full Void Linux
Install is available. Not just a Live USB.

If an existing Void Install doesn't exist please consult the [Live USB To Full
Install](./fullusb.md) guide or the [General
Instalation](./../live-images/index.md) guide. Then continue along with this
guide.

> **Note**:
> 
> All commands in this guide are utilizing the
> [BASH(1)](https://man.voidlinux.org/bash) shell. Other shells may be used, but
> results may vary.

## Setup

From the permanent system install the `zfs` package.

Then ensure the ZFS module is loaded with
[modprobe(1)](https://man.voidlinux.org/modprobe):

`# modprobe zfs`

Locate the disk to format using [fdisk(8)](https://man.voidlinux.org/fdisk):

```
# fdisk -l
Disk /dev/sda: 931.53 GiB, 1000204886016 bytes, 1953525168 sectors
Disk model: Hitachi HDS72101
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 1AC1DE05-3145-DD4A-89F4-5B9C94C354BE

Device     Start        End    Sectors   Size Type
/dev/sda1   2048 1953525134 1953518991 931.5G Linux
```

## Partitioning

Prepare the drive for installation by creating one of the following partition
schemes using [cfdisk(8)](https://man.voidlinux.org/cfdisk) or another
partitioning tool:

`# cfdisk -z /dev/sda`

> **Warning:**
> 
> The disk being partitioned will be formatted and any existing data on the disk
> will be destroyed.

For a BIOS/MBR system using GRUB:

```
Partition    Size       Type
1             ?G     Solaris Root(bf00)
```

For a BIOS/GPT system using GRUB:

```
Partition    Size       Type
1             2M     BIOS boot    
2             ?G     Solaris Root
```

ZFS pools should use id's to maintain universal functionality across computers
and to prevent the misrecognition of drives.

Id's can be located in the `/dev/disk/by-id` folder:

> **Note:**
> 
> `wwn-` entries and `ata-` entries are referencing equivalent drvies and either
> can be used.

```
$ ls -l /dev/disk/by-id
total 0
lrwxrwxrwx 1 root root  9 Apr 16 17:34 ata-Hitachi_HDS721010CLA332_JP6911HD2AHS9F -> ../../sda
lrwxrwxrwx 1 root root 10 Apr 16 17:34 ata-Hitachi_HDS721010CLA332_JP6911HD2AHS9F-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Apr 16 17:34 ata-Hitachi_HDS721010CLA332_JP6911HD2AHS9F-part2 -> ../../sda2
lrwxrwxrwx 1 root root  9 Apr 16 17:34 wwn-0x5000cca373e0f5d9 -> ../../sda
lrwxrwxrwx 1 root root 10 Apr 16 17:34 wwn-0x5000cca373e0f5d9-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Apr 16 17:34 wwn-0x5000cca373e0f5d9-part2 -> ../../sda2
```

Create a pool named zroot specifying the previously created Solaris Root
Partition from your disk

`# zpool create -f -o ashift=12 -m none zroot <dev>`

| Command      | Action                                              |
|--------------|-----------------------------------------------------|
| -f           | Force the creation of the pool                      |
| -o ashift=12 | Set sector size to 4k **(don't set this on SSD's)** |
| -m none      | Set the mountpoint to none                          |
| <dev>        | The device to be used in the creation of the pool   |
|              | (ie. ata-XXXXX-partX or wwn-XXXX-partX)             |

To ensure that the pool was created use:

```
$ zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
zroot   928G   432K   928G        -         -     0%     0%  1.00x    ONLINE  -
```

> **Optional:**
> 
> 

Then create the following data sets, which are ZFS's equivalent to partitions:

```
# zfs create -o mountpoint=none zroot/ROOT
# zfs create -o mountpoint=/ zroot/ROOT/void
cannot mount '/': directory is not empty
property may be set but unable to remount filesystem
```

## Base Installation

To mount the system for installation export then re-import the pool at an
alternate mountpoint:

```
# zpool export zroot
# zpool import -R /mnt/void zroot
```

Populate the new installation with the following directories, which will provide
mountpointsto the current system's devices:

```
# mkdir /mnt/void/{dev,sys,proc}
```

Then mount the directories required for a successfull installation:

```
# mount -B /dev /mnt/void/dev
# mount -t devpts pts /mnt/void/dev/pts
# mount -t proc proc /mnt/void/proc
# mount -t sysfs sys /mnt/void/sys
```

Install the base system onto the drive along with any other packages needed to
assist in configuration: (ie. NetworkManager, Vim, Nano, etc.)

`# xbps-install -S -R https://alpha.de.repo.voidlinux.org/current -r /mnt/void
base-system grub zfs`

## GRUB Installation

[Chroot(1)](https://man.voidlinux.org/chroot) into the new installation,
invoking BASH to replace DASH as a more feature complete terminal, and
specifying the terminal emulator to avoid errant behavior:

`# TERM=linux chroot /mnt/void bash`

Set the root password using [passwd(1)](https://man.voidlinux.org/passwd), which
will prevent the user from being locked out at restart:

`(chroot)# passwd root`

Confirm the ZFS modules are loaded in the new system using
[lsmod(8)](https://man.voidlinux.org/lsmod):

```
(chroot)$ lsmod | grep zfs
zfs                  4022272  1
zunicode              335872  1 zfs
zlua                  172032  1 zfs
zavl                   16384  1 zfs
icp                   294912  1 zfs
zcommon                86016  2 zfs,icp
znvpair                69632  2 zfs,zcommon
spl                   102400  5 zfs,icp,znvpair,zcommon,zavl
```

Set the new machine's hostname, replacing zfshost with the name of the new
machine:

`(chroot)# echo zfshost >/etc/hostname`

Setup the ZFS cachefile, to ensure the new machine recognizes the created pool.

`(chroot)# zpool set cachefile=/etc/zfs/zpool.cache zroot`

Then notate the bootable system for GRUB's autoconfig:

`(chroot)# zpool set bootfs=zroot/ROOT/void zroot`

Also ensure GRUB recognizes the ZFS module.

> **Note:**
> 
> When using id's set the ZPOOL_VDEV_NAME_PATH variable to 1.

```
(chroot)# ZPOOL_VDEV_NAME_PATH=1 grub-probe /
zfs
```

> **Optional:**
> 

Install GRUB onto the drive specifying the path to the drive:

```
(chroot)# ZPOOL_VDEV_NAME_PATH=1 grub-install /dev/sda
Installing for i386-pc platform.
Installation finished. No error reported.
```

Create and modify `/etc/dracut.conf.d/zol.conf` to configure Dracut to include
at least the following values:

```
hostonly="yes"
nofsck="yes"
add_dracutmodules+=" zfs "
```

Reconfigure Linux to update GRUB's and Dracut's configurations:

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
Available DKMS module: zfs-0.8.3.
Building DKMS module: zfs-0.8.3... done.
Executing post-install kernel hook: 20-dracut ...
Executing post-install kernel hook: 50-grub ...
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.4.32_1
Found initrd image: /boot/initramfs-5.4.32_1.img
Found void on /dev/sda2
done
linux5.4: configured successfully.
```

## Sanity Checks

Ensure that the Dracut configuration took with
[lsinitrd(1)](https://man.voidlinux.org/lsinitrd):

> **Note:**
> 
> It may be necessary to specify the path to the img if the kernel version has
> changed, see [lsinitrd(1)](https://man.voidlinux.org/lsinitrd).

```
(chroot)# lsinitrd -m
initrd in UEFI: : 13M
========================================================================
Version: 

dracut modules:
bash
dash
i18n
drm
kernel-modules
kernel-modules-extra
zfs
resume
rootfs-block
terminfo
udev-rules
usrmount
base
fs-lib
shutdown
========================================================================
```

As well check that the ZFS cache is recognized:

```
(chroot)# lsinitrd | grep zpool.cache
-rw-r--r--   1 root     root         1376 Apr 17 01:30 etc/zfs/zpool.cache
```

## Cleanup

Exit chroot:

`(chroot)$ exit`

And un-mount the chroot environment:

```
# umount /mnt/void/dev/pts
# umount /mnt/void/{dev,proc,sys}
# zpool export zroot
```

Restart the system using [reboot(8)](https://man.voidlinux.org/reboot) and log
in:

`# reboot`

## Configuration

Configure the defaults in the new system's `/etc/rc.conf`. Below are some values
that most system's will want to set.

````````
# see loadkeys(8)
KEYMAP="us"
# available timezones at /usr/share/zoneinfo
TIMEZONE="America/Chicago"
# set to UTC or localtime
HARDWARECLOCK="UTC"
````````

Finally configure the system's locales consulting the
[Locales](./../../config/locales.md) page of the handbook.
