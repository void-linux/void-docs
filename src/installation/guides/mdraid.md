# MDRAID

[mdadm(8)](https://man.voidlinux.org/mdadm.8) is used to manage arrays.
Install the package `mdraid`.

This guide is broken down into three steps to accomodate three different
configurations:

1. To set up a raid array that is not mounted on `/` or a critical system
   directory (such as `/boot` or `/usr`), follow only the first step.
2. To set up a raid array that is mounted on `/` with a separate `/boot`
   partition that is not on raid, follow the first and second steps.
3. To set up a raid array that is mounted on `/` without a separate `/boot`
   partition, follow all three steps.

Note: If following steps 2 or 3 while installing Void, be sure to install mdadm
on both the host operating system and the chroot.

## Step 1. Create Arrays

Partition disks that will be used. No more than one partition per disk should be
used per raid array. 

UEFI users creating an array that include `/` and `/boot` should create an EFI
System Partition (ESP) on every disk of exactly the same size. Create a raid
array with the option `--level=1`. Format the array with
[mkfs.vfat(8)](https://man.voidlinux.org/mkfs.fat.8) and make sure it is mounted
as `/boot/efi`.

Create a new mdraid array using `mdadm --create` The raid array is now
accessible as `/dev/md<n>` (*n* is specified in the previous command). Creating
an array requires writing a large amount of data to disk. This is done in the
background, but reading from the device may be unreliable while it is ongoing.
`cat /proc/mdstat` to check status.

Write the active array information to
[mdadm.conf(5)](https://man.voidlinux.org/mdadm.conf.5):

```
# mdadm --detail --scan >> /etc/mdadm.conf
```

Optionally partition `/dev/md<n>`. Partitions are identified as
`/dev/md<n>p{1,2,...}`.

Format as desired. Add corresponding entries to
[fstab(5)](https://man.voidlinux.org/fstab.5). mdraid arrays can be safely
identified as `/dev/md<n>` in fstab as long as the array is configured in
mdadm.conf.  Without mdadm.conf, arrays can still be automatically detected but
do not have stable names. In either case, filesystems can still be identified
by their UUID, as reported by [blkid(8)](https://man.voidlinux.org/blkid.8).

To monitor arrays, enable the `mdadm` service. Further configuration is
necessary to receive mail from the service.

## Step 2. Configure Dracut

Configure dracut to automatically assemble raid arrays in early userspace by
creating a [dracut.conf(5)](https://man.voidlinux.org/dracut.conf.5) file:

```
mdadmconf=yes
kernel_cmdline+=" rd.auto=1 "
```

[Generate a new initramfs](../../config/kernel.md#install-hooks) before the
system is rebooted.

## Step 3. Configure GRUB

[Install GRUB](chroot.md#installing-grub). If `/boot` is moved into a raid
array, this step must be performed even if grub was previously installed.
[Regenerate GRUB's configuration](../../config/kernel.md#install-hooks).

BIOS users should run `grub-install` for every disk in the array.

UEFI users should run `grub-install --removable` while `/boot/efi` is mounted as
the raid array created for the EFI System Partition.

**Warning:** do not let any other operating systems write to this EFI System
Partition unless it is configured as an mdraid array. Operating systems without
mdraid support can safely mount mdraid level-1 arrays read-only.
