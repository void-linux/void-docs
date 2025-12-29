# musl

[musl](https://musl.libc.org/) is a libc implementation which strives to be
lightweight, fast, simple, and correct.

Void officially supports musl by using it in its codebase for all target
platforms (although binary packages are not available for i686). Additionally,
all compatible packages in our official repositories are available with
musl-linked binaries in addition to their glibc counterparts.

Currently, there are nonfree and debug sub-repositories for musl, but no
multilib sub-repo.

## Incompatible software

musl practices very strict standards compliance. Many commonly used
platform-specific extensions are not present. Because of this, it is common for
software to need modification to compile and/or function properly. Void
developers work to patch such software and hopefully get portability/correctness
changes accepted into the upstream projects.

Proprietary software usually supports only glibc systems, though sometimes such
applications are available as
[flatpaks](../config/external-applications.md#flatpak) and can be run on a musl
system. In particular, the [proprietary NVIDIA
drivers](../config/graphical-session/graphics-drivers/nvidia.md#nvidia-proprietary-driver)
do not support musl, which should be taken into account when evaluating hardware
compatibility.

### glibc chroot

Software requiring glibc can be run in a glibc
[chroot](../config/containers-and-vms/chroot.md).
