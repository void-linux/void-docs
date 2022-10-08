# Full Disk Encryption

**Warning**: This guide uses `/dev/vda` as the example device name, Your drive's block device and other information may be different, so make sure it is correct.

## Partitioning

Boot a live image and login.

For a BIOS/MBR system, Create a single physical partition on the disk using
[cfdisk](https://man.voidlinux.org/cfdisk) with a `dos` label type, Mark it as bootable.  
Now the partition layout should look similar to the following.

```
# fdisk -l /dev/vda
Disk /dev/vda: 48 GiB, 51539607552 bytes, 100663296 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x4d532059

Device     Boot Start       End   Sectors Size Id Type
/dev/vda1  *     2048 100663295 100661248  48G 83 Linux
```

UEFI systems will need the disk to have a GPT disklabel and an EFI system
partition. The required size for this may vary depending on needs, but 100M
should be enough for most cases. For an EFI system, the partition layout should
look similar to the following.

```
# fdisk -l /dev/vda
Disk /dev/vda: 48 GiB, 51539607552 bytes, 100663296 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: EE4F2A1A-8E7F-48CA-B3D0-BD7A01F6D8A0

Device      Start       End   Sectors  Size Type
/dev/vda1    2048    264191    262144  128M EFI System
/dev/vda2  264192 100663262 100399071 47.9G Linux filesystem
```

## Encrypted volume configuration

[Cryptsetup](https://man.voidlinux.org/cryptsetup.8) defaults to LUKS2, GRUB 
2.06 introduced support for LUKS2, but did not add support for the LUKS2 default 
cryptographic algorithm, [Argon2i](https://en.wikipedia.org/wiki/Argon2). 
Therefore, for compatibility reasons it might make sense to use LUKS1 until GRUB 
receives support for Argon2i.

**Warning**: If the password for the encrypted partition is lost it will become near (or completely) impossible to recover any data or the password

On legacy BIOS systems this command would use `/dev/vda1`.

```
# cryptsetup luksFormat --type luks1 /dev/vda2
```

Once the volume is created, it needs to be opened. `voidvm` is a example name
you can replace it with a name of your choosing. Again, this will be `/dev/vda1` on legacy BIOS systems.

```
# cryptsetup open /dev/vda2 voidvm
```

### LVM

Once the LUKS partition is opened you can create a [LVM](https://en.wikipedia.org/wiki/Logical_Volume_Manager_(Linux)) volume group using that
partition. 
LVM is optional and may have its advantages or disadvantages depending on your system configuration.

The volume group name is not required to be the same as the LUKS partition name chosen above, 
But for consistency purposes it may be easier to use the same name for the volume group.

```
# vgcreate voidvm /dev/mapper/voidvm
```

There should now be an empty volume group named `voidvm`.

Next, logical volumes need to be created for the volume group. 
For this example, All of the available space is assigned to `/`.

The name chosen using `--name` should be noted because it will be used when mounting the partition, For example, `/dev/voidvm/root`.

```
# lvcreate --name root -l 100%FREE voidvm
```

### Filesystem creation

Next, create the filesystems. The example below uses Btrfs. Any filesystem [supported by
GRUB](https://www.gnu.org/software/grub/manual/grub/grub.html#Features) will
work.

On systems using LVM the root filesystem would be created on `/dev/voidvm/root`.

```
# mkfs.btrfs /dev/mapper/voidvm
```

On UEFI systems the EFI partition also needs the filesystem created.

```
# mkfs.vfat -F32 /dev/vda1
```

## System installation

Next, mount the root partition, On a LVM configuration this would be `/dev/voidvm/root`

```
# mount /dev/mapper/voidvm /mnt
```

Next, some extra directories need to be mounted.

```
# for dir in dev proc sys run; do mkdir -p /mnt/$dir ; mount --rbind /$dir /mnt/$dir ; mount --make-rslave /mnt/$dir ; done
```

On a UEFI system, the `/efi` directory needs to be created and EFI system partition needs to be mounted.

```
# mkdir /mnt/efi
# mount /dev/vda1 /mnt/efi
```

Copy the RSA keys from the installation medium to the target root directory:

```
# mkdir -p /mnt/var/db/xbps/keys
# cp /var/db/xbps/keys/* /mnt/var/db/xbps/keys/
```

Before entering the chroot to finish up configuration, it is time to perform the actual install.
Do not forget to use the [appropriate repository URL](../../xbps/repositories/index.md#the-main-repository) 
for the type of system you wish to install.

Legacy BIOS systems use the `grub` package instead of `grub-x86_64-efi`. For LVM users, The `lvm2` package is required.

```
# xbps-install -Sy -R https://repo-default.voidlinux.org/current -r /mnt base-system cryptsetup grub-x86_64-efi
```

Before entering the chroot, Copy a DNS configuration file from live system to allow internet connection in the chroot.

```
# cp /etc/resolv.conf /mnt/etc/
```

Now you can enter the [chroot(1)](https://man.voidlinux.org/chroot.1) and continue configuring the system.

```
# chroot /mnt
# passwd root
# echo AHOSTNAME > /etc/hostname
```

and, for glibc systems only:

```
# echo "LANG=en_US.UTF-8" > /etc/locale.conf
# echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
# xbps-reconfigure -f glibc-locales
```

### Filesystem configuration

Before continuing with filesystem configuration you need to get your [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier)s,
This can be done using utilities such as: [lsblk(8)](https://man.voidlinux.org/lsblk.8) or [blkid(8)](https://man.voidlinux.org/blkid.8).

The next step is editing `/etc/fstab`, 
The UUID needed for `/etc/fstab` is the `/dev/mapper/voidvm` UUID on non-LVM configurations and `/dev/voidvm/root` UUID on LVM configurations

```
# blkid -o value -s UUID /dev/mapper/voidvm
```

```
# <file system>	   <dir> <type>  <options>             <dump>  <pass>
tmpfs             /tmp  tmpfs   defaults,nosuid,nodev 0       0
UUID=ADD-UUID-FROM-BLKID-COMMAND-HERE   /     btrfs   defaults              0       0
```


UEFI systems will also have an entry for the EFI system partition.

```
# blkid -o value -s UUID /dev/vda1
```

```
UUID=ADD-UUID-FROM-BLKID-COMMAND-HERE	/efi	vfat	defaults	0	0
```

### GRUB configuration

Next, configure GRUB to be able to unlock the encrypted filesystem:

```
# echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub
```

Next, the kernel needs to be configured to find the encrypted device. First,
get the UUID of the device, Again this would be `/dev/vda1` on legacy BIOS systems.

```
# blkid -o value -s UUID /dev/vda2
```

Next, Edit the `GRUB_CMDLINE_LINUX_DEFAULT=` line in `/etc/default/grub` and add
`rd.luks.uuid=ADD-UUID-FROM-BLKID-COMMAND-HERE` to it, If you are on a LVM configuration
also add `rd.lvm.vg=voidvm`.

## LUKS key setup

And now to avoid having to enter the password twice on boot, a key will be
configured to automatically unlock the encrypted volume on boot. First, generate
a random key.

```
# dd bs=1 count=64 if=/dev/urandom of=/boot/volume.key
```

Next, add the key to the encrypted volume. Again, this would be `/dev/vda1` on legacy BIOS systems.

```
# cryptsetup luksAddKey /dev/vda2 /boot/volume.key
```

Change the permissions to protect generated the key.

```
# chmod 000 /boot/volume.key
# chmod -R g-rwx,o-rwx /boot
```

This keyfile also needs to be added to `/etc/crypttab`. Again, this would be
`/dev/vda1` on legacy BIOS systems.

```
# blkid -o value -s UUID /dev/vda2
```

```
voidvm   UUID=ADD-UUID-FROM-BLKID-COMMAND-HERE   /boot/volume.key   luks
```

And then the keyfile and `crypttab` need to be included in the initramfs. Create
a new file at `/etc/dracut.conf.d/10-crypt.conf` with the following line:

```
install_items+=" /boot/volume.key /etc/crypttab "
```

## Complete system installation

Next, install the boot loader to the disk.

For legacy BIOS systems:
```
# grub-install --target=i386-pc /dev/vda
```
For UEFI systems:
```
# grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id="Void"
```

Ensure an initramfs is generated:

```
# xbps-reconfigure -fa
```

Exit the `chroot`, unmount the filesystems. 

```
# exit
# umount -R /mnt
```

If you are using a LVM configuration you will need to run the following commands before continuing with the rest of the commands.

```
# lvchange -an voidvm

# cryptsetup close /dev/voidvm/root
```

Finally, Close the encrypted partition and reboot the system.

```
# cryptsetup close /dev/mapper/voidvm
# reboot
```
