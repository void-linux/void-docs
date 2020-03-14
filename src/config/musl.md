# musl

[musl](https://musl.libc.org/) is a libc implementation which strives to be
lightweight, fast, simple, and correct.

Void officially supports musl by using it in its codebase for all target
platforms (although binary packages are not available for i686). Additionally,
all compatible packages in our official repositories are available with
musl-linked binaries in addition to their glibc counterparts.

Currently, there are nonfree and debug subrepositories for musl, but no multilib
subrepo.

## Incompatible software

Musl practices very strict and minimal standard compliance. Many commonly used
platform-specific extensions are not present. Because of this, it is common for
software to need modification to compile and/or function properly. Void
developers work to patch such software and hopefully get portability/correctness
changes accepted into the upstream projects.

Proprietary software rarely supports non-glibc libc implementations, although
sometimes these applications are available as [flatpaks](https://flatpak.org/),
which provide their own libc in the image.

### glibc chroot

Software requiring glibc can be run in a glibc chroot.

Create a directory that will contain the chroot, and install a base system in it
via the `base-voidstrap` package. If network access is required, copy
`/etc/resolv.conf` into the chroot; `/etc/hosts` may need to be copied as well.

Several directories then need to be mounted as follows:

```
# mount -t proc none <chroot_dir>/proc
# mount -t sysfs none <chroot_dir>/sys
# mount --rbind /dev <chroot_dir>/dev
# mount --rbind /run <chroot_dir>/run
```

Use [chroot(1)](https://man.voidlinux.org/chroot.1) to change to the new root,
then run glibc programs as usual. Once you've finished using it, unmount the
chroot using [umount(8)](https://man.voidlinux.org/umount.8).

#### PRoot

An alternative to the above is [proot(1)](https://man.voidlinux.org/proot.1), a
user-space implementation of chroot, mount --bind, and binfmt_misc. By
installing the `proot` package, unprivileged users can utilise a chroot
environment.
