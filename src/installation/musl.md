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

Musl practices very strict and minimal standard compliance. Many commonly used
platform-specific extensions are not present. Because of this, it is common for
software to need modification to compile and/or function properly. Void
developers work to patch such software and hopefully get portability/correctness
changes accepted into the upstream projects.

Proprietary software rarely supports non-glibc libc implementations, although
sometimes these applications are available as [flatpaks](https://flatpak.org/),
which provide their own libc in the image.

### glibc chroot

Software requiring glibc can be run in a glibc
[chroot](../config/chroot-rootfs.md].
