# LXC

The [Linux Containers project](https://linuxcontainers.org/) includes three
subprojects: [LXC](https://linuxcontainers.org/lxc/introduction/),
[LXD](https://linuxcontainers.org/lxd/introduction/) and
[LXCFS](https://linuxcontainers.org/lxcfs/introduction/). The project also
included the CGManager project, which has been deprecated in favor of the CGroup
namespace in recent kernels.

## Configuring LXC

Install the `lxc` package.

Creating and running privileged containers as `root` does not require any
configuration; simply use the various `lxc-*` commands, such as
[lxc-create(1)](https://man.voidlinux.org/lxc-create.1),
[lxc-start(1)](https://man.voidlinux.org/lxc-start.1),
[lxc-attach(1)](https://man.voidlinux.org/lxc-attach.1), etc.

### Creating unprivileged containers

Both [subuid(5)](https://man.voidlinux.org/subuid.5) and
[subgid(5)](https://man.voidlinux.org/subgid.5) need to have entries for the
user who will be running unprivileged containers. That user will also need to
have a `default.conf` file specifying use of the relevant subuids and subgids.
`/etc/subuid` and `/etc/subgid` contain an entry for `root` by default, but
entries for other users need to be added manually.

Edit `/etc/subuid` and `/etc/subgid` as root to add the relevant entries:

```
root:1000000:65536
<user>:2000000:65536
```

In each case, the entry specifies a base value, and the number of subuids
available to that user starting from the base value. Thus, root will have
subuids/subgids 1000000 to 1065535.

If configuring a non-root user, edit `/etc/lxc/lxc-usernet` as root to specify a
network device quota. For example, to allow the user named `user` to create up
to 10 `veth` devices connected to the `lxcbr0` bridge:

```
user veth lxcbr0 10
```

If configuring root, specify the subuid and subgid in `/etc/lxc/default.conf`:

```
lxc.idmap = u 0 1000000 65536
lxc.idmap = g 0 1000000 65536
```

Otherwise, create `~/.config/lxc/default.conf`:

```
$ mkdir ~/.config/lxc
$ cp /etc/lxc/default.conf ~/.config/lxc/default.conf
```

and edit the user's `default.conf` to include the relevant `lxc.idmap` entries.

The user can now create and use unprivileged containers with the `lxc-*`
utilities.

## LXD

LXD provides an alternative interface to LXC's `lxc-*` utilities. However, it
does not require the configuration described in [the previous section](#lxc).

Install the `lxd` package, and [enable](./services/index.md#enabling-services)
the `lxd` service.

LXD users must belong to the `lxd` group.

Use the `lxc` command to manage instances, as described
[here](https://linuxcontainers.org/lxd/getting-started-cli/#lxd-client).
