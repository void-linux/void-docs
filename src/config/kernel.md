# Kernel

## Kernel series

Void Linux provides many kernel series in the default repository,

```
$ xbps-query --regex -Rs '^linux[0-9.]+-[0-9._]+'
[-] linux3.16-3.16.63_1          The Linux kernel and modules (3.16 series)
[-] linux3.18-3.18.124_1         The Linux kernel and modules (3.18 series)
[-] linux4.14-4.14.98_1          The Linux kernel and modules (4.14 series)
[*] linux4.19-4.19.25_1          The Linux kernel and modules (4.19 series)
[-] linux4.20-4.20.12_1          The Linux kernel and modules (4.20 series)
[-] linux4.4-4.4.176_1           The Linux kernel and modules (4.4 series)
[-] linux4.9-4.9.160_1           The Linux kernel and modules (4.9 series)
```

The `linux` meta package which is installed by default depends on one of the
kernel packages, usually the latest mainline kernel that works with all dkms
modules.

## Removing old kernels

```
$ vkpurge list
3.8.2_1
```

You can now remove a specific kernel version like `3.8.2_1` or `all` which
removes all kernels expect the latest kernel of each series and the kernel that
is currently booted.

```
# vkpurge rm 3.8.2_1
# vkpurge rm all
```

## Kernel modules

### Loading kernel modules at boot

To load kernel modules at boot time, a `.conf` file like
`/etc/modules-load.d/virtio.conf` can be created.

```
# load virtio-net
virtio-net
```

### Blacklisting kernel modules

There are two different methods to blacklist kernel modules, for the initramfs
and for the booted system. Some modules are loaded by the initramfs very early
in the boot process, those have to be blacklisted in the initramfs.

You can blacklist modules with a `.conf` file like
`/etc/modprobe.d/radeon.conf`.

```
blacklist radeon
```

#### dracut

To blacklist modules from being included in a dracut initramfs you need to
create a `.conf` file like `/etc/dracut.conf.d/radeon.conf`.

```
omit_drivers+=" radeon "
```

Now you need to regenerate the initramfs to make the changes take effect on the
next reboot.

```
# dracut --force
```

#### mkinitcpio

XXX: add example of blacklisting kernel modules for mkinitcpio

## Kernel hooks

Void Linux provides directories for kernel hooks in
`/etc/kernel.d/{pre-install,post-install,pre-remove,post-remove}`.

Bootloaders like `grub`, `gummiboot` and `lilo` use those hooks to update the
bootmenu. Initramfs tools like `dracut` and `mkinitcpio` use the hooks to
generate initramfs files for newly installed kernels.

## Dynamic Kernel Module Support (dkms)

There are kernel modules that are not part of the linux source tree that are
build at install time using dkms and [kernel hooks](#kernel-hooks).

```
$ xbps-query -Rs dkms
[-] acpi_call-dkms-1.2.0_2             Kernel module allowing calls to ACPI methods through /proc/acpi/call
[-] dkms-2.4.0_2                       Dynamic Kernel Modules System
[-] exfat-dkms-1.2.8_2                 Exfat kernel driver (nofuse)
[-] spl-0.6.5.10_1                     Solaris Porting Layer -- userland and kernel modules (using DKMS)
[-] tp_smapi-dkms-0.42_2               IBM ThinkPad hardware functions driver
[-] virtualbox-ose-dkms-5.1.24_1       General-purpose full virtualizer for x86 hardware - kernel module sources for dkms
[-] virtualbox-ose-guest-dkms-5.1.24_1 General-purpose full virtualizer for x86 hardware - guest addition module source for dkms
[-] zfs-0.6.5.10_1                     Z File System -- userland and kernel modules (using DKMS)
[-] zfs-32bit-0.6.5.10_1               Z File System -- userland and kernel modules (using DKMS) (32bit)
[-] broadcom-wl-dkms-6.30.223.271_6    Broadcom proprietary wireless drivers for Linux - DKMS kernel module
[-] catalyst-dkms-15.302_2             AMD catalyst driver 15.12 for Linux - DKMS kernel module
[-] nvidia-dkms-381.22_2               NVIDIA drivers for linux (long-lived series) - DKMS kernel module
[-] nvidia304-dkms-304.135_4           NVIDIA drivers (For GeForce 5 FX, 6, 7, 8 series) - DKMS kernel module
[-] nvidia340-dkms-340.102_5           NVIDIA drivers (GeForce 8, 9, 9M, 100, 100M, 200, 300 series) - DKMS kernel module
```

## cmdline

### GRUB

Kernel command line arguments can be added through the grub bootloader by
editing `/etc/default/grub` and changing the `GRUB_CMDLINE_LINUX_DEFAULT`
variable and then regenerating the grub configuration.

```
# vi /etc/default/grub
# grub-mkconfig -o /boot/grub/grub.cfg
```

### dracut

Dracut can be configured to add additional cmdline arguments to the kernel by
creating a configuration file and regenerating the initramfs, make sure to
reconfigure the right kernel version like `linux4.12` as example.

```
# mkdir -p /etc/dracut.conf.d
# echo 'kernel_cmdline+="<extra cmdline arguments>"' >> /etc/dracut.conf.d/cmdline.sh
# xbps-reconfigure -f linux4.12
```
