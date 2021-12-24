# Live Installers

Void provides live images containing a base set of utilities useful for
installing and/or repairing systems. Images can be found on the
[mirrors](../../xbps/repositories/mirrors/index.md) for either `glibc` or `musl`
systems on `x86_64` systems, and for `glibc` on `i686` ones. Users of other
architectures will need to perform a [manual installation](../guides/index.md).

## Base Image

The base image contains just enough for a usable Void system, with utilities for
basic hardware and network configuration included. The installation can be
performed online, which will download the latest package versions versions, or
offline, which will use the versions of packages available on the installation
medium.

## XFCE Desktop Image

Void also offers an XFCE image. The live environment includes a desktop
environment, web browser, and basic desktop applications, but the installation
procedure is the same. Choose the `Local` package source in void-installer to
include these extra packages on the new system. A network install may be
performed from this image, but only the base system will be installed in this
case.
