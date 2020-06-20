# LVM2

[lvm(8)](https://man.voidlinux.org/lvm.8) is used to manage LVM2 logical
volumes.  Install the package `lvm2`. The same functionality is available as a
number of standalone commands for particular tasks, such as
[vgcreate(8)](https://man.voidlinux.org/vgcreate.8),
[lvcreate(8)](https://man.voidlinux.org/lvcreate.8).

This guide is broken down into three steps to accomodate three different
configurations:

1. To set up logical volumes that are not mounted on `/` or a critical system
   directory (such as `/boot` or `/usr`), follow only the first step.
2. To set up a logical volume that is mounted on `/` with a separate `/boot`
   partition that is not on a logical volume, follow the first and second steps.
3. To set up a logical volume that is mounted on `/` with `/boot` also in a
logical volume

Note: If following steps 2 or 3 while installing Void, be sure to install lvm2
on both the host operating system and the chroot.

## Step 1. Create Volumes

Create volume groups and logical volumes as desired using
[vgcreate(8)](https://man.voidlinux.org/vgcreate.8) and
[lvcreate(8)](https://man.voidlinux.org/lvcreate.8) respectively.

LVM2 volumes are automatically detected and configured, either at boot time or
when the disks are connected. Volumes do not need to be configured in
[lvm.conf(5)](https://man.voidlinux.org/lvm.conf.5). Volumes
are accessible as `/dev/mapper/<volume-group>-<volume-name>`

Format volumes as desired. Add corresponding entries to
[fstab(5)](https://man.voidlinux.org/fstab.5). LVM2 volumes can be safely
identified `/dev/mapper/<group>-<name>` in fstab.

## Step 2. Configure Dracut

Configure dracut to automatically assemble logical volumes in early userspace by
creating a [dracut.conf(5)](https://man.voidlinux.org/dracut.conf.5) file:

```
kernel_cmdline+=" rd.auto=1 "
```

## Step 3. Configure GRUB

[Install GRUB](chroot.md#installing-grub). If `/boot` is moved into a logical
volume, this step must be performed even if grub was previously installed.
[Regenerate GRUB's configuration](../../config/kernel.md#install-hooks).
