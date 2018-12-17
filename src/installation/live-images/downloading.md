# Downloading Images

The most recent live images can be downloaded from
<https://alpha.de.repo.voidlinux.org/live/current/>. Previous releases can be
found under <https://alpha.de.repo.voidlinux.org/live/>, organized by date.

## Verify images

Each image releases's directory contains two files used to verify the image(s)
you download. First, there is a `sha256sums.txt` file containing image checksums
to verify the integrity of the downloaded images. Second is the
`sha256sums.txt.sig` file, used to verify the authenticity of the checksums.

We want to verify both the image's integrity and authenticity, so for this, we
want to download both files:

```
$ wget http://alpha.de.repo.voidlinux.org/live/current/sha256sums.txt{,.sig}
```

### Verify image integrity

You can verify the integrity of a downloaded file using
[sha256sum(1)](https://man.voidlinux.org/sha256sum.1) with the `sha256sums.txt`
file we downloaded above. The following sha256sum command will check (`-c`) the
integrity of only the image(s) you've downloaded:

```
$ sha256sum -c --ignore-missing sha256sums.txt
void-live-x86_64-musl-20170220.iso: OK
```

This verifies that the image is not corrupt.

### Verify image authenticity

To verify that the downloaded `sha256sums.txt` file is the one that the Void
Linux maintainers published and signed, we use PGP. For this, we need the
`sha256sums.txt.sig` downloaded above.

The file is signed with the Void Images key:

- **Signer:** Void Linux Image Signing Key
   <[images@voidlinux.eu](mailto:images@voidlinux.eu)>
- **KeyID:** `B48282A4`
- **Fingerprint:** `CF24 B9C0 3809 7D8A 4495 8E2C 8DEB DA68 B482 82A4`

You can use [gpg(1)](https://man.voidlinux.org/gpg.1) to receive the key from a
keyserver using the command in the following example. You can also download it
from <https://alpha.de.repo.voidlinux.org/live/current/void_images.asc>.

```
$ gpg --recv-keys B48282A4
gpg: requesting key B48282A4 from hkp server keys.gnupg.net
gpg: key B48282A4: public key "Void Linux Image Signing Key <images@voidlinux.eu>" imported
gpg: no ultimately trusted keys found
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
```

With the key stored locally, you can use
[gpg(1)](https://man.voidlinux.org/gpg.1) verify the signature of
`sha256sums.txt` using the `sha256sums.txt.sig` file:

```
$ gpg --verify sha256sums.txt.sig 
gpg: assuming signed data in `sha256sums.txt'
gpg: Signature made Sat Oct  7 17:18:35 2017 CDT using RSA key ID B48282A4
gpg: Good signature from "Void Linux Image Signing Key <images@voidlinux.eu>"
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: CF24 B9C0 3809 7D8A 4495  8E2C 8DEB DA68 B482 82A4
```

This verifies that the signature for the checksums is authentic. In turn, we can
assert that the downloaded images are also authentic if their checksums match.
