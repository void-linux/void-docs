# Installation

This section includes general information about the process of installing Void.
For specific guides, see the "[Advanced Installation](./guides/index.md)"
section.

## Base system requirements

Void can be installed on very minimalist hardware, though we recommend the
following minimums for most installations:

| Architecture | CPU              | RAM  | Storage |
|--------------|------------------|------|---------|
| x86_64-glibc | x86_64           | 96MB | 700MB   |
| x86_64-musl  | x86_64           | 96MB | 600MB   |
| i686-glibc   | Pentium 4 (SSE2) | 96MB | 700MB   |

Note that xfce image installations require more resources.

Void provides build profiles for the architectures listed at
<https://github.com/void-linux/void-packages/tree/master/common/build-profiles>.
Out of those, currently

- `x86_64*`, `i686` are natively compiled and their test suite run in CI
- `aarch64*`, `armv7l*`, `armv6l*` are cross-compiled, with no tests run in CI.

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

It is necessary to verify both the image's integrity and authenticity. It is,
therefore, recommended that you download both files.

### Verifying image integrity

You can verify the integrity of a downloaded file using
[sha256sum(1)](https://man.voidlinux.org/sha256sum.1) with the `sha256sum.txt`
file downloaded above. The following command will check the integrity of only
the image(s) you have downloaded:

```
$ sha256sum -c --ignore-missing sha256sum.txt
void-live-x86_64-musl-20170220.iso: OK
```

This verifies that the image is not corrupt.

### Verifying digital signature

Prior to using any image you're strongly encouraged to validate the signatures
on the image to ensure they haven't been tampered with.

Current images are signed using a minisign key that is specific to the release.
If you're on Void already, you can obtain the keys from the `void-release-keys`
package, which will be downloaded using your existing XBPS trust relationship
with your mirror and package signatures. You will also need a copy of
[minisign(1)](https://man.voidlinux.org/minisign.1); on Void, this is provided
by the `minisign` package.

The `minisign` executable is usually provided by a package of the same name, and
can also be installed on Windows, even without WSL or MinGW.

If you are not currently using Void Linux, it will also be necessary to obtain
the appropriate signing key from our Git repository
[here](https://github.com/void-linux/void-packages/tree/master/srcpkgs/void-release-keys/files/).

Once you've obtained the key, you can verify your image with the `sha256sum.sig`
and `sha256sum.txt` files. First, you need to verify the authenticity of the
`sha256sum.txt` file.

The following example demonstrates the verification of the `sha256sum.txt` file
for the 20230628 images with `minisign`:

```
$ minisign -V -p /usr/share/void-release-keys/void-release-20230628.pub -x sha256sum.sig -m sha256sum.txt
Signature and comment signature verified
Trusted comment: This key is only valid for images with date 20230628.
```

Finally, you need to verify that the checksum for your image matches the one in
the `sha256sum.txt` file. This can be done with the
[sha256(1)](https://man.voidlinux.org/md5.1) utility from the `outils` package,
as demonstrated below for the 20230628 `x86_64` base image:

```
$ sha256 -C sha256sum.txt void-live-x86_64-20230628-base.iso 
(SHA256) void-live-x86_64-20230628-base.iso: OK
```

Alternatively, if the `sha256` utility isn't available to you, you can use
[sha256sum(1)](https://man.voidlinux.org/sha256sum.1):

```
$ sha256sum -c sha256sum.txt --ignore-missing
void-live-x86_64-20230628-base.iso: OK
```

If neither program is available to you, you can compute the SHA256 hash of the
file and compare it to the value contained in `sha256sum.txt`.

If the verification process does not produce the expected "OK" status, do not
use it! Please alert the Void Linux team of where you got the image and how you
verified it, and we will follow up on it.
