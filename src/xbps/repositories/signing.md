## Signing repositories

Remote repositories **must** be signed, local repositories do not need to be
signed.

The [xbps-rindex(1)](https://man.voidlinux.org/xbps-rindex.1) tool is used to
sign repositories. First initialize the repository metadata with signing
properties (this is only required once).

The private key to sign packages needs to be a PEM encoded RSA key, the key can
be generated with either [ssh-keygen(1)](https://man.voidlinux.org/ssh-keygen.1)
or [openssl(1)](https://man.voidlinux.org/openssl.1) choose one of the following methods.

```
$ ssh-keygen -t rsa -m PEM -f private.pem
```

```
$ openssl genrsa -out private.pem
```

First the public part of the private key has to be added to
the repository metadata, this step is only required once.

```
$ xbps-rindex --privkey private.pem --sign --signedby "I'm Groot" /path/to/repository/dir
```

Afterwards sign one or more packages with the following command:

```
$ xbps-rindex --privkey private.pem --sign-pkg /path/to/repository/dir/*.xbps
```

> Note: Future packages will not be automatically signed.
