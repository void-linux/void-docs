# Microcode

Microcode is loaded onto the CPU or GPU at boot by the BIOS, but can be replaced
later by the OS itself. An update to microcode can allow a CPU's or GPU's
behavior to be modified to work around certain yet to be discovered bugs,
without the need to replace the hardware.

## Installation

### Intel

The Intel microcode package is in the non-free repo, so that has to be enabled
first.

```
# xbps-install -S void-repo-nonfree
```

Install the `intel-ucode` package.

```
# xbps-install -S intel-ucode
```

Rebuild the initramfs matching the kernel. This only has to be done once, the
first time the `intel-ucode` package is installed. If the current bootloader
configuration contains more than one kernel version, the initramfs has to be
rebuilt for each of them.

```
# xbps-reconfigure -f linuxX.X
```

### AMD

The AMD package contains microcode for both AMD CPUs and GPUs. AMD CPUs and GPUs
will automatically load the microcode, no further configuration required.

```
# xbps-install -S linux-firmware-amd
```

## Verification

Performing the following command after a reboot can be used as verification that
the update worked

```
$ grep microcode /proc/cpuinfo
```
