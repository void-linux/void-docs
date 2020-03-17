# Solid State Drives

Post installation, you will need to enable TRIM for solid state drives. You can
check which devices allow TRIM by running:

```
$ lsblk --discard
```

If the DISC-GRAN (discard granularity) and DISC-MAX (discard maximum bytes)
columns are non-zero, that means the block device has TRIM support. If your
solid state drive partition does not show TRIM support, please verify that you
chose a file system with TRIM support (ext4, Btrfs, F2FS, etc.). Note that F2FS
requires kernel 4.19 or above to support TRIM.

To run TRIM one-shot, you can run
[`fstrim(8)`](https://man.voidlinux.org/fstrim.8) manually. For example, if your
/ directory is on an SSD:

```
# fstrim /
```

To automate running TRIM, use cron or add the `discard` option to `/etc/fstab`.

## Periodic TRIM with cron

Add the following lines to `/etc/cron.daily/fstrim`:

```
#!/bin/sh

fstrim /
```

Finally, make the script executable:

```
# chmod u+x /etc/cron.daily/fstrim
```

## Continuous TRIM with fstab discard

Note: You can use either continuous or periodic TRIM, but usage of continuous
TRIM is discouraged if you have an SSD that doesn't handle NCQ correctly. Refer
to the
[blacklist](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/ata/libata-core.c#n4522).

Edit `/etc/fstab` and add the `discard` option to block devices that need TRIM.

For example, if `/dev/sda1` was an SSD partition, formatted as ext4, and mounted
at `/`:

```
/dev/sda1  /           ext4  defaults,discard   0  1
```

## LVM

To enable TRIM for LVM's commands (`lvremove`, `lvreduce`, etc.), open
`/etc/lvm/lvm.conf`, uncomment the `issue_discards` option, and set it to `1`:

```
issue_discards=1
```

## LUKS

**Warning**: Before enabling discard for your LUKS partition, please be aware of
the [security
implications](https://wiki.archlinux.org/index.php/Dm-crypt/Specialties#Discard/TRIM_support_for_solid_state_drives_(SSD)).

To open an encrypted LUKS device and allow discards to pass through, open the
device with the `--allow-discards` option:

```
# cryptsetup luksOpen --allow-discards /dev/sdaX luks
```

### Non-root devices

Edit `/etc/crypttab` and set the `discard` option for devices on the SSD. For
example, if you have a LUKS device with the name `externaldrive1`, device
`/dev/sdb2`, and password `none`:

```
externaldrive1  /dev/sdb2   none    luks,discard
```

### Root devices

If your root device is on LUKS, add `rd.luks.allow-discards` to
`CMDLINE_LINUX_DEFAULT`. In the case of GRUB, edit `/etc/default/grub`:

```
GRUB_CMDLINE_LINUX_DEFAULT="rd.luks.allow-discards"
```

### Verifying configuration

To verify that you have configured TRIM correctly for LUKS, run:

```
# dmsetup table /dev/mapper/crypt_dev --showkeys
```

If this command output contains the string `allow_discards`, you have
successfully enabled TRIM on your LUKS device.

## ZFS

Before running `trim` on a ZFS pool, ensure that all devices in the pool support
it:

```
# zpool get all | grep trim
```

If the pool allows `autotrim` (set `off` by default), you can `trim` the pool
periodically or automatically. To one-shot `trim` `yourpoolname`:

```
# zpool trim yourpoolname
```

### Periodic TRIM

Add the following lines to `/etc/cron.daily/ztrim`:

```
#!/bin/sh
zpool trim yourpoolname
```

Finally, make the script executable:

```
# chmod u+x /etc/cron.daily/ztrim
```

### Autotrim

To set autotrim for `yourpoolname`, run:

```
# zpool set autotrim=on yourpoolname
```
