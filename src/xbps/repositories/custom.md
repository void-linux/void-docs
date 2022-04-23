# Custom Repositories

Void supports user-created repositories, both local and remote. This is only
recommended for serving custom packages created personally, or packages from
another trusted source. The Void project does not support *any* third-party
package repositories - the use of third-party software packages poses very
serious security concerns, and risks serious damage your system.

## Adding custom repositories

To add a custom repository, create a file in `/etc/xbps.d`, with the contents:

```
repository=<URL>
```

where `<URL>` is either a local directory or a URL to a remote repository.

For example, to define a remote repository:

```
# echo 'repository=http://my.domain.com/repo' > /etc/xbps.d/my-remote-repo.conf
```

Remote repositories need to be [signed](#signing-repositories-and-packages).
[xbps-install(1)](https://man.voidlinux.org/xbps-install.1) refuses to install
packages from remote repositories if they are not signed.

To define a local repository:

```
# echo 'repository=/path/to/repository/dir' > /etc/xbps.d/my-local-repo.conf
```

## Signing repositories and packages

Remote repositories **must** be signed. Local repositories do not need to be
signed.

The private key for signing packages needs to be a PEM-encoded RSA key. The key
can be generated with either
[ssh-keygen(1)](https://man.voidlinux.org/ssh-keygen.1) or
[openssl(1)](https://man.voidlinux.org/openssl.1):

```
$ ssh-keygen -t rsa -b 4096 -m PEM -f private.pem
```

```
$ openssl genrsa -out private.pem 4096
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

> Packages added to the repository index later will not be automatically signed.
> Repeat the previous command to sign newly-added packages.

## Manually maintaining repositories

In many cases, `xbps-src` will handle the creation and addition of packages to a
repository index, but the
[xbps-rindex(1)](https://man.voidlinux.org/xbps-rindex.1) utility can also be
used to manually manage xbps repositories. This can be useful if maintaining a
repository of custom-built packages or using non-default build options.

> When creating a repository for another architecture, prepend `xbps-rindex`
> commands with `XBPS_TARGET_ARCH`. For example: `XBPS_TARGET_ARCH=armv7l-musl
> xbps-rindex ...`

### Adding packages to the repository index

For xbps to know about a package, it must be added to the repository's index.
Packages can be added to the repository index with `--add`:

```
$ xbps-rindex --add /path/to/repository/dir/*.xbps
```

### Cleaning the repository index

When adding new versions of packages, `--remove-obseletes` can be used to purge
the old version from both the repository index and remove the `.xbps` and `.sig`
files from disk:

```
$ xbps-rindex --remove-obseletes /path/to/repository/dir
```

When removing a package from the repository, first remove the files from disk,
then use `--clean` to remove the package from the repository index:

```
$ xbps-rindex --clean /path/to/repository/dir
```

### Serving remote repositories

Remote repositories can be served by any HTTP daemon, like nginx or lighttpd, by
configuring it to serve `/path/to/repository/dir` on the domain and path
desired.
