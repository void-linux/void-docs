# Installation Guide

Once you have [downloaded](../index.md#downloading-installation-media) a Void
image to install and [prepared](./prep.md) your install media, you are ready to
install Void Linux.

Before you begin installation, you should determine whether your machine boots
using BIOS or UEFI. This will affect how you plan partitions. See [Partitioning
Notes](./partitions.md) for more detail.

The following features are not supported by the installer script:

- [LVM](https://en.wikipedia.org/wiki/Logical_volume_management)
- [LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup)
- [ZFS](https://en.wikipedia.org/wiki/ZFS)

## Booting

Boot your machine from the install media you created. If you have enough RAM,
there is an option on the boot screen to load the entire image into ram, which
will take some time but speed up the rest of the install process.

Once the live image has booted, log in as `root` with password `voidlinux` and
run:

```
# void-installer
```

The following sections will detail each screen of the installer.

## Keyboard

Select the keymap for your keyboard; standard "qwerty" keyboards will generally
use the "us" keymap.

## Network

Select your primary network interface. If you do not choose to use DHCP, you
will be prompted to provide an IP address, gateway, and DNS servers.

If you intend to use a wireless connection during the installation, you may need
to configure it manually using wpa_supplicant and dhcpcd manually before running
`void-installer`.

## Source

To install packages provided on the install image, select `Local`. Otherwise,
you may select `Network` to download the latest packages from the Void
repository.

**Warning!**: If you are installing a desktop environment from a ''flavor''
image, you MUST choose `Local` for the source!

## Hostname

Select a hostname for your computer (that is all lowercase, with no spaces.)

## Locale

Select your default locale settings. This option is for glibc only, as musl does
not currently support locales.

## Timezone

Select your timezone based on standard timezone options.

## Root password

Enter and confirm your `root` password for the new installation. The password
will not be shown on screen.

## User account

Choose a login (default `void`) and a descriptive name for that login. Then
enter and confirm the password for the new user. You will then be prompted to
verify the groups for this new user. They are added to the `wheel` group by
default and will have `sudo` access. Default groups and their respective meaning
are described [here](../../config/users-and-groups.html#default-groups).

## Bootloader

Select the disk to install a bootloader on when Void is installed. You may
select `none` to skip this step and install a bootloader manually after
completing the installation process. If installing a bootloader, you will also
be asked whether or not you want a graphical terminal for the GRUB menu.

## Partition

Next, you will need to partition your disks. Void does not provide a preset
partition scheme, so you will need to create your partitions manually with
[cfdisk(8)](https://man.voidlinux.org/cfdisk.8). You will be prompted with a
list of disks. Select the disk you want to partition and the installer will
launch `cfdisk` for that disk. Remember you must write the partition table to
the drive before you exit the partition editor.

If using UEFI, it is recommended you select GPT for the partition table and
create a partition (typically between 200MB-1GB) of type `EFI System`, which
will be mounted at `/boot/efi`.

If using BIOS, it is recommended you select MBR for the partition table.
Advanced users may use GPT but will need to [create a special BIOS
partition](./partitions.md#bios-system-notes) for GRUB to boot.

See the [Partitioning Notes](./partitions.md) for more details about
partitioning your disk.

## Filesystems

Create the filesystems for each partition you have created. For each partition
you will be prompted to choose a filesystem type, whether you want to create a
new filesystem on the partition, and a mount point, if applicable. When you are
finished, select `Done` to return to the main menu.

If using UEFI, create a `vfat` filesystem and mount it at `/boot/efi`.

## Review settings

It is a good idea to review your settings before proceeding. Use the right arrow
key to select the settings button and hit `<enter>`. All your selections will be
shown for review.

## Install

Selecting `Install` from the menu will start the installer. The installer will
create all the filesystems selected, and install the base system packages. It
will then generate an initramfs and install a GRUB2 bootloader to the bootable
partition.

These steps will all run automatically, and after the installation is completed
successfully, you can reboot into your new Void Linux install!

## Post installation

After booting into your Void installation for the first time, [perform a system
update](../../xbps/index.md#updating).
