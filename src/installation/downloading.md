# Downloading Installation Media

The most recent live images and rootfs tarballs can be downloaded from
<https://alpha.de.repo.voidlinux.org/live/current/>. They can also be downloaded
from [other mirrors](../xbps/repositories/mirrors/index.md). Previous releases
can be found under <https://alpha.de.repo.voidlinux.org/live/>, organized by
date.

## Verifying images

Each image release's directory contains two files used to verify the image(s)
you download. First, there is a `sha256.txt` file containing image checksums to
verify the integrity of the downloaded images. Second is the `sha256.sig` file,
used to verify the authenticity of the checksums.

We want to verify both the image's integrity and authenticity, so for this, we
want to download both files:

```
$ wget http://alpha.de.repo.voidlinux.org/live/current/sha256.{txt,sig}
```

### Verifying image integrity

You can verify the integrity of a downloaded file using
[sha256sum(1)](https://man.voidlinux.org/sha256sum.1) with the `sha256.txt` file
downloaded above. The following sha256sum command will check (`-c`) the
integrity of only the image(s) you've downloaded:

```
$ sha256sum -c --ignore-missing sha256.txt
void-live-x86_64-musl-20170220.iso: OK
```

This verifies that the image is not corrupt.

### Verifying digital signature

Prior to using any image you're strongly encouraged to validate the signatures
on the image to ensure they haven't been tampered with.

Current images are signed using a signify key that is specific to the release.
If you're on Void already, you can obtain the keys from the `void-release-keys`
package, which will be downloaded using your existing XBPS trust relationship
with your mirror. You will also need a copy of
[signify(1)](https://man.voidlinux.org/signify.1); on Void this is provided by
the `outils` package.

If you are not currently using Void Linux you will need to obtain a copy of
signify by other means, and the appropriate signing key from our git repository
[here](https://github.com/void-linux/void-packages/tree/master/srcpkgs/void-release-keys/files/).

Once you've obtained the key, you can verify your image with the sha256.sig
file. An example is shown here verifying the GCP musl filesystem from the
20191109 release:

```
$ signify -C -p /etc/signify/void-release-20191109.pub -x sha256.sig void-GCP-musl-PLATFORMFS-20191109.tar.xz
Signature Verified
void-GCP-musl-PLATFORMFS-20191109.tar.xz: OK
```

If the verification process does not spit out the expected "OK" status then do
not use it! Please alert the Void Linux team of where you got the image and how
you verified it and we will follow up.
