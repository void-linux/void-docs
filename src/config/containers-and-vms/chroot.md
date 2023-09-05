# Creating and using chroots and containers

chroots and containers can be set up and used for many purposes, including:

- running glibc software on musl (and vice versa)
- running software in a more controlled or sandboxed environment
- creating a rootfs for bootstrapping a system

## Chroot Creation

### xvoidstrap

[`xvoidstrap(1)`](https://man.voidlinux.org/xvoidstrap.1) (from `xtools`) can be
used to create the chroot:

```
# mkdir <chroot_dir>
# XBPS_ARCH=<chroot_arch> xvoidstrap <chroot_dir> base-voidstrap <other_pkgs>
```

`<other_pkgs>` is only needed if you want to pre-install other packages in the
chroot.

### Manual Creation

Alternatively, this process can be done manually.

Create a directory that will contain the chroot, then install a base system in
it via the `base-voidstrap` package:

```
# mkdir -p "<chroot_dir>/var/db/xbps/keys"
# cp -a /var/db/xbps/keys/* "<chroot_dir>/var/db/xbps/keys"
# XBPS_ARCH=<chroot_arch> xbps-install -S -r <chroot_dir> -R <repository> base-voidstrap <other_pkgs>
```

The `<repository>` may [vary depending on
architecture](../../xbps/repositories/index.md#the-main-repository).

`<other_pkgs>` is only needed if you want to pre-install other packages in the
chroot.

## Chroot Usage

### xchroot

[`xchroot(1)`](https://man.voidlinux.org/xchroot.1) (from `xtools`) can be used
to automatically set up and enter the chroot.

### Manual Method

Alternatively, this process can be done manually.

If network access is required, copy `/etc/resolv.conf` into the chroot;
`/etc/hosts` may need to be copied as well.

Several directories then need to be mounted as follows:

```
# mount -t proc none <chroot_dir>/proc
# mount -t sysfs none <chroot_dir>/sys
# mount --rbind /dev <chroot_dir>/dev
# mount --rbind /run <chroot_dir>/run
```

Use [chroot(1)](https://man.voidlinux.org/chroot.1) to change to the new root,
then run programs and do tasks as usual. Once finished with the chroot, unmount
the chroot using [umount(8)](https://man.voidlinux.org/umount.8). If any
destructive actions are taken on the chroot directory without unmounting first,
you may need to reboot to repopulate the affected directories.

### Alternatives

#### Bubblewrap

[bwrap(1)](https://man.voidlinux.org/bwrap.1) (from the `bubblewrap` package)
has additional features like the ability for sandboxing and does not require
root access.

`bwrap` is very flexible and can be used in many ways, for example:

```
$ bwrap --bind <chroot_dir> / \
	--dev /dev \
	--proc /proc \
	--bind /sys /sys \
	--bind /run /run \
	--ro-bind /etc/resolv.conf /etc/resolv.conf \
	--ro-bind /etc/passwd /etc/passwd \
	--ro-bind /etc/group /etc/group \
	<command>
```

In this example, you will not be able to add or edit users or groups. When
running graphical applications with Xorg, you may need to also bind-mount
`~/.Xauthority` or other files or directories.

The [bwrap(1) manpage](https://man.voidlinux.org/bwrap.1) and the [Arch Wiki
article](https://wiki.archlinux.org/title/Bubblewrap#Usage_examples) contain
more examples of `bwrap` usage.

#### Flatpak

[Flatpak](../external-applications.md#flatpak) is a convenient option for
running many applications, including graphical or proprietary ones, on both
glibc and musl systems.

#### Application Containers

If a more integrated and polished solution is desired, Void also [provides OCI
containers](https://voidlinux.org/download/#containers) that work with tools
like [docker](https://www.docker.com) and
[podman](https://man.voidlinux.org/podman.1). These containers do not require
the creation of a chroot directory before usage.
