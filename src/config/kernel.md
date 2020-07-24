# Kernel

## Kernel series

Void Linux provides many kernel series in the default repository. These are
named `linuxX.Y`: for example, `linux4.19`. You can query for all available
kernel series by running:

```
$ xbps-query --regex -Rs '^linux[0-9.]+-[0-9._]+'
```

The `linux` meta package, installed by default, depends on one of the kernel
packages, usually the package containing the latest mainline kernel that works
with all DKMS modules. Newer kernels might be available in the repository, but
are not necessarily considered stable enough to be the default; use these at
your own risk. If you wish to use a more recent kernel and have DKMS modules
that you need to build, install the relevant `linuxX.Y-headers` package, then
use [xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) to
reconfigure the `linuxX.Y` package you installed. This will build the DKMS
modules.

## Removing old kernels

When updating the kernel, old versions are left behind in case it is necessary
to roll back to an older version. Over time, old kernel versions can accumulate,
consuming disk space and increasing the time taken by dkms module updates.
Furthermore, if `/boot` is a separate partition and fills up with old kernels,
updating can fail or result in incomplete initramfs filesystems to be generated
and result in kernel panics if they are being booted. Thus, it may be advisable
to clean old kernels from time to time.

Removing old kernels is done using the
[vkpurge(8)](https://man.voidlinux.org/vkpurge.8) utility. `vkpurge` comes
pre-installed on every Void Linux system. This utility runs the necessary
[hooks](#kernel-hooks) when removing old kernels. Note that `vkpurge` does not
remove kernel *packages*, only particular *kernels*.

## Kernel modules

Kernel modules are typically drivers for devices or filesystems.

### Loading kernel modules during boot

Normally the kernel automatically loads required modules, but sometimes it may
be necessary to explicitly specify modules to be loaded during boot.

To load kernel modules during boot, a `.conf` file like
`/etc/modules-load.d/virtio.conf` needs to be created with the contents:

```
# load virtio-net
virtio-net
```

### Blacklisting kernel modules

Blacklisting kernel modules is a method for preventing modules from being loaded
by the kernel. There are two different methods for blacklisting kernel modules,
one for modules loaded by the initramfs and one for modules loaded after the
initramfs process is done. Modules loaded by the initramfs have to be
blacklisted in the initramfs configuration.

To blacklist modules loaded after the initramfs process, create a `.conf` file,
like `/etc/modprobe.d/radeon.conf`, with the contents:

```
blacklist radeon
```

#### Blacklisting modules in the initramfs

After making the necessary changes to the configuration files, the initramfs
needs to be [regenerated](#kernel-hooks) for the changes to take effect on the
next boot.

##### dracut

Dracut can be configured to not include kernel modules through a configuration
file. To blacklist modules from being included in a dracut initramfs, create a
`.conf` file, like `/etc/dracut.conf.d/radeon.conf`, with the contents:

```
omit_drivers+=" radeon "
```

##### mkinitcpio

To blacklist modules from being included in a mkinitcpio initramfs a `.conf`
file needs to be created like `/etc/modprobe.d/radeon.conf` with the contents:

```
blacklist radeon
```

## Kernel hooks

Void Linux provides directories for kernel hooks in
`/etc/kernel.d/{pre-install,post-install,pre-remove,post-remove}`.

These hooks are used to update the boot menus for bootloaders like `grub`,
`gummiboot` and `lilo`.

### Install hooks

The `{pre,post}-install` hooks are executed by
[xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) when
configuring a Linux kernel, such as building its initramfs. This happens when a
kernel series is installed for the first time or updated, but can also be run
manually:

```
# xbps-reconfigure --force linuxX.Y
```

If run manually, they serve to apply initramfs configuration changes to the next
boot.

### Remove hooks

The `{pre,post}-remove` hooks are executed by
[vkpurge(8)](https://man.voidlinux.org/vkpurge.8) when removing old kernels.

## Dynamic Kernel Module Support (dkms)

There are kernel modules that are not part of the Linux source tree that are
built at install time using dkms and [kernel hooks](#kernel-hooks). The
available modules can be listed by searching for `dkms` in the package
repositories.

## cmdline

### GRUB

Kernel command line arguments can be added through the GRUB bootloader by
editing `/etc/default/grub`, changing the `GRUB_CMDLINE_LINUX_DEFAULT` variable
and then running `update-grub`.

### dracut

Dracut can be configured to add additional command line arguments to the kernel
through a configuration file. The documentation for dracut's configuration files
can be found in [dracut.conf(5)](https://man.voidlinux.org/dracut.conf.5). To
apply these changes, it is necessary to [regenerate](#kernel-hooks) the
initramfs.
