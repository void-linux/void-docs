# Full Disk Encryption

**Warning**: Your drive's block device and other information may be different,
so make sure it is correct.

## Partitioning

Boot a current Void Linux live image and login.

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

[Cryptsetup](https://man.voidlinux.org/cryptsetup.8) defaults to LUKS2, yet GRUB
releases before 2.06 only had support for LUKS1.

LUKS2 is only partially supported by GRUB; specifically, only the PBKDF2 key
derivation function is
[implemented](https://git.savannah.gnu.org/cgit/grub.git/commit/?id=365e0cc3e7e44151c14dd29514c2f870b49f9755),
which is *not* the default KDF used with LUKS2, that being Argon2i ([GRUB Bug
59409](https://savannah.gnu.org/bugs/?59409)). LUKS encrypted partitions using
Argon2i (as well as the other KDF) can *not* be decrypted. For that reason, this
guide only recommends LUKS1 be used.

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

Once the volume is created, it needs to be opened. Again, this will be `/dev/sda2` on EFI systems.

```
# cryptsetup luksOpen /dev/sda1 voidlx
Enter passphrase for /dev/sda1:
```

Once the LUKS container is opened, format that partition.
The example below uses ext4 the Linux default filesystem. Any filesystem [supported by
GRUB](https://www.gnu.org/software/grub/manual/grub/grub.html#Features) will
work.

```
# mkfs.ext4 -L voidlinux /dev/dm-0
# mount /dev/dm-0 /mnt
# dd if=/dev/random of=/mnt/.swapfile bs=1M count=2048 status=progress
# chmod 0600 /mnt/.swapfile
# mkswap -L swapfile /mnt/.swapfile
```

## System installation

Next, setup the chroot and install the base system.

```
# mkdir /mnt/home
# mkdir /mnt/boot

```

On a UEFI system, the EFI system partition also needs to be mounted.

```
# mkfs.vfat /dev/sda1
# mkdir -p /mnt/boot/efi
# mount /dev/sda1 /mnt/boot/efi
```

Copy the RSA keys from the installation medium to the target root directory:

```
# mkdir -p /mnt/var/db/xbps/keys
# cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/
```

Before we enter the chroot to finish up configuration, we do the actual install.
Do not forget to use the [appropriate repository
URL](../../xbps/repositories/index.md#the-main-repository) for the type of
system you wish to install.

```
64 Bit (glibc):
# XBPS_ARCH=x86_64 xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt base-system cryptsetup grub
32 Bit:
# XBPS_ARCH=i686 xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt base-system cryptsetup grub
[*] Updating `https://repo-default.voidlinux.org/current/x86_64-repodata' ...
x86_64-repodata: 1661KB [avg rate: 2257KB/s]
130 packages will be downloaded:
...
```

UEFI systems will have a slightly different package selection. The installation
command for a UEFI system will be as follows.

```
64 Bit (glibc):
# XBPS_ARCH=x86_64 xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt base-system cryptsetup grub-x86_64-efi
32 Bit:
# XBPS_ARCH=i686 xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt base-system cryptsetup grub-efi
```

When it's done, we can enter the chroot with
[`xchroot(1)`](https://man.voidlinux.org/xchroot.1) (from `xtools`) and finish
up the configuration. Alternatively, entering the chroot can be [done
manually](../../config/containers-and-vms/chroot.md#manual-method).

```
# xchroot /mnt
[xchroot /mnt] # chmod 0755 /
[xchroot /mnt] # passwd root
[xchroot /mnt] # echo voidlinux > /etc/hostname
```

and, for glibc systems only:

```
[xchroot /mnt] # echo "LANG=en_US.UTF-8" > /etc/locale.conf
[xchroot /mnt] # echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
[xchroot /mnt] # xbps-reconfigure -f glibc-locales
```

### Filesystem configuration

The next step is editing `/etc/fstab`, which will depend on how you configured
and named your filesystems. For this example, the file should look like this:

```
# <file system>   <dir>     <type>  <options>             <dump>  <pass>
tmpfs              /tmp      tmpfs   defaults,nosuid,nodev 0       0
/dev/dm-0          /         ext4    defaults,relatime     0       1
/.swapfile         swap      swap    defaults              0       0
```

UEFI systems will also have an entry for the EFI system partition.

```
/dev/sda1	         /boot/efi vfat	   defaults	             0	     0
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
[xchroot /mnt] # blkid -o value -s UUID /dev/sda1
135f3c06-26a0-437f-a05e-287b036440a4
```

Edit the `GRUB_CMDLINE_LINUX_DEFAULT=` line and the `GRUB_CMDLINE_LINUX=` line 
in `/etc/default/grub` and add
GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=UUID=135f3c06-26a0-437f-a05e-287b036440a4:voidlx cryptkey=rootfs:/boot/volume.key rd.luks.key=/boot/volume.key:/ rw"
GRUB_CMDLINE_LINUX="rd.auto=1"
 to it. Make sure the UUID matches the one for the `sda1` device found in the output of the
[blkid(8)](https://man.voidlinux.org/blkid.8) command above. This will be
`/dev/sda2` on EFI systems. No "root=..." nessecary. Grub takes care about this.

## LUKS key setup

And now to avoid having to enter the password twice on boot, a key will be
configured to automatically unlock the encrypted volume on boot. First, generate
a random key.

```
[xchroot /mnt] # dd bs=1 count=64 if=/dev/urandom of=/boot/volume.key
64+0 records in
64+0 records out
64 bytes copied, 0.000662757 s, 96.6 kB/s
```

Next, add the key to the encrypted volume.

```
[xchroot /mnt] # cryptsetup luksAddKey /dev/sda1 /boot/volume.key
Enter any existing passphrase:
```

Change the permissions to protect the generated key.

```
[xchroot /mnt] # chmod 000 /boot/volume.key
[xchroot /mnt] # chmod -R g-rwx,o-rwx /boot
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
[xchroot /mnt] # grub-install /dev/sda
```

Ensure an initramfs is generated:

```
[xchroot /mnt] # xbps-reconfigure -fa
```

Exit the `chroot`, unmount the filesystems, and reboot the system.

```
[xchroot /mnt] # exit
# umount -R /mnt
# reboot
```
