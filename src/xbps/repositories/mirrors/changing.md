# Changing Mirrors

Each repository has a file defining the URL for the mirror used. For official
repositories, these files are installed by the package manager in
`/usr/share/xbps.d`, but if duplicate files are found in `/etc/xbps.d`, those
values are used instead.

## xmirror

To easily modify the currently selected mirror,
[xmirror(1)](https://man.voidlinux.org/xmirror.1) (from the `xmirror` package)
can be used. This utility takes care of all steps for updating the selected
mirror.

## Manual Method

Alternatively, this can be done manually:

To modify mirror URLs cleanly, copy all the repository configuration files to
`/etc/xbps.d` and change the URLs in each copied repository file.

```
# mkdir -p /etc/xbps.d
# cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d/
# sed -i 's|https://repo-default.voidlinux.org|<repository>|g' /etc/xbps.d/*-repository-*.conf
```

After changing the URLs, you must synchronize xbps with the new mirrors:

```
# xbps-install -S
```

You should see the new repository URLs while synchronizing. You can also use
`xbps-query` to verify the repository URLs, but only after they have been
synchronized:

```
$ xbps-query -L
 9970 https://repo-default.voidlinux.org/current (RSA signed)
   27 https://repo-default.voidlinux.org/current/multilib/nonfree (RSA signed)
 4230 https://repo-default.voidlinux.org/current/multilib (RSA signed)
   47 https://repo-default.voidlinux.org/current/nonfree (RSA signed)
 5368 https://repo-default.voidlinux.org/current/debug (RSA signed)
```

Remember that repositories added afterwards will also need to be changed, or
they will use the default mirror.
