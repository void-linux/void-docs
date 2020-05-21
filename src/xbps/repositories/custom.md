# Custom Repositories

Void supports user created repositories available locally, or remotely. This is
only recommended for serving custom packages created personally, or packages
from another trusted source. The Void project does not support *any* third party
package repositories, and the use of third party software packages poses very
serious security concerns, and risks serious damage your system.

## Adding custom repositories

To add custom repositories create a file in `/etc/xbps.d` with the format:

```
repository=<URL>
```

Where `<URL>` is either a local directory or a URL to a remote repository.

For example, to define a remote repository:

```
# echo 'repository=http://my.domain.com/repo' > /etc/xbps.d/my-remote-repo.conf
```

> Note: Remote repositories need to be [signed](./signing.md).
> [xbps-install(1)](https://man.voidlinux.org/xbps-install.1) refuses to install
> packages from remote repositories if they are not signed.

Or, to define a local repository:

```
# echo 'repository=/path/to/repo' > /etc/xbps.d/my-local-repo.conf
```
