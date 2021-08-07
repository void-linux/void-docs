# Changing Mirrors

Each repository has a file defining the URL for the mirror used. For official
repositories, these files are installed by the package manager in
`/usr/share/xbps.d`, but if duplicate files are found in `/etc/xbps.d`, those
values are used instead.

To modify mirror URLs cleanly, copy all the repository configuration files to
`/etc/xbps.d` and change the URLs in each copied repository file.

```
# mkdir -p /etc/xbps.d
# cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d/
# sed -i 's|<repository>|https://alpha.us.repo.voidlinux.org|g' /etc/xbps.d/*-repository-*.conf
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
 9970 https://alpha.de.repo.voidlinux.org/current (RSA signed)
   27 https://alpha.de.repo.voidlinux.org/current/multilib/nonfree (RSA signed)
 4230 https://alpha.de.repo.voidlinux.org/current/multilib (RSA signed)
   47 https://alpha.de.repo.voidlinux.org/current/nonfree (RSA signed)
 5368 https://alpha.de.repo.voidlinux.org/current/debug (RSA signed)
```

Remember that repositories added afterwards will also need to be changed, or
they will use the default mirror.
