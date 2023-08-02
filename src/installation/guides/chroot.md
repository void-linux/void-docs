# Installation via chroot (x86/x86_64/aarch64)

This guide details the process of manually installing Void via a chroot on an
x86, x86_64 or aarch64 architecture. It is assumed that you have a familiarity
with Linux, but not necessarily with installing a Linux system via a chroot.
This guide can be used to create a "typical" setup, using a single partition on
a single SATA/IDE/USB disk. Each step may be modified to create less typical
setups, such as [full disk encryption](./fde.md).

Void provides two options for bootstrapping the new installation. The **XBPS
method** uses the [XBPS Package Manager](../../xbps/index.md) running on a host
operating system to install the base system. The **ROOTFS method** installs the
base system by unpacking a ROOTFS tarball.

The **XBPS method** requires that the host operating system have XBPS installed.
This may be an existing installation of Void, an official [live
image](../live-images/prep.md), or any Linux installation running a [statically
linked XBPS](../../xbps/troubleshooting/static.md).

The **ROOTFS method** requires only a host operating system that can enter a
Linux chroot and that has both [tar(1)](https://man.voidlinux.org/tar.1) and
[xz(1)](https://man.voidlinux.org/xz.1) installed. This method may be preferable
if you wish to install Void using a different Linux distribution.

## Prepare Filesystems

[Partition your disks](../live-images/partitions.md) and format them using
[mke2fs(8)](https://man.voidlinux.org/mke2fs.8),
[mkfs.xfs(8)](https://man.voidlinux.org/mkfs.xfs.8),
[mkfs.btrfs(8)](https://man.voidlinux.org/mkfs.btrfs.8) or whatever tools are
necessary for your filesystem(s) of choice.

[mkfs.vfat(8)](https://man.voidlinux.org/mkfs.vfat.8) is also available to
create FAT32 partitions. However, due to restrictions associated with FAT
filesystems, it should only be used when no other filesystem is suitable (such
as for the EFI System Partition).

[cfdisk(8)](https://man.voidlinux.org/cfdisk.8) and
[fdisk(8)](https://man.voidlinux.org/fdisk.8) are available on the live images
for partitioning, but you may wish to use
[gdisk(8)](https://man.voidlinux.org/gdisk.8) (from the package `gptfdisk`) or
[parted(8)](https://man.voidlinux.org/parted.8) instead.

For a UEFI booting system, make sure to create an EFI System Partition (ESP).
The ESP should have the partition type "EFI System" (code `EF00`) and be
formatted as FAT32 using [mkfs.vfat(8)](https://man.voidlinux.org/mkfs.vfat.8).

If you're unsure what partitions to create, create a 1GB partition of type "EFI
System" (code `EF00`), then create a second partition of type "Linux Filesystem"
(code `8300`) using the remainder of the drive.

Format these partitions as FAT32 and ext4, respectively:

```
# mkfs.vfat /dev/sda1
# mkfs.ext4 /dev/sda2
```

### Create a New Root and Mount Filesystems

This guide will assume the new root filesystem is mounted on `/mnt`. You may
wish to mount it elsewhere.

If using UEFI, mount the EFI System Partition as `/mnt/boot/efi`.

For example, if `/dev/sda2` is to be mounted as `/` and `dev/sda1` is the EFI
System Partition:

```
# mount /dev/sda2 /mnt/
# mkdir -p /mnt/boot/efi/
# mount /dev/sda1 /mnt/boot/efi/
```

Initialize swap space, if desired, using
[mkswap(8)](https://man.voidlinux.org/mkswap.8).

## Base Installation

Follow only one of the two following subsections.

If on aarch64, it will be necessary to install a kernel package in addition to
`base-system`. For example, `linux` is a kernel package that points to the
latest stable kernel packaged by Void.

### The XBPS Method

Select a [mirror](../../xbps/repositories/mirrors/index.md) and **use the**
[**appropriate URL**](../../xbps/repositories/index.md#the-main-repository) for
the type of system you wish to install. For simplicity, save this URL to a shell
variable. A glibc installation, for example, would use:

```
# REPO=https://repo-default.voidlinux.org/current
```

XBPS also needs to know what architecture is being installed. Available options
are `x86_64`, `x86_64-musl`, `i686` for PC architecture computers and `aarch64`.
For example:

```
# ARCH=x86_64
```

This architecture must be compatible with your current operating system, but
does not need to be the same. If your host is running an x86_64 operating
system, any of the three architectures can be installed (whether the host is
musl or glibc), but an i686 host can only install i686 distributions.

Copy the RSA keys from the installation medium to the target root directory:

```
# mkdir -p /mnt/var/db/xbps/keys
# cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/
```

Use [xbps-install(1)](https://man.voidlinux.org/xbps-install.1) to bootstrap the
installation by installing the `base-system` metapackage:

```
# XBPS_ARCH=$ARCH xbps-install -S -r /mnt -R "$REPO" base-system
```

### The ROOTFS Method

[Download a ROOTFS
tarball](https://voidlinux.org/download/#download-installable-base-live-images-and-rootfs-tarballs)
matching your architecture.

Unpack the tarball into the newly configured filesystems:

```
# tar xvf void-<...>-ROOTFS.tar.xz -C /mnt
```

## Configuration

With the exception of the section "Install base-system (ROOTFS method only)",
the remainder of this guide is common to both the XBPS and ROOTFS installation
methods.

### Entering the Chroot

[xchroot(1)](https://man.voidlinux.org/xchroot.1) (from `xtools`) can be used to
set up and enter the chroot. Alternatively, this can be [done
manually](../../config/containers-and-vms/chroot.md#manual-method).

```
# xchroot /mnt /bin/bash
```

### Install base-system (ROOTFS method only)

ROOTFS images generally contain out of date software, due to being a snapshot of
the time when they were built, and do not come with a complete `base-system`.
Update the package manager and install `base-system`:

```
[xchroot /mnt] # xbps-install -Su xbps
[xchroot /mnt] # xbps-install -u
[xchroot /mnt] # xbps-install base-system
[xchroot /mnt] # xbps-remove base-voidstrap
```

### Installation Configuration

Specify the hostname in `/etc/hostname`. Go through the options in
[`/etc/rc.conf`](../../config/rc-files.md#rcconf). If installing a glibc
distribution, edit `/etc/default/libc-locales`, uncommenting desired
[locales](../../config/locales.md).

[nvi(1)](https://man.voidlinux.org/nvi.1) is available in the chroot, but you
may wish to install your preferred text editor at this time.

For glibc builds, generate locale files with:

```
[xchroot /mnt] # xbps-reconfigure -f glibc-locales
```

### Set a Root Password

[Configure at least one super user account](../../config/users-and-groups.md).
Other user accounts can be configured later, but there should either be a root
password, or a new user account with [sudo(8)](https://man.voidlinux.org/sudo.8)
privileges.

To set a root password, run:

```
[xchroot /mnt] # passwd
```

### Configure fstab

The [fstab(5)](https://man.voidlinux.org/fstab.5) file can be automatically
generated from currently mounted filesystems by copying the file `/proc/mounts`:

```
[xchroot /mnt] # cp /proc/mounts /etc/fstab
```

Remove lines in `/etc/fstab` that refer to `proc`, `sys`, `devtmpfs` and `pts`.

Replace references to `/dev/sdXX`, `/dev/nvmeXnYpZ`, etc. with their respective
UUID, which can be found by running
[blkid(8)](https://man.voidlinux.org/blkid.8). Referring to filesystems by their
UUID guarantees they will be found even if they are assigned a different name at
a later time. In some situations, such as booting from USB, this is absolutely
essential. In other situations, disks will always have the same name unless
drives are physically added or removed. Therefore, this step may not be strictly
necessary, but is almost always recommended.

Change the last zero of the entry for `/` to `1`, and the last zero of every
other line to `2`. These values configure the behaviour of
[fsck(8)](https://man.voidlinux.org/fsck.8).

For example, the partition scheme used throughout previous examples yields the
following `fstab`:

```
/dev/sda1       /boot/efi   vfat    rw,relatime,[...]       0 0
/dev/sda2       /           ext4    rw,relatime             0 0
```

The information from `blkid` results in the following `/etc/fstab`:

```
UUID=6914[...]  /boot/efi   vfat    rw,relatime,[...]       0 2
UUID=dc1b[...]  /           ext4    rw,relatime             0 1
```

Note: The output of `/proc/mounts` will have a single space between each field.
The columns are aligned here for readability.

Add an entry to mount `/tmp` in RAM:

```
tmpfs           /tmp        tmpfs   defaults,nosuid,nodev   0 0
```

If using swap space, add an entry for any swap partitions:

```
UUID=1cb4[...]  swap        swap    rw,noatime,discard      0 0
```

### Enable services

Services can be [enabled](../../config/services/index.md#enabling-services)
after booting the new system, but you may need to enable some of them (e.g.:
`dhcpcd`, `sshd`) now in order to access it.

## Installing GRUB

Use
[grub-install](https://www.gnu.org/software/grub/manual/grub/html_node/Installing-GRUB-using-grub_002dinstall.html)
to install GRUB onto your boot disk.

**On a BIOS computer**, install the package `grub`, then run `grub-install
/dev/sdX`, where `/dev/sdX` is the drive (not partition) that you wish to
install GRUB to. For example:

```
[xchroot /mnt] # xbps-install grub
[xchroot /mnt] # grub-install /dev/sda
```

**On a UEFI computer**, install either `grub-x86_64-efi`, `grub-i386-efi` or
`grub-arm64-efi`, depending on your architecture, then run `grub-install`,
optionally specifying a bootloader label (this label may be used by your
computer's firmware when manually selecting a boot device):

```
[xchroot /mnt] # xbps-install grub-x86_64-efi
[xchroot /mnt] # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Void"
```

### Troubleshooting GRUB installation

It may be necessary to mount the `efivarfs` filesystem.

```
[xchroot /mnt] # mount -t efivarfs none /sys/firmware/efi/efivars
```

If EFI variables are still not available, add the option `--no-nvram` to the
`grub-install` command.

#### Installing on removable media or non-compliant UEFI systems

Unfortunately, not all systems have a fully standards compliant UEFI
implementation. In some cases, it is necessary to "trick" the firmware into
booting by using the default fallback location for the bootloader instead of a
custom one. In that case, or if installing onto a removable disk (such as USB),
add the option `--removable` to the `grub-install` command.

Alternatively, use [mkdir(1)](https://man.voidlinux.org/mkdir.1) to create the
`/boot/efi/EFI/boot` directory and copy the installed GRUB executable, usually
located in `/boot/efi/EFI/Void/grubx64.efi` (its location can be found using
[efibootmgr(8)](https://man.voidlinux.org/efibootmgr.8)), into the new folder:

```
[xchroot /mnt] # mkdir -p /boot/efi/EFI/boot
[xchroot /mnt] # cp /boot/efi/EFI/Void/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
```

## Finalization

Use [xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) to
ensure all installed packages are configured properly:

```
[xchroot /mnt] # xbps-reconfigure -fa
```

This will make [dracut(8)](https://man.voidlinux.org/dracut.8) generate an
initramfs, and will make GRUB generate a working configuration.

At this point, the installation is complete. Exit the chroot and reboot your
computer:

```
[xchroot /mnt] # exit
# umount -R /mnt
# shutdown -r now
```

After booting into your Void installation for the first time, [perform a system
update](../../xbps/index.md#updating).
