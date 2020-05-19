# ZFS On Root

This installation guide assumes that an already existing Full Void Linux install
is available. Not just a Live USB.

If an existing Void install does not exist please consult one of the [other
installation guides](./index.md) or use a custom iso such as
[hrmpf](https://github.com/leahneukirchen/hrmpf) then continue along with this
guide.

## Setup

From the permanent system, install the `zfs` package.

Then ensure the ZFS module is loaded with
[modprobe(1)](https://man.voidlinux.org/modprobe):

`# modprobe zfs`

Locate the disk to format using [fdisk(8)](https://man.voidlinux.org/fdisk) or
[lsblk(8)](https://man.voidlinux.org/lsblk):

`# fdisk -l`

## Partitioning

Prepare the drive for installation by creating one of the following partition
schemes using [cfdisk(8)](https://man.voidlinux.org/cfdisk) or another
partitioning tool:

`# cfdisk -z /dev/sda`

> **Warning:**
> 
> The disk being partitioned will be formatted and any existing data on the disk
> will be destroyed.

For a BIOS/MBR system:

```
Partition    Size       Type
1             ?G     Solaris Root(bf00)
```

For a BIOS/GPT system:

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

Create a pool specifying the previously created Solaris Root Partition from the
disk:

> **Note:**
> 
> Many users with Advanced Format hard drives will want to also add the `-o
> ahisft=12` argument. This sets the drive's logical sectors to 4k in size.

`# zpool create -f -m none zroot dev`

| Command | Action                                            |
|---------|---------------------------------------------------|
| -f      | Force the creation of the pool                    |
| -m none | Set the mountpoint to none                        |
| zroot   | The name of the pool                              |
| dev     | The device to be used in the creation of the pool |
|         | (ie. ata-XXXXX-partX or wwn-XXXX-partX)           |

To ensure the pool's creation was successful use:

```
$ zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
zroot   928G   432K   928G        -         -     0%     0%  1.00x    ONLINE  -
```

> **Optional:**
> 
> Add compression to the pool using lz4 or another alogorithm, see
> [zfs(8)](https://man.voidlinux.org/zfs#Native_Properties).
> 
> `# zfs set compression lz4 zroot`

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

> **Important:**
> 

Following the chroot guide, install `grub` and `zfs` from the new system which
will build the requirements necessary to boot.

`(chroot)# xbps-install -S -R $REPO grub zfs`

## GRUB Installation

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

Setup the ZFS cachefile, to ensure the new machine recognizes the previously
created pool properly.

`(chroot)# zpool set cachefile=/etc/zfs/zpool.cache zroot`

Then notate the bootable system for GRUB's autoconfig:

`(chroot)# zpool set bootfs=zroot/ROOT/void zroot`

Finally ensure GRUB recognizes the ZFS module before being installed.

> **Note:**
> 
> When using id's the ZPOOL_VDEV_NAME_PATH variable must be set to 1.

```
(chroot)# ZPOOL_VDEV_NAME_PATH=1 grub-probe /
zfs
```

Install GRUB onto the drive specifying the path:

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
