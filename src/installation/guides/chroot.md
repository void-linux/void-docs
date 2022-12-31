# 通过 chroot 安装（x86 / x86_64 / aarch64）

本指南详述了通过 chroot 在 x86、x86_64 或 aarch64 架构的平台上安装 Void 的过程。您不必很了解用 chroot 安装 Linux 的过程，但您应该对 Linux 操作系统足够熟悉。本指南可以用来指导一个“典型”的 Void 安装过程，使用一块 SATA / IDE / USB 磁盘上的一个分区。每个步骤都可以按需调整，比如开启[全盘加密](./fde.md)，使得安装过程不那么“典型”。

Void 提供两种安装方法：**XBPS 方法**在宿主系统上运行[XBPS 包管理器](../../xbps/index.md)，安装基础系统；**ROOTFS 方法**通过解压 ROOTFS 压缩包来安装基础系统。

**XBPS 方法**要求宿主系统上安装了 XBPS。宿主系统可以是已经安装好的 Void、一个官方 [live 镜像](../live-images/prep.md)或是安装了[静态连接的 XBPS](../../xbps/troubleshooting/static.md)的任何 Linux。

**ROOTFS 方法**只要求宿主系统可以进入 Linux chroot，且安装了 [tar(1)](https://man.voidlinux.org/tar.1) 和 [xz(1)](https://man.voidlinux.org/xz.1)。如果你要从其他发行版上安装 Void，推荐这个方法。

## 准备文件系统

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

### ROOTFS 方法

根据你要安装的架构，[下载 ROOTFS 压缩包](https://voidlinux.org/download/#download-installable-base-live-images-and-rootfs-tarballs)。

解压压缩包到新设置的文件系统：

```
# tar xvf void-<...>-ROOTFS.tar.xz -C /mnt
```

## 配置

除了《安装基础系统（仅限 ROOTFS 方法）》一节，指南剩余的部分都适用于 XBPS 和 ROOTFS 两种方法。

### 进入 Chroot

挂载 chroot 需要的伪文件系统：

```
# mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
# mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
# mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc
```

为了使 XBPS 在 chroot 中也能下载软件包，拷贝 DNS 配置到新根目录中：

```
# cp /etc/resolv.conf /mnt/etc/
```

Chroot 到新系统中：

```
# PS1='(chroot) # ' chroot /mnt/ /bin/bash
```

### 安装基础系统（仅限 ROOTFS 方法）

因为 ROOTFS 镜像是其构建时的快照，其中的软件包一般都有所滞后，而且不包含完整的 `base-system`，需要更新包管理器并安装 `base-system`：

```
# xbps-install -Su xbps
# xbps-install -u
# xbps-install base-system
# xbps-remove base-voidstrap
```

### 安装配置

[locales](../../config/locales.md).
在 `/etc/hostname` 中指定 hostname。检查一下 [`/etc/rc.conf`]((../../config/rc-files.md#rcconf)) 中的选项。如果安装 glibc 版本，编辑 `/etc/default/libc-locales`，按需取消掉 [locale](../../config/locales.md) 前的注释

[nvi(1)](https://man.voidlinux.org/nvi.1) 在 chroot 中可用，但你此时可能希望安装您喜欢的文本编辑器

对于 glibc 构建，使用以下命令生成语言环境文件： 

```
(chroot) # xbps-reconfigure -f glibc-locales
```

### 设置 Root 密码

[设置至少一个超级用户](../../config/users-and-groups.md))。其他用户可以稍后配置，但必须设置一个 root 密码，或是设置一个有 [sudo(8)](https://man.voidlinux.org/sudo.8) 权限的新账户。

要设置 root 密码，请运行： 

```
(chroot) # passwd
```

### 配置 fstab

可以通过拷贝 `/proc/mounts` 文件，从当前已挂载的文件系统，自动生成 [fstab(5)](https://man.voidlinux.org/fstab.5) 文件：

```
(chroot) # cp /proc/mounts /etc/fstab
```

删掉 `/etc/fstab` 中代表 `proc`、`sys`、`devtmpfs`、`pts` 的行。.

分别用对应的 UUID 代替 `fstab` 中的 `/dev/sdXX`、`/dev/nvmeXnYpZ` 等文件系统名称。UUID 可以通过运行 [blkid(8)](https://man.voidlinux.org/blkid.8) 找到。用 UUID 定位文件系统，可以确保系统能找到文件系统；有时，同一个文件系统可能会被赋予不同的名称，比如从 USB 引导启动时，此时就很有必要用 UUID 定位文件系统。有时，除非物理增加或移除硬盘，硬盘总能被被赋予相同的名字，此时就没有必要使用 UUID 定位文件系统。但我们建议在 `fstab` 中，始终用 UUID 代替文件系统的名称定位文件系统。

配置 [fsck(8)](https://man.voidlinux.org/fsck.8) 的行为，把 `/` 一行末尾的 0 改为 `1`。把其他行末尾的 0 改为 `2`。

比如，之前例子中的分区方案会产生这样的 `fstab`：

```
/dev/sda1       /boot/efi   vfat    rw,relatime,[...]       0 0
/dev/sda2       /           ext4    rw,relatime             0 0
```

用 `blkid` 输出的信息，修改 `/etc/fstab` 为：

```
UUID=6914[...]  /boot/efi   vfat    rw,relatime,[...]       0 2
UUID=dc1b[...]  /           ext4    rw,relatime             0 1
```

注意，`/proc/mounts` 的输出结果每列之间只有一个空格。为了方便阅读，示例中的文本经过对齐处理。

增加一行，在内存中挂载 `/tmp`

```
tmpfs           /tmp        tmpfs   defaults,nosuid,nodev   0 0
```

如果要使用交换空间，增加 swap 分区：

```
UUID=1cb4[...]  swap        swap    rw,noatime,discard      0 0
```

## 安装 GRUB

用 [grub-install](https://www.gnu.org/software/grub/manual/grub/html_node/Installing-GRUB-using-grub_002dinstall.html) 在引导磁盘上安装 GRUB。

**在 BIOS 电脑上**，安装软件包 `grub`。然后运行 `grub-install /dev/sdX`，`/dev/sdX` 是你要安装 GRUB 的硬盘（不是分区），例如：
```
(chroot) # xbps-install grub
(chroot) # grub-install /dev/sda
```

**在 UEFI 电脑上**，根据你的架构,安装 `grub-x86_64-efi` 或 `grub-i386-efi` 或 `grub-arm64-efi`，然后运行 `grub-install`，可以指定一个引导器标签（手动选择引导设备时，你的电脑固件可能会使用这个标签）：

```
(chroot) # xbps-install grub-x86_64-efi
(chroot) # grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id="Void"
```

### GRUB 安装疑难解答

如果不能使用 EFI 变量，执行 `grub-install` 命令时，增加 `--no-nvram` 选项。

#### 在可移除介质上安装或不兼容的 UEFI 系统

并非所有系统都有标准完整的 UEFI 实现。某些情况下，有必要“糊弄”固件，让固件用默认备用地址引导启动。这种情况下，或是在可移除硬盘（比如 USB）上安装系统时，执行 `grub-install` 命令时，增加 `--removable` 选项。

另外，用 [mkdir(1)](https://man.voidlinux.org/mkdir.1) 创建 `/boot/efi/EFI/boot` 目录，将安装好的 GRUB 可执行文件拷贝到新创建的目录中，GRUB 可执行文件一般在 `/boot/efi/void/grubx64.efi`（可执行文件的地址可以用 [efibootmgr(8)](https://man.voidlinux.org/efibootmgr.8) 找到）：

```
(chroot) # mkdir -p /boot/efi/EFI/boot
(chroot) # cp /boot/efi/EFI/Void/grubx64.efi /boot/efi/EFI/boot/bootx64.efi
```
## 善后

用 [xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) 确保所有安装的软件包都正确配置了：

```
(chroot) # xbps-reconfigure -fa
```

这会使 [dracut(8)](https://man.voidlinux.org/dracut.8) 生成 initramfs，使 GRUB 生成配置。

至此，安装已经完成。退出 chroot 并重启电脑：

```
(chroot) # exit
# shutdown -r now
```
首次引导进入 Void 系统后，[更新系统](../../xbps/index.md#updating)。

