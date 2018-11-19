# Installation Guide (chroot)

## Pre-installation

### Set the keyboard layout

The default console keymap is US. Available layouts can be listed with:

```
$ ls /usr/share/kbd/keymaps/*/*/*.map.gz | less
```

To modify the layout, append a corresponding file name to
[`loadkeys(1)`](https://man.voidlinux.org/loadkeys), omitting path and file
extension. For example, to set the Dvorak keyboard layout:

```
# loadkeys dvorak
```

### Verify the boot mode

Many new motherboards will support booting in UEFI mode, but some will not,
instead booting in legacy BIOS mode. You will need to know in which mode
your system will boot when it is time to
[partition the disks](#partition-disks).

If you have boot via UEFI mode, the directory `/sys/firmware/efi` should
exist and be populated.

```
$ ls /sys/firmware/efi
```

If you know your system supports booting into UEFI mode, but does not appear to
have done so, check your UEFI/BIOS settings (can usually be accessed by pressing
a key like `F12` early in the boot process. Look for settings like *UEFI-mode*
or *Disable Legacy BIOS mode*.

### Connect to the Internet

The following steps are a high-level overview for connecting to a wireless
network. For more information, you should consult the
[Network](./config/network/index.md) page.

Check the available network interfaces and take note of the interface name. In
this case, it is `wlan0`.

```
$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
	link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
	link/ether 1c:4d:70:e0:5d:a3 brd ff:ff:ff:ff:ff:ff
```

Enable the network interface:

```
# ip link set <interface> up
```

Start the DHCP server:

```
# dhcpcd <interface>
```

Use [`wpa_passphrase(8)`](https://man.voidlinux.org/wpa_passphrase.8) to create
a network configuration, and append it's output to the file
`/etc/wpa_supplicant.conf`. See
[`wpa_supplicant.conf(5)`](https://man.voidlinux.org/wpa_supplicant.conf.5) for
more options.

```
# wpa_passphrase "SSID" "passphrase" >> /etc/wpa_supplicant.conf
```

Start [`wpa_supplicant(8)](https://man.voidlinux.org/wpa_supplicant.8):

```
# wpa_supplicant -B -i <interface>
```

Verify that you are connected to the internet:

```
ping voidlinux.org
```

Note that you can terminate a running command by sending a `SIGINT` signal with
`ctrl-c`.

### <a name="partition-disks"></a>Partition the disks

This guide will cover a simple example in which we'll format the entire disk.
You should be very cautious in this section, you will **destroy all data** from
your disk. Read and understand every step *before* executing any commands.

You have two main options when it comes to choosing a partition table:

- Master Boot Record (MBR)
- GUID Partition Table (GPT)

If you have determined that you have a UEFI-capable motherboard, and have
booted accordingly, into *UEFI mode*, you should generally opt to write a GPT
to your disk. Otherwise, if you are using a system that does not support booting
UEFI mode you should write a MBR to your disk.

This guide will assume a UEFI-based system, and will follow suit in creating a
GPT to hold our partitions. For more information, see the
[Arch Linux wiki](https://wiki.archlinux.org/index.php/Partitioning).

You will also have to decide on partition sizes and mountpoints for your
new system. This guide will follow a simple example with four partitions:

- an 8 GB `swap` partition
- a 500 MB partition mounted to `/boot/efi`
- a 20 GB partition mounted to `/`
- a 40 GB partition mounted to `/home`

The `util-linux` package comes with three utilities to display or manipulate
disk partition tables:

- [`fdisk(8)`](https://man.voidlinux.org/fdisk.8) is dialog-driven. It is powerful, however can be cumbersome for new users.
- [`sfdisk(8)`](https://man.voidlinux.org/sfdisk.8) is script-based. It is useful for integrating with scripts as all the options are available as command-line flags.
- [`cfdisk(8)`](https://man.voidlinux.org/cfdisk.8) is curses-based. It does not have as many options as [`fdisk(8)`](https://man.voidlinux.org/fdisk.8) or [`sfdisk(8)`](https://man.voidlinux.org/sfdisk.8), such as lacking the capability to wipe the old partition table, but this can be overcome by using the [`wipefs(8)`](https://man.voidlinux.org/wipefs.8) utility, also provided by `util-linux`.
First, we'll wipe all filesystem, raid or partition-table signatures from the
device:

```
# wipefs --all /dev/sda
```

Then, use any of the utilities listed above to create the partitions. Remember
to set the correct partition *type*.

```
# cfdisk /dev/sda
```

Verify the partition scheme with [`fdisk(8)`](https://man.voidlinux.org/fdisk.8)
or [`lsblk(8)`](https://man.voidlinux.org/lsblk.8).

```
$ lsblk
NAME   MAJ:MIN RM    SIZE RO TYPE MOUNTPOINT
sda      8:0    1  238.5G  0 disk
├─sda1   8:1    1      8G  0 part
├─sda2   8:1    1    500M  0 part
├─sda3   8:1    1     20G  0 part
└─sda4   8:1    1     40G  0 part
```

### Format the partitions

Create and enable the swap space.

```
# mkswap /dev/sda1
Setting up swapspace version 1, size = 8 GiB (8589930496 bytes)
no label, UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
# swapon /dev/sda1
```

The EFI System partition should be formatted as FAT32.

```
# mkfs.vfat -F 32 /dev/sda2
```

The partitions that will be mounted as `/` and `/home` will be formatted as
`ext4`, but you may choose a different filesystem. If you're unsure, or don't
know what this means, it's recommended to choose ext4.

```
# mkfs.ext4 /dev/sd3
# mkfs.ext4 /dev/sd4
```

### Mount the file systems

First, mount the root partition to `/mnt`:

```
# mount /dev/sda3 /mnt
```

Then, create directories at the root of the partition for each mountpoint.

```
# mkdir --parents /mnt/boot/efi
# mkdir /mnt/home
```

Mount the remaining partitions, accordingly.

```
# mount /dev/sda2 /mnt/boot/efi
# mount /dev/sda4 /mnt/home
```

Verify all the partitions have been mounted correctly with
[`lsblk(8)`](https://man.voidlinux.org/lsblk.8).

```
$ lsblk
NAME   MAJ:MIN RM    SIZE RO TYPE MOUNTPOINT
sda      8:0    1  238.5G  0 disk
├─sda1   8:1    1      8G  0 part [SWAP]
├─sda2   8:1    1    500M  0 part /mnt/boot/efi
├─sda3   8:1    1     20G  0 part /mnt
└─sda4   8:1    1     40G  0 part /mnt/home
```

## Installation

Now, it's time to install the base system! If you'd like to perform an
installation of an architecture different to the one you are running on right
now, you must export the `XBPS_ARCH` environment variable accordingy, for
example if you booted via *glibc* media and want to install a *musl-libc* system
or vice-versa.

To install a *musl-libc* system:

```
export XBPS_ARCH=x86_64-musl
```

To install a *glibc* system:

```
export XBPS_ARCH=x86_64
```

Then, install the `base-system` package group as well as `grub-x86_64-efi` for
UEFI systems or `grub` otherwise. You may also choose not to install a
bootloader at this time.

```
# xbps-install -S -R https://repo.voidlinux.eu/current -r /mnt base-system grub-x86_64-efi
```

The flags in the above command have the following meanings, from
[xbps-install(1)](https://man.voidlinux.org/xbps-install):

- `-S`: Synchronize remote repository index files.
- `-R`: Enable repository mode. This mode explicitly looks in repositories,ther than looking in the target root directory.
- `-r <dir>`: Specifies a full path for the target root directory.

## Chroot

Now, mount the remaining necessary filesystems so that `/proc`, `/dev`, and
`/sys` are available after changing the apparent root.

```
# mount -t proc proc /mnt/proc
# mount -t sysfs sys /mnt/sys
# mount -o bind /dev /mnt/dev
# mount -t devpts pts /mnt/dev/pts
```

Copy the `/etc/resolv.conf` file to the new system, so that DNS addresses can be
resolved.

```
# cp -L /etc/resolv.conf /mnt/etc/
```

Finally, change root into the new system, and source the new shell profile. You
can also change the prompt temporarily to remind yourself  while you're inside
the chroot jail.

```
# chroot /mnt /bin/bash
# . /etc/profile
# export PS1="(chroot) \w \\$ "
```

## Configure the system

### Root user

Create a password for the root user, and set the correct permissions.

```
# passwd root
# chown root:root /
# chmod 755 /
```

### Fstab

Add a line in `/etc/fstab` for each partition that should be mounted at boot
time, as well as the `swap` partition to be enabled. For mount options,
`defaults` and `noatime` are safe to enable. If you use a Solid State Drive,
you can also enable the `discard` option for continuous TRIM and will help with
sustained long-term performance and wear-leveling. See
[`fstab(5)`](https://man.voidlinux.org/fstab.5) for more information on this
file and what options are available.

```
#
# See fstab(5).
#
# <file system> <dir>      <type> <options>                 <dump>  <pass>
tmpfs           /tmp       tmpfs  defaults,nosuid,nodev     0       0
/dev/sda1       swap       swap   defaults,noatime,discard  0       0
/dev/sda2       /boot/efi  vfat   defaults,noatime,discard  0       2
/dev/sda3       /          ext4   defaults,noatime,discard  0       1
/dev/sda4       /home      ext4   defaults,noatime,discard  0       2
```

### Hostname

Set a hostname to identify your machine on the network. See
[`hostname(1)`](https://man.voidlinux.org/hostname.1) and
[`hostname(7)`](https://man.voidlinux.org/man7/hostname.7) for more information.

```
# echo <hostname> > /etc/hostname
```

### rc.conf

Edit the `/etc/rc.conf` file. Here you should uncomment and set the
`HARDWARECLOCK`, `TIMEZONE`, and `KEYMAP` variables. Some other options can be
set here as well.

```
# Set RTC to UTC or localtime.
HARDWARECLOCK="UTC"

# Set timezone, availables timezones at /usr/share/zoneinfo.
TIMEZONE="America/Los_Angeles"

# Keymap to load, see loadkeys(8).
KEYMAP="dvorak"
```

### Localization

If using the *glibc* variant, you must set the locale. This step should be
skipped if using the *musl-libc* variant.

Edit the `/etc/default/libc-locales` file and uncomment the `en_US.UTF-8` locale
and any other locales that should be made available.

```
...
en_US.UTF-8 UTF-8
en_CA.UTF-8 UTF-8
...
```

Then, force a reconfiguration of the `glibc-locales` package:

```
# xbps-reconfigure --force glibc-locales
```

### Boot loader

Install grub onto the EFI partition:

```
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=void-grub --boot-directory=/boot --recheck
```

## Reboot

Exit the chroot jail.

```
(chroot) / # exit
```

Unmount the /mnt and any other filesystems mounted in subdirectories.

```
# umount --recursive /mnt
```

Reboot the system!

```
# reboot
```