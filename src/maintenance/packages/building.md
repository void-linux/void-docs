# Package building

The first step is to building xbps packages from source is to clone the
`void-packages` [git(1)](https://man.voidlinux.org/git.1) repository.

```
$ git clone https://github.com/void-linux/void-packages.git
Cloning into 'void-packages'...
remote: Counting objects: 398517, done.
remote: Total 398517 (delta 0), reused 1 (delta 0), pack-reused 398516
Receiving objects: 100% (398517/398517), 151.18 MiB | 5.10 MiB/s, done.
Resolving deltas: 100% (227465/227465), done.
```

After cloning the repository it is necessary to setup the build environment by
bootstrapping a container/chroot using the `xbps-src` script.

To bootstrap a build environment using binary packages for the same architecture
your host uses use `binary-bootstrap`.

```
$ ./xbps-src binary-bootstrap
=> Installing bootstrap from binary package repositories...
[...]
=> Installed bootstrap successfully!
```

If you have the time and you want to build the bootstrap from source too, use
the `bootstrap` command.

```
$ ./xbps-src bootstrap
```

In case you want to compile `i686` packages on your `x86_64` machine you can use
one of the bootstrap commands with a different masterdir and the target
architecture as second argument.

```
$ ./xbps-src -m masterdir-i686 binary-bootstrap i686
=> Installing bootstrap from binary package repositories...
[...]
=> Installed bootstrap successfully!
```

You can now build packages using the `pkg` command.

```
$ ./xbps-src pkg vim
[...]
```

Or in case you bootstrapped a different masterdir for another native
architecture.

```
$ ./xbps-src -m masterdir-i686 pkg vim
[...]
```

# Contributing

You can find an extensive contributing guide
[CONTRIBUTING.md](https://github.com/void-linux/void-packages/blob/master/CONTRIBUTING.md)
in the `void-packages` git repository.

