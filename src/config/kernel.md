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

When updating the kernel, old versions are left behind in case it is necessary
to roll back to an older version. Over time, many old kernel version accumulate
and make updating dmks modules take a long time. Thus, it may be advisable to
clean old kernels from time to time.

Removing old kernels is done using the
[vkpurge(8)](https://man.voidlinux.org/vkpurge.8) utility. `vkuprge` comes
pre-installed on every Void Linux system. This utility runs the necessary hooks
when removing old kernels.

To list kernels that can be purged:

```
$ vkpurge list
3.8.2_1
```

To remove a specific kernel version like `3.8.2_1`:

```
# vkpurge rm 3.8.2_1
```

To remove `all` kernels except the latest kernel of each series and the kernel
that is currently booted:

```
# vkpurge rm all
```

## Kernel modules

Kernel modules are typically drivers for devices or filesystems. Normally the
kernel automatically loads required modules, but sometimes it may be necessary
to explicitly load modules at boot.

### Loading kernel modules at boot

To load kernel modules at boot time, a `.conf` file like
`/etc/modules-load.d/virtio.conf` needs to be created with the contents:

```
# load virtio-net
virtio-net
```

### Blacklisting kernel modules

There are two different methods to blacklist kernel modules, for the initramfs
and for the booted system. Some modules are loaded by the initramfs very early
in the boot process, those have to be blacklisted in the initramfs.

To blacklist modules, create a `.conf` file like `/etc/modprobe.d/radeon.conf`
with the contents:

```
blacklist radeon
```

#### dracut

To blacklist modules from being included in a dracut initramfs a `.conf` file
needs to be created like `/etc/dracut.conf.d/radeon.conf` with the contents:

```
omit_drivers+=" radeon "
```

Now initramfs needs to be regenerated to make the changes take effect on the
next reboot:

```
# dracut --force
```

#### mkinitcpio

To blacklist modules from being included in a mkinitcpio initramfs a `.conf`
file needs to be created like `/etc/modprobe.d/radeon.conf` with the contents:

```
blacklist radeon
```

Now initramfs needs to be regenerated to make the changes take effect on the
next reboot:

```
# mkinitcpio -p linux
```

## Kernel hooks

Void Linux provides directories for kernel hooks in
`/etc/kernel.d/{pre-install,post-install,pre-remove,post-remove}`.

Bootloaders like `grub`, `gummiboot` and `lilo` use those hooks to update the
boot menu. Initramfs tools like `dracut` and `mkinitcpio` use the hooks to
generate initramfs files for newly installed kernels.

## Dynamic Kernel Module Support (dkms)

There are kernel modules that are not part of the Linux source tree that are
build at install time using dkms and [kernel hooks](#kernel-hooks).

```
$ xbps-query -Rs dkms
[-] acpi_call-dkms-1.2.0_2             Kernel module allowing calls to ACPI methods through /proc/acpi/call
[-] dkms-2.7.1_1                       Dynamic Kernel Modules System
[-] exfat-dkms-1.2.8_5                 Exfat kernel driver (nofuse)
[-] lttng-modules-dkms-2.10.9_2        LTTng modules provide Linux kernel tracing capability
[-] openrazer-driver-dkms-2.5.0_1      Kernel driver for Razer devices (DKMS-variant)
[-] rtl8812au-dkms-20190731_1          Realtek 8812AU/8821AU USB WiFi driver (DKMS)
[-] rtl8822bu-dkms-20190427_1          Realtek 8822BU USB WiFi driver (DKMS)
[-] spl-0.7.13_1                       Solaris Porting Layer -- userland and kernel modules (using DKMS)
[-] tp_smapi-dkms-0.43_1               IBM ThinkPad hardware functions driver
[-] vhba-module-dkms-20190410_1        Virtual (SCSI) HBA module used by cdemu
[-] virtualbox-ose-dkms-6.0.10_1       General-purpose full virtualizer for x86 hardware - kernel module sources for dkms
[-] virtualbox-ose-guest-dkms-6.0.10_1 General-purpose full virtualizer for x86 hardware - guest addition module source for dkms
[-] zfs-0.8.1_1                        Z File System -- userland, pyzfs, and kernel modules (using DKMS)
[-] zfs-32bit-0.8.1_1                  Z File System -- userland, pyzfs, and kernel modules (using DKMS) (32bit)
[-] broadcom-wl-dkms-6.30.223.271_8    Broadcom proprietary wireless drivers for Linux - DKMS kernel module
[-] catalyst-dkms-15.302_2             AMD catalyst driver 15.12 for Linux - DKMS kernel module
[-] nvidia-dkms-430.14_2               NVIDIA drivers for linux - DKMS kernel module
[-] nvidia340-dkms-340.107_3           NVIDIA drivers (GeForce 8, 9, 9M, 100, 100M, 200, 300 series) - DKMS kernel module
[-] nvidia390-dkms-390.116_3           NVIDIA drivers (GeForce 400, 500 series) - DKMS kernel module
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

Dracut can be configured to add additional command line arguments to the kernel
by creating a configuration file and regenerating the initramfs, make sure to
reconfigure the right kernel version like `linux4.12` as example.

```
# mkdir -p /etc/dracut.conf.d
# echo 'kernel_cmdline+="<extra cmdline arguments>"' >> /etc/dracut.conf.d/cmdline.sh
# xbps-reconfigure -f linux4.12
```
