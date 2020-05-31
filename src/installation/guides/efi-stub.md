# EFI Boot Stub

When the kernel is compiled with the [EFI boot
stub](https://www.kernel.org/doc/Documentation/efi-stub.txt) like the one
packaged in Void, UEFI firmware can load the kernel directly as an EFI
executable, eliminating the need for a bootloader.

In the following, we set up a simple Void system on a drive, with an encrypted
root partition and an unencrypted EFI system partition. We will refer to the
drive as `/dev/sd<X>`.

## Provisioning

On the drive, create a GPT partition table with the following partitions:

| No. | Size              | Type             |
|-----|-------------------|------------------|
| 1   | 512MiB            | EFI System       |
| 2   | rest of the drive | Linux filesystem |

Create a FAT 32 filesystem on the EFI System Partition, optionally giving it a
label.

```
# mkfs.fat -F 32 -n efi /dev/sd<X>1
```

Initialize the LUKS device.

```
# cryptsetup luksFormat /dev/sd<X>2 --type luks2 --label luks
```

Open the LUKS device.

```
# cryptsetup open --type luks /dev/sd<X>2 root
```

Create the desired file system.

```
# mkfs.ext4 -L root /dev/mapper/root
```

## Installation

With the LUKS device still open, mount the root filesystem, the EFI system
partition and the necessary directories to `/mnt`.

```
# mount /dev/mapper/root /mnt
# mkdir /mnt/boot
# mount /dev/sd<X>1 /mnt/boot
# for dir in dev proc sys run; do
> mkdir /mnt/$dir
> mount --rbind --make-rslave /$dir /mnt/$dir
> done
```

Install the Void Linux base system, `cryptsetup` and `efibootmgr`.

```
# xbps-install -S -R https://alpha.de.repo.voidlinux.org/current -r /mnt base-system cryptsetup efibootmgr
```

Change the filesystem root to enter the new system.

```
# chroot /mnt
```

Set the filesystem permissions, root password and hostname.

```
# chown root:root /
# chmod 755 /
# passwd root
# echo void > /etc/hostname
```

Void Linux uses [dracut](https://lwn.net/Articles/317793/) to manage early
userspace. Configure it to open and mount the LUKS device and mount the EFI
variables and system partition. To this end, edit `/etc/crypttab`.

```
# <name>    <device>                  <password>  <options>
root        /dev/disk/by-uuid/<UUID>  none
```

The UUID of `/dev/sd<X>2` can be determined with `lsblk -f`. We'd like to write
`/dev/disk/by-label/luks` instead, but it seems udev doesn't support LUKS labels
yet. The password field is a path to a file containing the password or `none` to
prompt during boot.

Now, edit `/etc/fstab`.

```
# <file system>	        <dir> <type>  <options>             <dump>  <pass>
tmpfs                   /tmp  tmpfs   defaults,nosuid,nodev 0       0
efivarfs  /sys/firmware/efi/efivars  efivarfs  defaults     0       0
/dev/disk/by-label/root /     ext4    defaults              0       1
/dev/disk/by-label/efi  /boot vfat    defaults              0       2
```

Create `/etc/dracut.conf.d/30.conf` to configure dracut.

```
hostonly="yes"
use_fstab="yes"
install_items+=" /etc/crypttab "
add_drivers+=" vfat nls_cp437 nls_iso8859_1 "
```

Create a symbolic link from `/etc/fstab.sys` to `/etc/fstab` to indicate that
dracut should mount all the file systems listed. Then, to omit mounting them
again in runit stage 1, disable the corresponding core service.

```
# mv /etc/runit/core-services/03-filesystems.sh{,.bak}
```

Edit `/etc/xbps.d/xbps.conf` to prevent the service from being added back by an
update to `runit-void`.

```
noextract=/etc/runit/core-services/03-filesystems.sh
```

We are choosing dracut to mount our filesystems because otherwise the
filesystems core service will try to open the encrypted drive a second time.
Another option would be to stop dracut from mounting anything at all.

Edit the configuration for efibootmgr's kernel hook in
`/etc/default/efiboomgr-kernel-hook` for it to add boot entries. Kernel
command-line parameters may be added with `OPTIONS`.

```
MODIFY_EFI_ENTRIES="1"
DISK="/dev/sd<X>"
PART="1"
```

Invoke dracut and efibootmgr by reconfiguring the kernel. You can determine the
installed kernel version by listing the dependencies of the `linux` meta-package
using `xbps-query`.

```
# xbps-reconfigure -f linux<major>.<minor>
```

As needed, modify the boot order using `efibootmgr`. To determine the current
boot order and entries, invoke it without any arguments. To set the bootorder,
use `--bootorder XXXX,XXXX,...`.

Exit the `chroot`, unmount the filesystems and reboot.

```
# exit
# umount -R /mnt
# reboot
```
