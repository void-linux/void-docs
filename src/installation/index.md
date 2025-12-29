# Installation

This section includes general information about the process of installing Void.
For specific guides, see the "[Advanced Installation](./guides/index.md)"
section.

## Base system requirements

Void can be installed on very low-powered hardware, though we recommend the
following minimums for most installations:

| Architecture | CPU              | RAM   | Storage |
|--------------|------------------|-------|---------|
| x86_64-glibc | x86_64           | 520MB | 700MB   |
| x86_64-musl  | x86_64           | 520MB | 600MB   |
| i686-glibc   | Pentium 4 (SSE2) | 520MB | 700MB   |

Note that Xfce installation images require more resources, and more resources
may be required depending on the software being run.

Void is available on x86_64, i686, aarch64, armv7l, and armv6l architectures.
Both glibc and musl editions are available on all architectures except i686,
where only glibc is available. Void is *not* available for the i386, i486, or
i586 architectures.

Before installing musl Void, please read [the "musl" section](./musl.md) of this
Handbook, so that you are aware of software incompatibilities.

It is highly recommended to have a network connection available during install
to download updates, but this is not required. ISO images contain installation
data on-disk and can be installed without network connectivity.

## Downloading installation media

The most recent live images and rootfs tarballs can be downloaded from
<https://repo-default.voidlinux.org/live/current/>. They can also be downloaded
from [other mirrors](../xbps/repositories/mirrors/index.md). Previous releases
can be found under <https://repo-default.voidlinux.org/live/>, organized by
date.

## Verifying images

Each image release's directory contains two files used to verify the image(s)
you download. First, there is a `sha256sum.txt` file containing image checksums
to verify the integrity of the downloaded images. Second is the `sha256sum.sig`
file, used to verify the authenticity of the checksums.

It is necessary to verify both the image's integrity and authenticity, so it is
recommended that you download both files.

### Verifying digital signature

Prior to using any image, you're strongly encouraged to validate the signatures
on the image to ensure they haven't been tampered with.

Current images are signed using a minisign key that is specific to the release.
If you're on Void already, you can obtain the keys from the `void-release-keys`
package, which will be downloaded using your existing XBPS trust relationship
with your mirror and package signatures. You will also need a copy of
[minisign(1)](https://man.voidlinux.org/minisign.1); on Void, this is provided
by the `minisign` package.

The `minisign` executable is usually provided by a package of the same name, and
can also be installed on Windows, even without WSL or MinGW. Binaries are also
[available from minisign's authors](https://jedisct1.github.io/minisign/).

If you are not currently using Void Linux, it will also be necessary to obtain
the appropriate signing key from our [Git
repository](https://github.com/void-linux/void-packages/tree/master/srcpkgs/void-release-keys/files/).

Once you've obtained the key, you can verify your image with the `sha256sum.sig`
and `sha256sum.txt` files. First, you need to verify the authenticity of the
`sha256sum.txt` file.

The following example demonstrates the verification of the `sha256sum.txt` file
for the 20250202 images with `minisign`:

```
$ minisign -V -p /usr/share/void-release-keys/void-release-20250202.pub -x sha256sum.sig -m sha256sum.txt
Signature and comment signature verified
Trusted comment: This key is only valid for images with date 20250202.
```

### Verifying image integrity

Finally, you need to verify that the checksum for your image matches the one in
the `sha256sum.txt` file. This can be done with the
[sha256(1)](https://man.voidlinux.org/md5.1) utility from the `outils` package,
as demonstrated below for the 20250202 `x86_64` base image:

```
$ sha256 -C sha256sum.txt void-live-x86_64-20250202-base.iso 
(SHA256) void-live-x86_64-20250202-base.iso: OK
```

Alternatively, if the `sha256` utility isn't available to you, you can use
[sha256sum(1)](https://man.voidlinux.org/sha256sum.1):

```
$ sha256sum -c sha256sum.txt --ignore-missing
void-live-x86_64-20250202-base.iso: OK
```

If neither program is available to you, you can compute the SHA256 hash of the
file by hand and compare it to the value contained in `sha256sum.txt`.

If the verification process does not produce the expected "OK" status, **do not
use it**! Please alert the Void Linux team of where you got the image and how
you verified it, and we will follow up on it.
