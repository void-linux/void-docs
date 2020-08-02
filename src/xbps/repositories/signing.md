# Signing Repositories

Remote repositories **must** be signed. Local repositories do not need to be
signed.

The [xbps-rindex(1)](https://man.voidlinux.org/xbps-rindex.1) tool is used to
sign repositories.

The private key for signing packages needs to be a PEM-encoded RSA key. The key
can be generated with either
[ssh-keygen(1)](https://man.voidlinux.org/ssh-keygen.1) or
[openssl(1)](https://man.voidlinux.org/openssl.1):

```
$ ssh-keygen -t rsa -m PEM -f private.pem
```

```
$ openssl genrsa -out private.pem
```

Once the key is generated, the public part of the private key has to be added to
the repository metadata. This step is required only once.

```
$ xbps-rindex --privkey private.pem --sign --signedby "I'm Groot" /path/to/repository/dir
```

Then sign one or more packages with the following command:

```
$ xbps-rindex --privkey private.pem --sign-pkg /path/to/repository/dir/*.xbps
```

Note that future packages will not be automatically signed.
