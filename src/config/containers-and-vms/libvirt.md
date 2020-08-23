# libvirt

[libvirt](https://libvirt.org/) is an API and daemon for managing platform
virtualization, supporting virtualization technologies such as LXC, KVM, QEMU,
Bhyve, Xen, VMWare, and Hyper-V.

To use libvirt, install the `libvirt` package, ensure the `dbus` package is
installed, and [enable](../services/index.md#enabling-services) the `dbus`,
`libvirtd`, `virtlockd` and `virtlogd` services. The `libvirtd` daemon can be
reconfigured at runtime via
[virt-admin(1)](https://man.voidlinux.org/virt-admin.1).

The `libvirt` package provides the [virsh(1)](https://man.voidlinux.org/virsh.1)
interface to libvirtd. `virsh` is an interactive shell and batch-scriptable tool
for performing management tasks, including creating, configuring and running
virtual machines, and managing networks and storage. Note that `virsh` usually
needs to be run as root, as described in the `virsh` man page:

> Most virsh commands require root privileges to run due to the communications
> channels used to talk to the hypervisor. Running as non root will return an
> error.

However, if you have the `polkit` and `dbus` packages installed and you enable
the `dbus` service, `libvirtd` will grant necessary privileges to any user added
to the `libvirt` group.

An alternative to `virsh` is provided by the `virt-manager` and
`virt-manager-tools` packages.

For general information on libvirt, refer to [the libvirt
wiki](https://wiki.libvirt.org/page/Main_Page) and [the wiki's
FAQ](https://wiki.libvirt.org/page/FAQ). For an introduction to libvirt usage,
refer to [the "VM lifecycle" page](https://wiki.libvirt.org/page/VM_lifecycle).
