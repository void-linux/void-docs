# Network Filesystems

## NFS

### Mounting an NFS Share

To mount an NFS share, start by installing the `nfs-utils` and `sv-netmount`
packages.

Before mounting an NFS share, [enable](./services/index.md#enabling-services)
the `statd`, `procbind`, and `sv-netmount` services.

If the server supports `nfs4`, the `statd` service isn't necessary, and `nfs4`
should be used in the place of `nfs` as the mount type below.

To mount the NFS share, use the command below, where `host` is the hostname or
IP address of the server:

```
# mount -t nfs <host>:/path/to/sourcedir /path/to/destdir
```

Mounting options can be found in
[mount.nfs(8)](https://man.voidlinux.org/mount.nfs.8), while unmounting options can
be found in [umount.nfs(8)](https://man.voidlinux.org/umount.nfs.8).

For example, to connect `/volume` on a server at IP address
`192.168.1.99` to a directory `/mnt/volume` on your local system:

```
# mkdir /mnt/volume
# mount -t nfs 192.168.1.99:/volume /mnt/volume
```

To have the directory mounted again when the system reboots, add an entry to
[fstab(5)](https://man.voidlinux.org/fstab.5):

```
192.168.1.99:/volume /mnt/volume nfs rw,hard,intr 0 0
```

Refer to [nfs(5)](https://man.voidlinux.org/nfs.5) for more information about
the available options.

### Setting up a server (NFSv4, Kerberos disabled)

To run an nfs server, start by installing the `nfs-utils` package.

Edit `/etc/exports` to add a shared volume:

```
/storage/foo    *.local(rw,no_subtree_check,no_root_squash)
```

This line exports the `/storage/foo` directory to any host in the local domain
with read/write access. For information about the `no_subtree_check` and
`no_root_squash` options, and available options more generally, refer to
[exports(5)](https://man.voidlinux.org/exports.5).

Finally, [enable](./services/index.md#enabling-services) the `rpcbind`, `statd`,
and `nfs-server` services.

This will start up your nfs server, and the shares should now be working.  Use
the [`showmount(8)`](https://man.voidlinux.org/showmount.8) utility to check
the NFS server status:

```
# showmount -e localhost
```

You can use [nfs.conf(5)](https://man.voidlinux.org/nfs.conf.5) to configure
your server.
