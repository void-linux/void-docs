# musl

[musl](https://musl.libc.org/) is a libc implementation which strives to be
lightweight, fast, simple, and correct.

Void officially supports musl by using it in its codebase for all target
platforms (although binary packages are not available for i686). Additionally,
all compatible packages in our official repositories are available with
musl-linked binaries in addition to their glibc counterparts.

Currently, there are nonfree and debug sub-repositories for musl, but no
multilib sub-repo.

## Incompatible software

musl practices very strict and minimal standard compliance. Many commonly used
platform-specific extensions are not present. Because of this, it is common for
software to need modification to compile and/or function properly. Void
developers work to patch such software and hopefully get portability/correctness
changes accepted into the upstream projects.

Proprietary software usually supports only glibc systems, though sometimes such
applications are available as
[flatpaks](../config/external-applications.md#flatpak) and can be run on a musl
system. In particular, the [proprietary NVIDIA
drivers](../config/graphical-session/graphics-drivers/nvidia.md#nvidia-proprietary-driver)
do not support musl, which should be taken into account when evaluating hardware
compatibility.

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

#### Bubblewrap

An alternative for unprivileged users is
[bwrap(1)](https://man.voidlinux.org/bwrap.1), which uses Linux namespaces. It
can be installed via the `bubblewrap` package. An example illustrating how to
use `bwrap` to launch Tor Browser follows.

Create a glibc Void Linux container with the required software:

```
$ mkdir container
$ XBPS_TARGET_ARCH=$(xbps-uhelper arch | sed 's/-musl$//') xbps-install -S -r container -R https://repo-default.voidlinux.org/current/ base-voidstrap torbrowser-launcher libXt dejavu-fonts-ttf
```

(you will have to verify and confirm the repository RSA key before proceeding;
the `dejavu-fonts-ttf` package is required in order for the launcher to display
correctly). Uncomment desired locales in `container/etc/default/libc-locales`
and generate them by issuing:

```
$ bwrap --bind container / --dev /dev --proc /proc --tmpfs /tmp xbps-reconfigure glibc-locales ca-certificates
```

which will also configure the `ca-certificates` package required by Tor Browser.
Launch `torbrowser-launcher`:

```
$ bwrap --bind container / --dev /dev --proc /proc --tmpfs /tmp --ro-bind ~/.Xauthority ~/.Xauthority --ro-bind /etc/resolv.conf /etc/resolv.conf --ro-bind /tmp/.X11-unix/X${DISPLAY:1} /tmp/.X11-unix/X${DISPLAY:1} --setenv DISPLAY $DISPLAY --unshare-all --share-net torbrowser-launcher
```
