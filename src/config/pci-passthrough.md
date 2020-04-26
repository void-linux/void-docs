# PCI Passthrough

PCI passthrough allows PCI devices to appear to be attached directly to the
guest operating system in a virtual machine, with only minimal impact on
performance. PCI passthrough can thus be used to improve the performance of VM
applications which require GPU acceleration.

## System Requirements

ArchWiki contains a list of [example
rigs](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF/Examples)
for PCI passthrough. General requirements include:

- Hardware must support hardware virtualization and IOMMU
   - For Intel CPU: Intel VT-x and Intel VT-d support. You can check if your CPU
      has this feature on [Intel
      ark](https://ark.intel.com/content/www/us/en/ark/search/featurefilter.html?productType=873&0_VTD=True).
   - All AMD CPUs: All CPUs after Bulldozer are supported. Exceptions include
      CPUs from the K10 family, which require a motherboard with
      [890FX](https://www.amd.com/system/files/TechDocs/43403.pdf#page=18) or
      [990FX](https://www.amd.com/system/files/TechDocs/48691.pdf#page=21).
- Your motherboard must support IOMMU
- Your guest GPU ROM must support UEFI
   - Check if your GPU has any ROM on [this
      list](https://www.techpowerup.com/vgabios/). Most GPUs after 2012 support
      this.

## Enabling IOMMU

### BIOS

First, enable IOMMU in your computer's BIOS. This setting is usually named
"SVM", "IOMMU", "VT-d", "AMD-vi", or "virtualization technology"; the BIOS help
might indicate which specific setting enables IOMMU support. Some of the
[example
rigs](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF/Examples)
may explain which settings they enabled in BIOS. You may have to resort to trial
and error.

### Kernel Parameter

Add a kernel parameter to enable IOMMU for your CPU. If using the GRUB
bootloader, edit `/etc/default/grub` and add one of the following to
`GRUB_CMDLINE_LINUX_DEFAULT`:

- Intel CPU: `intel_iommu=on`
- AMD CPU: `amd_iommu=on`

You should also add the `iommu=pt` kernel parameter to make sure the Linux
kernel doesn't touch the devices you have added to your passthrough.

Once you have added your required kernel parameters, run the following command
to regenerate `grub.cfg` with the new kernel:

```
# grub-mkconfig /boot/grub/grub.cfg
```

### Testing

Run the following command to check if you set up IOMMU and AMD-Vi correctly:

```
# dmesg | grep -i -e DMAR -e IOMMU
```

On an AMD system, look for the lines in the output:

```
# dmesg | grep -i -e DMAR -e IOMMU 
[...]
[    2.153481] iommu: Default domain type: Passthrough (set via kernel command line) 
[    2.511239] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters supported 
[    2.511513] pci 0000:00:01.0: Adding to iommu group 0 
[    2.511539] pci 0000:00:01.3: Adding to iommu group 1 
[    2.511561] pci 0000:00:02.0: Adding to iommu group 2 
[...]
[    2.512503] pci 0000:0a:00.3: Adding to iommu group 21 
[    2.512712] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40 
[    2.513088] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters/bank). 
[    2.730288] AMD-Vi: AMD IOMMUv2 driver by Joerg Roedel <jroedel@suse.de> 
```

On an Intel system, look for lines similar to (courtesy of the ArchWiki):

```
[    0.000000] ACPI: DMAR 0x00000000BDCB1CB0 0000B8 (v01 INTEL  BDW      00000001 INTL 00000001)
[    0.000000] Intel-IOMMU: enabled
[    0.028879] DMAR: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020660462 ecap f0101a
[    0.028883] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap d2008c20660462 ecap f010da
[    0.028950] IOAPIC id 8 under DRHD base  0xfed91000 IOMMU 1
[    0.536212] DMAR: No ATSR found
[    0.536229] IOMMU 0 0xfed90000: using Queued invalidation
[    0.536230] IOMMU 1 0xfed91000: using Queued invalidation
[    0.536231] IOMMU: Setting RMRR:
[    0.536241] IOMMU: Setting identity map for device 0000:00:02.0 [0xbf000000 - 0xcf1fffff]
[    0.537490] IOMMU: Setting identity map for device 0000:00:14.0 [0xbdea8000 - 0xbdeb6fff]
[    0.537512] IOMMU: Setting identity map for device 0000:00:1a.0 [0xbdea8000 - 0xbdeb6fff]
[    0.537530] IOMMU: Setting identity map for device 0000:00:1d.0 [0xbdea8000 - 0xbdeb6fff]
[    0.537543] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.537549] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    2.182790] [drm] DMAR active, disabling use of stolen memory
```

## Isolating the GPU

Use the `vfio-pci` driver rather than the original Nvidia or AMD graphics
driver.

> Note: Whatever GPU you isolate here will no longer be usable on your host
> system

### Checking IOMMU groups

Different motherboards and motherboard manufacturers have different ways to set
up IOMMU grouping. If your IOMMU groups are not correct, you may have to [patch
your
kernel](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Bypassing_the_IOMMU_groups_(ACS_override_patch)),
change the PCI slot your GPU is in, or use a different motherboard. Once again,
the example rigs are helpful here.

To check your groups, run the following script:

```
#!/bin/bash
shopt -s nullglob
for g in /sys/kernel/iommu_groups/*; do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;
```

The output from this script should be something like the following:

```
$ bash iommu.sh 
[...]
IOMMU Group 13: 
        01:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] X370 Series Chipset USB 3.1 xHCI Controller [1022:43b9] (rev 02) 
        01:00.1 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] X370 Series Chipset SATA Controller [1022:43b5] (rev 02) 
        01:00.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] X370 Series Chipset PCIe Upstream Port [1022:43b0] (rev 02) 
        02:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 300 Series Chipset PCIe Port [1022:43b4] (rev 02) 
        02:02.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 300 Series Chipset PCIe Port [1022:43b4] (rev 02) 
        02:03.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 300 Series Chipset PCIe Port [1022:43b4] (rev 02) 
        02:04.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 300 Series Chipset PCIe Port [1022:43b4] (rev 02) 
        03:00.0 USB controller [0c03]: ASMedia Technology Inc. ASM1143 USB 3.1 Host Controller [1b21:1343] 
        04:00.0 Ethernet controller [0200]: Intel Corporation I211 Gigabit Network Connection [8086:1539] (rev 03) 
        05:00.0 Ethernet controller [0200]: Qualcomm Atheros Killer E2500 Gigabit Ethernet Controller [1969:e0b1] (rev 10) 
IOMMU Group 14: 
        07:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] [1002:67df] (rev e7) 
        07:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Ellesmere HDMI Audio [Radeon RX 470/480 / 570/580/590] [1002:aaf0] 
[...]
```

It is important to consider which PCI slot you use with your graphics card. Some
PCI slots may have other peripherals in the same IOMMU group (ie. `IOMMU Group
13` the output above), which make the slot inconvienient to pass through.

### Isolating GPU

Find the GPU and its associated audio device you want to pass through to your
guest in the IOMMU group list and get the content inside the second square
brackets (eg. `1002:67df` and `1002:aaf0`).

> Note: If you have a host with two identical GPUs, you will have to follow
> different instructions to pass through your GPU. Refer to the ArchWiki for
> [further
> details](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Using_identical_guest_and_host_GPUs).

Add the kernel parameter (e.g. `vfio-pci.ids=1002:67df,1002:aaf0`) to your
bootloader configuration, as described above. Do not add any other components of
the IOMMU group, even if you later end up passing through some other device
(e.g. a USB controller).

### Checking

After rebooting, use `lspci` to check if the GPU and its audio device is using
the `vfio-pci` driver:

```
$ lspci -nnk -d 1002:67df 
[...]
        Kernel driver in use: vfio-pci 
```

```
$ lspci -nnk -d 1002:aaf0 
[...]
        Kernel driver in use: vfio-pci 
```

## Setting up OVMF-based guest VM

Install the `qemu`, `libvirt`, and `virt-manager` packages.

Build and install the `ovmf` package using
[xbps-src](https://github.com/void-linux/void-packages/#quick-start), after
applying [these
changes](https://github.com/void-linux/void-packages/pull/17225/files).

Make sure the `libvirtd`, `virtlogd`, and `virtlockd` services are enabled.

To run `virt-manager` without root, add yourself to the `libvirt` user group and
uncomment the following lines in `/etc/libvirt/libvirtd.conf`:

```
unix_sock_group = "libvirt"
unix_sock_ro_perms = "0770"
unix_sock_rw_perms = "0770"
unix_sock_admin_perms = "0770"
unix_sock_dir = "/var/run/libvirt"
```

Log out and back in to apply the new group settings.

Using `virt-manager`, create a new virtual machine, checking the "Customize
before install" checkbox when offered. In the "Overview" section, set the
firmware to UEFI, the chipset to Q35, and in the "CPUs" section, set "Copy host
CPU configuration". Then complete the VM creation process.

Once the VM has been created, open it, select "Add Hardware", and for "PCI Host
Device", add the devices specified in the `vfio-pci.ids` kernel parameter. If
you wish to add a mouse and keyboard, do so under the "USB Host Device" section.

> Note: If you wish to avoid having to use two mice and two keyboards, your
> IOMMU groups might allow use of a KVM switch to pass through one of the USB
> controllers

Boot up your new virtual machine with your install medium and install your
operating system.

> Boot up your new virtual machine with your install medium, making sure a
> monitor is plugged in to the passed-through GPU, and install the relevant
> operating system.

## Additional Tweaks

Visit the ArchWiki for several recommended [performance
tweaks](https://wiki.archlinux.org/index.php/PCI_passthrough_via_OVMF#Performance_tuning).

### Using Scream for audio

PCI passthrough audio can be difficult to configure.
[Scream](https://github.com/duncanthrax/scream) can be used to avoid this. The
required guest drivers can be found on the project's [Releases
page](https://github.com/duncanthrax/scream/releases), and the relevant
`virt-manager` configuration is described in [the project's
README](https://github.com/duncanthrax/scream#using-ivshmem-between-windows-guest-and-linux-host).

To access the `/dev/shm/scream-ivshmem` file, your user must be in the `libvirt`
group and changed the relevant permissions in `/etc/libvirt/libvirtd.conf` as
described above. Scream requires either the `scream-pulseaudio-ivshmem` package
or the `scream-alsa-ivshmem` package. Once the relevant package is installed,
run either:

```
$ scream-ivshmem-pulse /dev/shm/scream-ivshmem
```

or

```
$ scream-ivshmem-alsa /dev/shm/scream-ivshmem
```

Finally, select Scream as the output speaker on your guest.
