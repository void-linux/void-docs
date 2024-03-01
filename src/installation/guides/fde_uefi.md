# Full Disk Encryption - UEFI

**Warning**: Your drive's block device and other information may be different,
so make sure it is correct.

## Partitioning

Boot the right (base/xfce i686/amd64) [Void Linux live image](https://voidlinux.org/download/) and login.

Create 3 physical (gpt) partition on the disk using
[cfdisk](https://man.voidlinux.org/cfdisk). 
Type: "EFI System" (/boot/efi) "Linux server data" (swap) "Linux filesystem" ( / )

The partition layout should look like the following.

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
/dev/sda2  264192   4458495   4194304    2G Linux server data
/dev/sda3 4458496 100663262 100399071 45.9G Linux filesystem
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

```
# cryptsetup luksFormat --type luks1 /dev/sda3
```
After the volume is created, it need to be opened.

```
# cryptsetup luksOpen /dev/sda3 voidlx
```

Once the LUKS container is opened, format that partition.
The example below uses ext4 the Linux default filesystem. Any filesystem [supported by
GRUB](https://www.gnu.org/software/grub/manual/grub/grub.html#Features) should work.

```
# mkfs.ext4 -L voidlinux /dev/mapper/voidlx
# mount /dev/mapper/voidlx /mnt
# mkdir -p /mnt/boot/efi
```
## LUKS keyfile setup

And now to avoid having to enter the password twice on boot, a keyfile will be
configured to automatically unlock the encrypted volumes on boot. First, generate
a random keyfile.

```
# dd bs=1 count=64 if=/dev/urandom of=/mnt/boot/volume.key
```
Change the permissions to protect the generated key.
```
# chmod 0600 /mnt/boot/volume.key
```
Add the keyfile to the possible keys of /dev/sda3
```
# cryptsetup luksAddKey /dev/sda3 /mnt/boot/volume.key
```
```
# mkfs.vfat /dev/sda1
# mount /dev/sda1 /mnt/boot/efi
```

### Encrypted swap /dev/sda2
```
# cryptsetup luksFormat --type luks1 /dev/sda2 --key-file=/mnt/boot/volume.key
# cryptsetup luksOpen /dev/sda2 swap --key-file=/mnt/boot/volume.key
# mkswap -L cryptswap /dev/mapper/swap
```
## System installation

Start the installation process.
```
# void-installer
```
Configure all the settings.
* Filesystems
  
    need special attention.
  
    Change /dev/mapper/voidlx to ext4.  Mount point /
  
     "Do you want to create a filesystem on /dev/mapper/voidlx ?"
  
     ***No***

      Change /dev/sda1 to vfat.  Mount point /boot/efi
  
     "Do you want to create a filesystem on /dev/sda1 ?"
  
     ***No***

  
* Install
  
  The following operations will be executed:
  
   /dev/mapper/voidlx (46G) mounted on / as ext4
  
When it's done, ***possible with ERROR: faild to install GRUB on /dev/sda!*** (that's OK the void-installer don't know about our crypt setup),
we can enter the chroot with
[`xchroot(1)`](https://man.voidlinux.org/xchroot.1) (from `xtools`) and finish
up the configuration. Alternatively, entering the chroot can be [done
manually](../../config/containers-and-vms/chroot.md#manual-method).

```
# xchroot /mnt
```

### Filesystem configuration

First,
find the UUID of the / device.

```
[xchroot /mnt] # blkid -o value -s UUID /dev/sda3
135f3c06-26a0-437f-a05e-287b036440a4
```

The next step is editing `/etc/fstab`. For this example, the file should look like this:

```
# <file system>                                        <dir>     <type>  <options>             <dump>  <pass>
tmpfs                                                  /tmp      tmpfs   defaults,nosuid,nodev 0       0
/dev/mapper/luks-135f3c06-26a0-437f-a05e-287b036440a4  /         ext4    defaults,relatime     0       1
/dev/sda1                                              /boot/efi vfat    defaults              0       0
/dev/mapper/swap                                       none      swap    defaults              0       0
```

### GRUB configuration

Next, configure GRUB to be able to unlock the filesystem. Add the following line
to `/etc/default/grub`:

```
GRUB_ENABLE_CRYPTODISK=y
```

Next, the kernel needs to be configured to find the encrypted device.
Edit the `GRUB_CMDLINE_LINUX_DEFAULT=` line 
and the `GRUB_CMDLINE_LINUX=` line 
in `/etc/default/grub` and add/change
```
GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=UUID=135f3c06-26a0-437f-a05e-287b036440a4:voidlx cryptkey=rootfs:/boot/volume.key rd.luks.key=/boot/volume.key:/ rw"
```
```
GRUB_CMDLINE_LINUX="rd.auto=1"
```
to it. Make sure the UUID matches the one for the `sda2` device found in the output of the
[blkid(8)](https://man.voidlinux.org/blkid.8) command above.
No "root=..." nessecary. Grub takes care about this.
This is working with both initrd systems: dracut and mkinitcpio with no change.

Change `/etc/crypttab`
```
# crypttab: mappings for encrypted partitions
#
# <name>       <device>         <password>              <options>
swap            /dev/sda2       /boot/volume.key        luks
```
The keyfile and crypttab need to be included in the initramfs. Create
a new file at `/etc/dracut.conf.d/10-crypt.conf` with the following line:

```
install_items+=" /boot/volume.key /etc/crypttab "
```
## Complete system installation

Next, install the boot loader to the disk.

```
[xchroot /mnt] # grub-install /dev/sda
```

Ensure a fresh initramfs is generated with all our changes and additions:

```
[xchroot /mnt] # xbps-reconfigure -fa
```

Exit the `chroot`, unmount the filesystems, and reboot the system.

```
[xchroot /mnt] # exit
# umount -R /mnt
# reboot
```
