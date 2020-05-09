# Common errors

## Errors while updating or installing packages

If there are any errors while updating or installing a new package, make sure
that you are using the latest version of the remote repository index. Running
[xbps-install(1)](https://man.voidlinux.org/xbps-install.1) with the `-S` option
will guarantee that.

### shlib errors

If you get an error with the format:

```
libllvm8-8.0.1_2: broken, unresolvable shlib `libffi.so.6'
```

it is likely that orphan packages which have already been removed from the Void
repos are still installed in your system. This can be solved by running
[xbps-remove(1)](https://man.voidlinux.org/xbps-remove.1) with the `-o` option,
which removes orphan packages.

If you get an error message saying

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
(xbps-static)[./static.md].

## Broken systems

If your system is for some reason broken and can't perform updates or package
installations, using a [statically linked version of xbps](./static.md) to
update and install packages can help you avoid reinstalling the whole system.
