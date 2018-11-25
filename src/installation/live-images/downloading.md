# Downloading Images

Live images can be downloaded from
<https://alpha.de.repo.voidlinux.org/live/current/>.

### Verifying integrity

The image release directories contain a `sha256sums.txt` and a
`sha256sums.txt.asc` file to verify the integrity of the downloaded images.

```
$ wget http://alpha.de.repo.voidlinux.org/live/current/sha256sums.txt{,.sig}
```

You can now verify the integrity of downloaded file using
[sha256sum(1)](https://man.voidlinux.org/sha256sum.1).

```
$ sha256sum -c --ignore-missing sha256sums.txt
void-live-x86_64-musl-20170220.iso: OK
```

This just makes sure that the file was not corrupted while downloading.

To verify that the downloaded files are the ones that the Void Linux maintainers
published and signed you can use pgp.

The file is signed with the Void Images key:

- Signer: Void Linux Image Signing Key
   <[images@voidlinux.eu](mailto:images@voidlinux.eu)>
- KeyID: `B48282A4`
- Fingerprint: `CF24 B9C0 3809 7D8A 4495 8E2C 8DEB DA68 B482 82A4`

You can use [gpg(1)](https://man.voidlinux.org/gpg.1) to receive the key from a
keyserver using the following command or download it from
<https://alpha.de.repo.voidlinux.org/live/current/void_images.asc>.

```
$ gpg --recv-keys B48282A4
gpg: requesting key B48282A4 from hkp server keys.gnupg.net
gpg: key B48282A4: public key "Void Linux Image Signing Key <images@voidlinux.eu>" imported
gpg: no ultimately trusted keys found
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)

```

You can now verify the signature of the `sha256sums.txt` file with
[gpg(1)](https://man.voidlinux.org/gpg.1).

```
$ gpg --verify sha256sums.txt.sig 
gpg: assuming signed data in `sha256sums.txt'
gpg: Signature made Sat Oct  7 17:18:35 2017 CDT using RSA key ID B48282A4
gpg: Good signature from "Void Linux Image Signing Key <images@voidlinux.eu>"
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: CF24 B9C0 3809 7D8A 4495  8E2C 8DEB DA68 B482 82A4
```

