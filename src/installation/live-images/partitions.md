# Partitioning notes

Partitioning for a modern Linux distribution is generally very simple, however
the introduction of GPT and UEFI booting does bring new complexity to the
process. When creating your new partition table you will need a partition for
the root filesystem, along with a swap partition and possibly another partition
or two to facilitate booting, if required.

The following sections will detail the options for partition configuration.

## BIOS system notes

It is recommended that you create an MBR partition table if you are using a BIOS
boot system. This will limit the number of partitions you create to four. It is
possible to install a GPT partition table on a BIOS system, but grub will need a
special partition to boot properly.

## UEFI system notes

UEFI users are recommended to create a GPT partition table. UEFI booting with
grub also requires a special partition of the type `EFI System` with a `vfat`
filesystem mounted at `/boot/efi`. A reasonable size for this partition could be
between 200MB and 1GB. With this partition setup during the live image
installation, the installer should successfully set up the bootloader
automatically.

## Swap partitions

A swap partition is not strictly required, but recommended for systems with low
RAM. If you want to use hibernation, you will need a swap partition. The
following table has recommendations for swap partition size.

| System RAM | Recommended swap space | Swap space if using hibernation |
|------------|------------------------|---------------------------------|
| < 2GB      | 2x the amount of RAM   | 3x the amount of RAM            |
| 2-8GB      | Equal to amount of RAM | 2x the amount of RAM            |
| 8-64GB     | At least 4GB           | 1.5x the amount of RAM          |
| 64GB       | At least 4GB           | Hibernation not recommended     |

## Boot partition (optional)

On most modern systems, a separate `/boot` partition is no longer necessary to
boot properly. If you choose to use one, remember that Void does not remove old
kernels after updates by default and each image will take at least 20MB, so plan
accordingly.

## Other partitions

It is fine to install your system with only a large root partition, but you may
create other partitions if you want. One helpful addition could be a separate
partition for your `/home` directory. This way if you need to reinstall Void (or
another distribution) you can save the data and configuration files in your home
directory for your new system.
