# Full Disk Encryption

**Warning**: Your drive's block device and other information may be different,
so make sure it is correct.

## Partitioning

Boot a live image and login.

Create a single physical partition on the disk using
[cfdisk](https://man.voidlinux.org/cfdisk), marking it as bootable. For an MBR
system, the partition layout should look like the following.

```
# fdisk -l /dev/sda
Disk /dev/sda: 48 GiB, 51539607552 bytes, 100663296 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4d532059

Device     Boot Start       End   Sectors Size Id Type
/dev/sda1  *     2048 100663295 100661248  48G 83 Linux
```

UEFI systems will need the disk to have a GPT disklabel and an EFI system
partition. The required size for this may vary depending on needs, but 100M
should be enough for most cases. For an EFI system, the partition layout should
look like the following.

```
# fdisk -l /dev/sda
Disk /dev/sda: 48 GiB, 51539607552 bytes, 100663296 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: EE4F2A1A-8E7F-48CA-B3D0-BD7A01F6D8A0

Device      Start       End   Sectors  Size Type
/dev/sda1    2048    264191    262144  128M EFI System
/dev/sda2  264192 100663262 100399071 47.9G Linux filesystem
```

## Encrypted volume configuration

GRUB 2.06 added partial support for LUKS2, however LUKS2 will not work with GRUB
by default. See the [Arch Wiki](https://wiki.archlinux.org/title/GRUB#LUKS2) for
information on using LUKS2 with GRUB. For simplicity, this guide forces the use
of LUKS1.

Keep in mind the encrypted volume will be `/dev/sda2` on EFI systems, since
`/dev/sda1` is taken up by the EFI partition.

```
# cryptsetup luksFormat --type luks1 /dev/sda1

WARNING!
========
This will overwrite data on /dev/sda1 irrevocably.

Are you sure? (Type uppercase yes): YES
Enter passphrase:
Verify passphrase:
```

Once the volume is created, it needs to be opened. Replace `voidvm` with an
appropriate name. Again, this will be `/dev/sda2` on EFI systems.

```
# cryptsetup luksOpen /dev/sda1 voidvm
Enter passphrase for /dev/sda1:
```

Once the LUKS container is opened, create the LVM volume group using that
partition.

```
# vgcreate voidvm /dev/mapper/voidvm
  Volume group "voidvm" successfully created
```

There should now be an empty volume group named `voidvm`.

Next, logical volumes need to be created for the volume group. For this example,
I chose 10G for `/`, 2G for `swap`, and will assign the rest to `/home`.

```
# lvcreate --name root -L 10G voidvm
  Logical volume "root" created.
# lvcreate --name swap -L 2G voidvm
  Logical volume "swap" created.
# lvcreate --name home -l 100%FREE voidvm
  Logical volume "home" created.
```

Next, create the filesystems. The example below uses XFS as a personal
preference of the author. Any filesystem [supported by
GRUB](https://www.gnu.org/software/grub/manual/grub/grub.html#Features) will
work.

```
# mkfs.xfs -L root /dev/voidvm/root
meta-data=/dev/voidvm/root       isize=512    agcount=4, agsize=655360 blks
...
# mkfs.xfs -L home /dev/voidvm/home
meta-data=/dev/voidvm/home       isize=512    agcount=4, agsize=2359040 blks
...
# mkswap /dev/voidvm/swap
Setting up swapspace version 1, size = 2 GiB (2147479552 bytes)
```

## System installation

Next, setup the chroot and install the base system.

```
# mount /dev/voidvm/root /mnt
# for dir in dev proc sys run; do mkdir -p /mnt/$dir ; mount --rbind /$dir /mnt/$dir ; mount --make-rslave /mnt/$dir ; done
# mkdir -p /mnt/home
# mount /dev/voidvm/home /mnt/home
```

On a UEFI system, the EFI system partition also needs to be mounted.

```
# mkfs.vfat /dev/sda1
# mkdir -p /mnt/boot/efi
# mount /dev/sda1 /mnt/boot/efi
```

Before we enter the chroot to finish up configuration, we do the actual install.
Do not forget to use the [appropriate repository
URL](../../xbps/repositories/index.md#the-main-repository) for the type of
system you wish to install.

`xbps-install` might ask you to [verify the RSA
keys](../../xbps/troubleshooting/common-issues.md#verifying-rsa-keys) for the
packages you are installing.

```
# xbps-install -Sy -R https://alpha.de.repo.voidlinux.org/current -r /mnt base-system lvm2 cryptsetup grub
[*] Updating `https://alpha.de.repo.voidlinux.org/current/x86_64-repodata' ...
x86_64-repodata: 1661KB [avg rate: 2257KB/s]
`https://alpha.de.repo.voidlinux.org/current' repository has been RSA signed by "Void Linux"
Fingerprint: 60:ae:0c:d6:f0:95:17:80:bc:93:46:7a:89:af:a3:2d
Do you want to import this public key? [Y/n] y
130 packages will be downloaded:
...
```

UEFI systems will have a slightly different package selection. The installation
command for a UEFI system will be as follows.

```
# xbps-install -Sy -R https://alpha.de.repo.voidlinux.org/current -r /mnt base-system cryptsetup grub-x86_64-efi lvm2
```

When it's done, we can enter the `chroot` and finish up the configuration.

```
# chroot /mnt
# chown root:root /
# chmod 755 /
# passwd root
# echo voidvm > /etc/hostname
# echo "LANG=en_US.UTF-8" > /etc/locale.conf
# echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
# xbps-reconfigure -f glibc-locales
```

### Filesystem configuration

The next step is editing `/etc/fstab`, which will depend on how you configured
and named your filesystems. For this example, the file should look like this:

```
# <file system>	   <dir> <type>  <options>             <dump>  <pass>
tmpfs             /tmp  tmpfs   defaults,nosuid,nodev 0       0
/dev/voidvm/root  /     xfs     defaults              0       0
/dev/voidvm/home  /home xfs     defaults              0       0
/dev/voidvm/swap  swap  swap    defaults              0       0
```

UEFI systems will also have an entry for the EFI system partition.

```
/dev/sda1	/boot/efi	vfat	defaults	0	0
```

### GRUB configuration

Next, configure GRUB to be able to unlock the filesystem. Add the following line
to `/etc/default/grub`:

```
GRUB_ENABLE_CRYPTODISK=y
```

Next, the kernel needs to be configured to find the encrypted device. First,
find the UUID of the device.

```
# blkid -o value -s UUID /dev/sda1
135f3c06-26a0-437f-a05e-287b036440a4
```

Edit the `GRUB_CMDLINE_LINUX_DEFAULT=` line in `/etc/default/grub` and add
`rd.lvm.vg=voidvm rd.luks.uuid=<UUID>` to it. Make sure the UUID matches the one
for the `sda1` device found in the output of the
[blkid(8)](https://man.voidlinux.org/blkid.8) command above.

## LUKS key setup

And now to avoid having to enter the password twice on boot, a key will be
configured to automatically unlock the encrypted volume on boot. First, generate
a random key.

```
# dd bs=1 count=64 if=/dev/urandom of=/boot/volume.key
64+0 records in
64+0 records out
64 bytes copied, 0.000662757 s, 96.6 kB/s
```

Next, add the key to the encrypted volume.

```
# cryptsetup luksAddKey /dev/sda1 /boot/volume.key
Enter any existing passphrase:
```

Change the permissions to protect generated the key.

```
# chmod 000 /boot/volume.key
# chmod -R g-rwx,o-rwx /boot
```

This keyfile also needs to be added to `/etc/crypttab`. Again, this will be
`/dev/sda2` on EFI systems.

```
voidvm   /dev/sda1   /boot/volume.key   luks
```

And then the keyfile and `crypttab` need to be included in the initramfs. Create
a new file at `/etc/dracut.conf.d/10-crypt.conf` with the following line:

```
install_items+=" /boot/volume.key /etc/crypttab "
```

## Complete system installation

Next, install the boot loader to the disk.

```
# grub-install /dev/sda
```

Ensure an initramfs is generated:

```
# xbps-reconfigure -fa
```

Exit the `chroot`, unmount the filesystems, and reboot the system.

```
# exit
# umount -R /mnt
# reboot
```
