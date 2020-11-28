# Common Issues

## Verifying RSA keys

If you are installing Void for the first time or the Void RSA key has changed,
[xbps-install(1)](https://man.voidlinux.org/xbps-install.1) might report:

```
<repository> repository has been RSA signed by <rsa_fingerprint>
```

To verify the signature, ensure the `<rsa_fingerprint>` matches one of the
fingerprints in both
[void-packages](https://github.com/void-linux/void-packages/tree/master/common/repo-keys)
and [void-mklive](https://github.com/void-linux/void-mklive/tree/master/keys).

## Errors while updating or installing packages

If there are any errors while updating or installing a new package, make sure
that you are using the latest version of the remote repository index. Running
[xbps-install(1)](https://man.voidlinux.org/xbps-install.1) with the `-S` option
will guarantee that.

### "Operation not permitted"

An "Operation not permitted" error, such as:

```
ERROR: [reposync] failed to fetch file https://alpha.de.repo.voidlinux.org/current/nonfree/x86_64-repodata': Operation not permitted
```

can be caused by your system's date and/or time being incorrect. Ensure your
[date and time](../../config/date-time.md) are correct.

### "Not Found"

A "Not Found" error, such as:

```
ERROR: [reposync] failed to fetch file `https://alpha.de.repo.voidlinux.org/current/musl/x86_64-repodata': Not Found
```

usually means your XBPS configuration is pointing to the wrong repositories for
your system. Confirm that your [xbps.d(5)](https://man.voidlinux.org/xbps.d.5)
files refer to [the correct repositories](../repositories/index.md).

### shlib errors

An "unresolvable shlib" error, such as:

```
libllvm8-8.0.1_2: broken, unresolvable shlib `libffi.so.6'
```

is probably due to outdated or orphan packages. To check for outdated packages,
simply try to [update your system](../index.md#updating). Orphan packages, on
the other hand, have been removed from the Void repos, but are still installed
on your system; they can be removed by running
[xbps-remove(1)](https://man.voidlinux.org/xbps-remove.1) with the `-o` option.

If you get an error message saying:

```
Transaction aborted due to unresolved shlibs
```

the repositories are in the staging state, which can happen due to large builds.
The solution is to wait for the builds to finish. You can view the builds'
progress in the [Buildbot's Waterfall
Display](https://build.voidlinux.org/waterfall).

### repodata errors

In March 2020, the compression format used for the repository data (repodata)
was changed from gzip to zstd. If XBPS wasn't updated to version `0.54`
(released June 2019) or newer, it is not possible to update the system with it.
Unfortunately, there isn't an error message for this case, but it can be
detected by running `xbps-install` with the `-Sd` flags. The debug message for
this error is shown below.

```
[DEBUG] [repo] `//var/db/xbps/https___alpha_de_repo_voidlinux_org_current/x86_64-repodata' failed to open repodata archive Invalid or incomplete multibyte or wide character
```

In this situation, it is necessary to follow the steps in
[xbps-static](./static.md).

## Broken systems

If your system is for some reason broken and can't perform updates or package
installations, using a [statically linked version of xbps](./static.md) to
update and install packages can help you avoid reinstalling the whole system.
