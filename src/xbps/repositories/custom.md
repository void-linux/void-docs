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

Remote repositories need to be [signed](./signing.md).
[xbps-install(1)](https://man.voidlinux.org/xbps-install.1) refuses to install
packages from remote repositories if they are not signed.

To define a local repository:

```
# echo 'repository=/path/to/repo' > /etc/xbps.d/my-local-repo.conf
```
