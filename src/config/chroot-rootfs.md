# Creating a chroot rootfs

As root, create a directory that will contain the chroot, and install a base
system in it via the `base-voidstrap` package. If network access is required,
copy `/etc/resolv.conf` into the chroot; `/etc/hosts` may need to be copied as
well.

Several directories then need to be mounted as follows:

```
# mount -t proc none <chroot_dir>/proc
# mount -t sysfs none <chroot_dir>/sys
# mount --rbind /dev <chroot_dir>/dev
# mount --rbind /run <chroot_dir>/run
```

Use [chroot(1)](https://man.voidlinux.org/chroot.1) to change to the new root,
then run programs as usual. Once you've finished using it, unmount the chroot
using [umount(8)](https://man.voidlinux.org/umount.8).

## PRoot

An alternative to the above is [proot(1)](https://man.voidlinux.org/proot.1), a
user-space implementation of chroot, mount --bind, and binfmt_misc. By
installing the `proot` package, unprivileged users can utilize a chroot
environment.
