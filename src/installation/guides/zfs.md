# Installing Void on a ZFS Root

Because the Void installer does not support ZFS, it is necessary to install via
chroot. Aside from a few caveats regarding bootloader and initramfs support,
installing Void on a ZFS root filesystem is not significantly different from any
other advanced installation. [ZFSBootMenu](https://zfsbootmenu.org) is a
bootloader designed from the ground up to support booting Linux distributions
directly from a ZFS pool. However, it is also possible to use traditional
bootloaders with a ZFS root.

## ZFSBootMenu

Although it will boot (and can be run atop) a wide variety of distributions,
ZFSBootMenu officially considers Void a first-class distribution. ZFSBootMenu
supports native ZFS encryption, offers a convenient recovery environment that
can be used to clone prior snapshots or perform advanced manipulation in a
pre-boot environment, and will support booting from any pool that is importable
by modern ZFS drivers. The [ZFSBootMenu
wiki](https://github.com/zbm-dev/zfsbootmenu/wiki) offers, among other content,
several step-by-step guides for installing a Void system from scratch. The [UEFI
guide](https://github.com/zbm-dev/zfsbootmenu/wiki/Void-Linux---Single-disk-UEFI)
describes the procedure of bootstrapping a Void system for modern systems. For
legacy BIOS systems, the [syslinux
guide](https://github.com/zbm-dev/zfsbootmenu/wiki/Void-Linux----Single-disk-syslinux-MBR)
provides comparable instructions.

## Traditional bootloaders

For those that wish to forego ZFSBootMenu, it is possible to bootstrap a Void
system with another bootloader. To avoid unnecessary complexity, systems that
use bootloaders other than ZFSBootMenu should plan to use a separate `/boot`
that is located on an ext4 or xfs filesystem.

### Installation media

Installing Void to a ZFS root requires an installation medium with ZFS drivers.
It is possible to build a custom image from the official
[void-mklive](https://github.com/void-linux/void-mklive) repository by providing
the command-line option `-p zfs` to the `mklive.sh` script. However, for
`x86_64` systems, it may be more convenient to fetch a pre-built
[hrmpf](https://github.com/leahneukirchen/hrmpf/releases) image. These images,
maintained by a Void team member, are extensions of the standard Void live
images that include pre-compiled ZFS modules in addition to other useful tools.

### Partition disks

After booting a live image with ZFS support, [partition your
disks](../live-images/partitions.md). The considerations in the partitioning
guide apply to ZFS installations as well, except that

- The boot partition should be considered necessary unless you intend to use
   `gummiboot`, which expects that your EFI system partition will be mounted at
   `/boot`. (This alternative configuration will not be discussed here.)
- Aside from any EFI system partition, GRUB BIOS boot partition, swap or boot
   partitions, the remainder of the disk should typically be a single partition
   with type code `BF00` that will be dedicated to a single ZFS pool. There is
   no benefit to creating separate ZFS pools on a single disk.

As needed, format the EFI system partition using
[mkfs.vfat(8)](https://man.voidlinux.org/mkfs.vfat.8) and the the boot partition
using [mke2fs(8)](https://man.voidlinux.org/mke2fs.8) or
[mkfs.xfs(8)](https://man.voidlinux.org/mkfs.xfs.8). Initialize any swap space
using [mkswap(8)](https://man.voidlinux.org).

> It is possible to put Linux swap space on a ZFS zvol, although there may be a
> risk of deadlocking the kernel when under high memory pressure. This guide
> takes no position on the matter of swap space on a zvol. However, if you wish
> to use suspension-to-disk (hibernation), note that the kernel is not capable
> of resuming from memory images stored on a zvol. You will need a dedicated
> swap partition to use hibernation. Apart from this caveat, there are no
> special considerations required to resume a suspended image when using a ZFS
> root.

### Create a ZFS pool

Create a ZFS pool on the partition created for it using
[zpool(8)](https://man.voidlinux.org/zpool.8). For example, to create a pool on
`/dev/disk/by-id/wwn-0x5000c500deadbeef-part3`:

```
# zpool create -f -o ashift=12 \
    -O compression=lz4 \
    -O acltype=posixacl \
    -O xattr=sa \
    -O relatime=on \
    -o autotrim=on \
    -m none zroot /dev/disk/by-id/wwn-0x5000c500deadbeef-part3
```

Adjust the pool (`-o`) and filesystem (`-O`) options as desired, and replace the
partition identifier `wwn-0x5000c500deadbeef-part3` with that of the actual
partition to be used.

> When adding disks or partitions to ZFS pools, it is generally advisable to
> refer to them by the symbolic links created in `/dev/disk/by-id` or (on UEFI
> systems) `/dev/disk/by-partuuid` so that ZFS will identify the right
> partitions even if disk naming should change at some point. Using traditional
> device nodes like `/dev/sda3` may cause intermittent import failures.

Next, export and re-import the pool with a temporary, alternate root path:

```
# zpool export zroot
# zpool import -N -R /mnt zroot
```

### Create initial filesystems

The filesystem layout on your ZFS pool is flexible. However, it is customary to
put operating system root filesystems ("boot environments") under a `ROOT`
parent:

```
# zfs create -o mountpoint=none zroot/ROOT
# zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/void
```

Setting `canmount=noauto` on filesystems with `mountpoint=/` is useful because
it permits the creation of multiple boot environments (which may be clones of a
common Void installation or contain completely separate distributions) without
fear that ZFS auto-mounting will attempt to mount one over another.

To separate user data from the operating system, create a filesystem to store
home directories:

```
# zfs create -o mountpoint=/home zroot/home
```

Other filesystems may be created as desired.

### Mount the ZFS hierarchy

All ZFS filesystems should be mounted under the `/mnt` alternate root
established by the earlier re-import. Mount the manual-only root filesystem
before allowing ZFS to automatically mount everything else:

```
# zfs mount zroot/ROOT/void
# zfs mount -a
```

At this point, the entire ZFS hierarchy should be mounted and ready for
installation. To improve boot-time import speed, it is useful to record the
current pool configuration in a cache file that Void will use to avoid walking
the entire device hierarchy to identify importable pools:

```
# mkdir -p /mnt/etc/zfs
# zpool set cachefile=/mnt/etc/zfs/zpool.cache zroot
```

Mount non-ZFS filesystems at the appropriate places. For example, if `/dev/sda2`
holds an ext4 filesystem that should be mounted at `/boot` and `/dev/sda1` is
the EFI system partition:

```
# mkdir -p /mnt/boot
# mount /dev/sda2 /mnt/boot
# mkdir -p /mnt/boot/efi
# mount /dev/sda1 /mnnt/boot/efi
```

### Installation

At this point, ordinary installation can proceed from the ["Base Installation"
section](https://docs.voidlinux.org/installation/guides/chroot.html#base-installation).
of the standard chroot installation guide. However, before following the
["Finalization"
instructions](https://docs.voidlinux.org/installation/guides/chroot.html#finalization),
make sure that the `zfs` package has been installed and `dracut` is configured
to identify a ZFS root filesystem:

```
(chroot) # mkdir -p /etc/dracut.conf.d
(chroot) # cat > /etc/dracut.conf.d/zol.conf <<EOF
nofsck="yes"
add_dracutmodules+=" zfs "
omit_dracutmodules+=" btrfs resume "
EOF
(chroot) # xbps-install zfs
```

Finally, follow the "Finalization" instructions and reboot into your new system.
