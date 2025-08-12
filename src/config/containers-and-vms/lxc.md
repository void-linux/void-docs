# LXC

The [Linux Containers project](https://linuxcontainers.org/) includes four
subprojects: [Incus](https://linuxcontainers.org/incus/introduction/),
[LXC](https://linuxcontainers.org/lxc/introduction/),
[LXCFS](https://linuxcontainers.org/lxcfs/introduction/) and
[distrobuilder](https://linuxcontainers.org/distrobuilder/introduction/).

The project also formerly included the CGManager and
[LXD](https://canonical.com/lxd) projects. CGManager has been deprecated in
favor of the CGroup namespace in recent kernels. LXD has become a Canonical
project. Incus was forked from LXD to be a community driven alternative, and is
led and maintained by many of the original creators.

## Configuring LXC

Install the `lxc` package.

Creating and running privileged containers as `root` does not require any
configuration; simply use the various `lxc-*` commands, such as
[lxc-create(1)](https://man.voidlinux.org/lxc-create.1),
[lxc-start(1)](https://man.voidlinux.org/lxc-start.1),
[lxc-attach(1)](https://man.voidlinux.org/lxc-attach.1), etc.

### Creating unprivileged containers

User IDs (UIDs) and group IDs (GIDs) normally range from 0 to 65535.
Unprivileged containers enhance security by mapping UID and GID ranges inside
each container to ranges not in use by the host system. The unused host ranges
must be *subordinated* to the user who will be running the unprivileged
containers.

Subordinate UIDs and GIDs are assigned in the
[subuid(5)](https://man.voidlinux.org/subuid.5) and
[subgid(5)](https://man.voidlinux.org/subgid.5) files, respectively.

To create unprivileged containers, first edit `/etc/subuid` and `/etc/subgid` to
delegate ranges. For example:

```
root:1000000:65536
user:2000000:65536
```

In each colon-delimited entry:

- the first field is the user to which a subordinate range will be assigned;
- the second field is the smallest numeric ID defining a subordinate range; and
- the third field is the number of consecutive IDs in the range.

The [usermod(8)](https://man.voidlinux.org/usermod.8) program may also be used
to manipulate suborinated IDs.

Generally, the number of consecutive IDs should be an integer multiple of 65536;
the starting value is not important, except to ensure that the various ranges
defined in the file do not overlap. In this example, `root` controls UIDs (or,
from `subgid`, GIDs) ranging from 1000000 to 1065535, inclusive; `user` controls
IDs ranging from 2000000 to 2065535.

Before creating a container, the user owning the container will need an
[lxc.conf(5)](https://man.voidlinux.org/lxc.conf.5) file specifying the subuid
and subgid range to use. For root-owned containers, this file resides at
`/etc/lxc/default.conf`; for unprivileged users, the file resides at
`~/.config/lxc/default.conf`. Mappings are described in lines of the form

```
lxc.idmap = u 0 1000000 65536
lxc.idmap = g 0 1000000 65536
```

The isolated `u` character indicates a UID mapping, while the isolated `g`
indicates a GID mapping. The first numeric value should generally always be 0;
this indicates the start of the UID or GID range *as seen from within the
container*. The second numeric value is the start of the corresponding range *as
seen from outside the container*, and may be an arbitrary value within the range
delegated in `/etc/subuid` or `/etc/subgid`. The final value is the number of
consecutive IDs to map.

Note that, although the external range start is arbitrary, care must be taken to
ensure that the end of the range implied by the start and number does not extend
beyond the range of IDs delegated to the user.

If configuring a non-root user, edit `/etc/lxc/lxc-usernet` as root to specify a
network device quota. For example, to allow the user named `user` to create up
to 10 `veth` devices connected to the `lxcbr0` bridge:

```
user veth lxcbr0 10
```

The user can now create and use unprivileged containers with the `lxc-*`
utilities. To create a simple Void container named `mycontainer`, use a command
similar to:

```
lxc-create -n mycontainer -t download -- \
	--dist voidlinux --release current --arch amd64
```

You may substitute another architecture for `amd64`, and you may specify a
`musl` image by adding `--variant musl` to the end of the command. See the [LXC
Image Server](http://images.linuxcontainers.org) for a list of available
containers.

By default, configurations and mountpoints for system containers are stored in
`/var/lib/lxc`, while configurations for user containers and mountpoints are
stored in `~/.local/share/lxc`. Both of these values can be modified by setting
`lxc.lxcpath` in the
[lxc.system.conf(5)](https://man.voidlinux.org/lxc.system.conf.5) file. The
superuser may launch unprivileged containers in the system `lxc.lxcpath` defined
in `/etc/lxc/lxc.conf`; regular users may launch unprivileged containers in the
personal `lxc.lxcpath` defined in `~/.config/lxc/lxc.conf`.

All containers will share the same subordinate UID and GID maps by default. This
is permissible, but it means that an attacker who gains elevated access within
one container, and can somehow break out of that container, will have similar
access to other containers. To isolate containers from each other, alter the
`lxc.idmap` ranges in `default.conf` to point to a unique range *before* you
create each container. Trying to fix permissions on a container created with the
wrong map is possible, but inconvenient.

## Incus

Incus provides an alternative interface to LXC's `lxc-*` utilities. However, it
does not require the configuration described in [the previous section](#lxc).

In `/etc/rc.conf`, set the `CGROUP_MODE` variable to `unified`. Install the
`incus` package, and [enable](../services/index.md#enabling-services) the
`incus` service.

Some parts of Incus require optional dependencies, see
[README.voidlinux](../package-documentation/index.md).

Add users who should have full control over Incus to the `_incus-admin` group.

Optionally, some users can be given limited access to Incus as described
[here](https://linuxcontainers.org/incus/docs/main/howto/projects_confine/#confine-projects-to-specific-incus-users).
Add these users to the `_incus` group, and enable the `incus-user` service.

Note that `incus-user` will initialize the default Incus profile when it is
started. To avoid default configuration initialize Incus for yourself with
`incus admin init` before enabling `incus-user`.

> Warning: `incus-user` will also replace the networking config of the default
> profile if it appears invalid. runit does not have socket activation so this
> happens when the machine boots instead of when a user calls `incus`. If the
> default profile uses a [bridge
> interface](../network/index.md#bridge-interfaces), `incus-user` may replace it
> on boot.

To migrate existing LXD setups to Incus, use the `lxd-to-incus` tool from the
`incus-tools` package as described
[here](https://linuxcontainers.org/incus/docs/main/howto/server_migrate_lxd/).

To migrate existing LXC containers to Incus, use the `lxc-to-incus` script from
the `incus-tools` package as described
[here](https://linuxcontainers.org/incus/docs/main/howto/migrate_from_lxc/).

Some Incus features have additional dependencies. To run virtual machines,
install `qemu` and `edk2-ovmf`. To run OCI containers, install `skopeo`.

## LXD

LXD provides an alternative interface to LXC's `lxc-*` utilities. However, it
does not require the configuration described in [the previous section](#lxc).

Install the `lxd` package, and [enable](../services/index.md#enabling-services)
the `lxd` service.

LXD users must belong to the `lxd` group.

Use the `lxc` command to manage instances, as described
[here](https://documentation.ubuntu.com/lxd/en/latest/howto/).
