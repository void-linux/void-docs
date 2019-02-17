# Static XBPS

In rare cases, it is possible to break the system sufficiently that XBPS can no
longer function. This usually happens while trying to do unsupported things with
libc, but can also happen when an update contains a corrupt glibc archive or
otherwise fails to unpack and configure fully.

In these cases it is possible to recover your system with a separate, statically
compiled copy of XBPS.

## Obtaining static XBPS

Statically compiled versions of XBPS are available in all mirrors in the static/
directory. The link below points to the static copies on the primary mirror in
Germany:

<https://alpha.de.repo.voidlinux.org/static>

Download and unpack the latest version, or the version that matches the broken
copy on your system (with a preference for the latest copy).

## Using static XBPS

The tools in the static set are identical to the normal ones found on most
systems. The only distinction is that these tools are statically linked to the
musl C library, and should work on systems where nothing else does. In systems
where the platform can no longer boot, it is recommended to chroot in with Void
installation media and use the static tools from there, as it is unlikely that
even a shell will work correctly on the target system.
