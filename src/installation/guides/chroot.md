# 通过 chroot 安装（x86 / x86_64 / aarch64）

本指南详述了通过 chroot 在 x86、x86_64 或 aarch64 架构的平台上安装 Void 的过程。您不必很了解用 chroot 安装 Linux 的过程，但您应该对 Linux 操作系统足够熟悉。本指南可以用来指导一个“典型”的 Void 安装过程，使用一块 SATA / IDE / USB 磁盘上的一个分区。每个步骤都可以按需调整，比如开启[全盘加密](./fde.md)，使得安装过程不那么“典型”。

Void 提供两种安装方法：**XBPS 方法**在宿主系统上运行[XBPS 包管理器](../../xbps/index.md)，安装基础系统；**ROOTFS 方法**通过解压 ROOTFS 压缩包来安装基础系统。

**XBPS 方法**要求宿主系统上安装了 XBPS。宿主系统可以是已经安装好的 Void、一个官方 [live 镜像](../live-images/prep.md)或是安装了[静态连接的 XBPS](../../xbps/troubleshooting/static.md)的任何 Linux。

**ROOTFS 方法**只要求宿主系统可以进入 Linux chroot，且安装了 [tar(1)](https://man.voidlinux.org/tar.1) 和 [xz(1)](https://man.voidlinux.org/xz.1)。如果你要从其他发行版上安装 Void，推荐这个方法。

## 准备文件系统

[Partition your disks](../live-images/partitions.md) and format them using
[mke2fs(8)](https://man.voidlinux.org/mke2fs.8),
[mkfs.xfs(8)](https://man.voidlinux.org/mkfs.xfs.8),
[mkfs.btrfs(8)](https://man.voidlinux.org/mkfs.btrfs.8) or whatever tools are
necessary for your filesystem(s) of choice.

给[硬盘分好区](../live-images/partitions.md)，并用 [mke2fs(8)](https://man.voidlinux.org/mke2fs.8)、[mkfs.xfs(8)](https://man.voidlinux.org/mkfs.xfs.8)、[mkfs.btrfs(8)](https://man.voidlinux.org/mkfs.btrfs.8) 或其他文件系统必须的工具将分区格式化。

也可以用 [mkfs.vfat(8)](https://man.voidlinux.org/mkfs.vfat.8) 创建 FAT32 分区。但是由于 FAT 文件系统的种种缺陷，只应该在没有其他选择时创建 FAT 分区（比如 EFI 系统分区）。

Live 镜像上可以使用 [cfdisk(8)](https://man.voidlinux.org/cfdisk.8) 和 [fdisk(8)](https://man.voidlinux.org/fdisk.8) 分区，但你可能会想用 [gdisk(8)](https://man.voidlinux.org/gdisk.8)（在软件包 `gptfdisk` 中）或 [parted(8)](https://man.voidlinux.org/parted.8)。

对于 UEFI 引导系统，一定要创建 EFI 系统分区（ESP）。ESP 的分区类型应该是“EFI System”（代号 `EF00`），用 [mkfs.vfat(8)](https://man.voidlinux.org/mkfs.vfat.8) 格式化为 FAT32 文件系统。

如果你不确定要创建什么分区，创建一个 1GB 的 “EFI System”（代号 `EF00`）分区，再用剩余的空间创建一个“Linux Filesystem”（代号 `8300`）分区。

分别把这两个分区格式化为 FAT32 和 ext4：

```
# mkfs.vfat /dev/sda1
# mkfs.ext4 /dev/sda2
```

###  创建新根分区并挂载文件系统

本指南假设新的根文件系统被挂载到 `/mnt`。你可能会想要将它挂载到其他地方。

如果使用 UEFI，将 EFI 系统分区挂载为 `/mnt/boot/efi`。

例如，如果将 `/dev/sda2` 挂载为 `/`，`/dev/sda1` 是 EFI 系统分区：

```
# mount /dev/sda2 /mnt/
# mkdir -p /mnt/boot/efi/
# mount /dev/sda1 /mnt/boot/efi/
```

用 [mkswap(8)](https://man.voidlinux.org/mkswap.8) 按需初始化交换空间。

## 基础系统安装

请选择两种方法之一，跟随对应小节的指导。

如果在 aarch64 平台上安装，除了 `base-system`，还必须安装一个内核软件包，比如 `linux` 是 Void 提供的最新稳定版本的内核软件包。

### XBPS 方法

选择一个[镜像](../../xbps/repositories/mirrors/index.md)，根据你想要安装的系统类型,**选择[合适的 URL](../../xbps/repositories/index.md#the-main-repository)**。方便起见可以将这个 URL 保存为一个 shell 变量。比如，如果是安装一个 glibc 系统：

```
# REPO=https://repo-default.voidlinux.org/current
```

同时还需要告诉 XBPS 要安装的系统的架构。可用的选项有 PC 上的 `x86_64`、`x86_64-musl`、`i686` 或者 `aarch64`。例如：

```
# ARCH=x86_64
```
这个架构必须与你当前的操作系统兼容，但不需要完全一致。如果你的宿主是 x86_64 操作系统，上述三种架构（无论 musl 还是 glibc）都可以安装，但 i686 宿主只能安装 i686 版本。

将 RSA 密钥从安装介质复制到要安装系统的目录。

```
# mkdir -p /mnt/var/db/xbps/keys
# cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/
```


用 [xbps-install](https://man.voidlinux.org/xbps-install.1) 安装 `base-system` 元软件包

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

Mount the pseudo-filesystems needed for a chroot:

```
# mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
# mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
# mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc
```

Copy the DNS configuration into the new root so that XBPS can still download new
packages inside the chroot:

```
# cp /etc/resolv.conf /mnt/etc/
```

Chroot into the new installation:

```
# PS1='(chroot) # ' chroot /mnt/ /bin/bash
```

### Install base-system (ROOTFS method only)

ROOTFS images generally contain out of date software, due to being a snapshot of
the time when they were built, and do not come with a complete `base-system`.
Update the package manager and install `base-system`:

```
# xbps-install -Su xbps
# xbps-install -u
# xbps-install base-system
# xbps-remove base-voidstrap
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
(chroot) # xbps-reconfigure -f glibc-locales
```

### Set a Root Password

[Configure at least one super user account](../../config/users-and-groups.md).
Other user accounts can be configured later, but there should either be a root
password, or a new user account with [sudo(8)](https://man.voidlinux.org/sudo.8)
privileges.

To set a root password, run:

```
(chroot) # passwd
```

### Configure fstab

The [fstab(5)](https://man.voidlinux.org/fstab.5) file can be automatically
generated from currently mounted filesystems by copying the file `/proc/mounts`:

```
(chroot) # cp /proc/mounts /etc/fstab
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

## Installing GRUB

Use
[grub-install](https://www.gnu.org/software/grub/manual/grub/html_node/Installing-GRUB-using-grub_002dinstall.html)
to install GRUB onto your boot disk.

**On a BIOS computer**, install the package `grub`, then run `grub-install
/dev/sdX`, where `/dev/sdX` is the drive (not partition) that you wish to
install GRUB to. For example:

```
(chroot) # xbps-install grub
(chroot) # grub-install /dev/sda
```

**On a UEFI computer**, install either `grub-x86_64-efi`, `grub-i386-efi` or
`grub-arm64-efi`, depending on your architecture, then run `grub-install`,
optionally specifying a bootloader label (this label may be used by your
computer's firmware when manually selecting a boot device):

```
(chroot) # xbps-install grub-x86_64-efi
(chroot) # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Void"
```

### Troubleshooting GRUB installation

If EFI variables are not available, add the option `--no-nvram` to the
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
(chroot) # mkdir -p /boot/efi/EFI/boot
(chroot) # cp /boot/efi/EFI/Void/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
```

## Finalization

Use [xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) to
ensure all installed packages are configured properly:

```
(chroot) # xbps-reconfigure -fa
```

This will make [dracut(8)](https://man.voidlinux.org/dracut.8) generate an
initramfs, and will make GRUB generate a working configuration.

At this point, the installation is complete. Exit the chroot and reboot your
computer:

```
(chroot) # exit
# shutdown -r now
```

After booting into your Void installation for the first time, [perform a system
update](../../xbps/index.md#updating).
