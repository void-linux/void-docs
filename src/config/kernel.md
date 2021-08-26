# Kernel

## Kernel series

Void Linux provides many kernel series in the default repository. These are
named `linux<x>.<y>`: for example, `linux4.19`. You can query for all available
kernel series by running:

```
$ xbps-query --regex -Rs '^linux[0-9.]+-[0-9._]+'
```

The `linux` meta package, installed by default, depends on one of the kernel
packages, usually the package containing the latest mainline kernel that works
with all DKMS modules. Newer kernels might be available in the repository, but
are not necessarily considered stable enough to be the default; use these at
your own risk. If you wish to use a more recent kernel and have DKMS modules
that you need to build, install the relevant `linux<x>.<y>-headers` package,
then use [xbps-reconfigure(1)](https://man.voidlinux.org/xbps-reconfigure.1) to
reconfigure the `linux<x>.<y>` package you installed. This will build the DKMS
modules.

## Removing old kernels

When updating the kernel, old versions are left behind in case it is necessary
to roll back to an older version. Over time, old kernel versions can accumulate,
consuming disk space and increasing the time taken by DKMS module updates.
Furthermore, if `/boot` is a separate partition and fills up with old kernels,
updating can fail or result in incomplete initramfs filesystems to be generated
and result in kernel panics if they are being booted. Thus, it may be advisable
to clean old kernels from time to time.

Removing old kernels is done using the
[vkpurge(8)](https://man.voidlinux.org/vkpurge.8) utility. `vkpurge` comes
pre-installed on every Void Linux system. This utility runs the necessary
[hooks](#kernel-hooks) when removing old kernels. Note that `vkpurge` does not
remove kernel *packages*, only particular *kernels*.

## Removing the default kernel series

If you've installed a kernel package for a series other than the default, and
want to remove the default kernel packages, use
[xbps.d(5)](https://man.voidlinux.org/xbps.d.5) `ignorepkg` entries to
[ignore](../xbps/advanced-usage.md#ignoring-packages) the relevant
`linux<x>.<y>` and `linux<x>.<y>-headers` packages. After adding these entries,
you will be able to remove the packages with
[xbps-remove(1)](https://man.voidlinux.org/xbps-remove.1).

## cmdline

The kernel, the initial RAM disk (initrd) and some system programs can be
configured at boot by kernel command line arguments. The parameters understood
by the kernel are explained in the [kernel-parameters
documentation](https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html)
and by [bootparam(7)](https://man.voidlinux.org/bootparam.7). Parameters
understood by dracut can be found in
[dracut.cmdline(7)](https://man.voidlinux.org/dracut.cmdline.7).

Once the system is booted, the current kernel command line parameters can be
found in the `/proc/cmdline` file. Some system programs can change their
behavior based on the parameters passed in the command line, which is what
happens when [booting a different
runsvdir](./services/index.md#booting-a-different-runsvdir), for example.

There are different ways of setting these parameters, some of which are
explained below.

### GRUB

Kernel command line arguments can be added through the GRUB bootloader by
editing `/etc/default/grub`, changing the `GRUB_CMDLINE_LINUX_DEFAULT` variable
and then running `update-grub`.

### dracut

Dracut offers a [`kernel_cmdline` configuration
option](https://man.voidlinux.org/dracut.conf.5) and [`--kernel-cmdline`
command-line option](https://man.voidlinux.org/dracut.8) that will encode
command-line arguments directly in the initramfs image. When dracut is used to
create a UEFI executable, arguments set with these options will be passed to the
kernel. However, when an ordinary initramfs is produced, these options will
*not* be passed to the kernel at boot. Instead, they will be written to a
configuration file in `/etc/cmdline.d` within the image. While dracut parses
this configuration to control its own boot-time behavior, the kernel itself will
not be aware of anything set via this mechanism.

After modifying a dracut configuration, [regenerate](#kernel-hooks) the
initramfs to ensure that it includes the changes.

## Kernel hardening

Void Linux ships with some kernel security options enabled by default. This was
originally provided by kernel command line arguments `slub_debug=P
page_poison=1`, but since kernel series 5.3, these have been replaced with
`init_on_alloc` and `init_on_free` (see [this
commit](https://github.com/torvalds/linux/commit/6471384af)).

Void's kernels come with the `init_on_alloc` option enabled by default where
available (i.e. `linux5.4` and greater). In most cases you should usually not
disable it, as it has a fairly minimal impact on performance (within 1%). The
`init_on_free` option is more expensive (around 5% on average) and needs to be
enabled manually by passing `init_on_free=1` on the kernel command line. If you
need to disable `init_on_alloc`, you can do that similarly by passing
`init_on_alloc=0`.

There is a chance that your existing system still has the old options enabled.
They still work in newer kernels, but have a performance impact more in line
with `init_on_free=1`. On older hardware this can be quite noticeable. If you
are running a kernel series older than 5.4, you can keep them (or add them) for
extra security at the cost of speed; otherwise you should remove them.

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
# xbps-reconfigure --force linux<x>.<y>
```

If run manually, they serve to apply initramfs configuration changes to the next
boot.

### Remove hooks

The `{pre,post}-remove` hooks are executed by
[vkpurge(8)](https://man.voidlinux.org/vkpurge.8) when removing old kernels.

## Dynamic Kernel Module Support (DKMS)

There are kernel modules that are not part of the Linux source tree that are
built at install time using DKMS and [kernel hooks](#kernel-hooks). The
available modules can be listed by searching for `dkms` in the package
repositories.

DKMS build logs are available in `/var/lib/dkms/`.
