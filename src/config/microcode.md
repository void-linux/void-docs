# Microcode

Microcode is loaded onto the CPU or GPU at boot by the BIOS, but can be replaced
later by the OS itself. An update to microcode can allow a CPU's or GPU's
behavior to be modified to work around certain yet to be discovered bugs,
without the need to replace the hardware.

## Installation

### Intel

Install the Intel microcode package, `intel-ucode`. This package is in the
nonfree repo, which has to be
[enabled](../xbps/repositories/official/nonfree.md). After installing this
package, it is necessary to regenerate your
[initramfs](./kernel.md#kernel-hooks). For subsequent updates, the microcode
will be added to the initramfs automatically.

### AMD

Install the AMD package, `linux-firmware-amd`, which contains microcode for both
AMD CPUs and GPUs. AMD CPUs and GPUs will automatically load the microcode, no
further configuration required.

## Verification

The `/proc/cpuinfo` file has some information under `microcode` that can be used
to verify the microcode update.
