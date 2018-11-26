# Updating

Like any other system it is important to keep Void Linux up to date.

In general Void should be updated with an XBPS invocation:

```
# xbps-install -Su
```

> Note: XBPS must use a separate transaction to update itself. If your first
> update includes the package `xbps`, you will need to run an additional update
> for the rest of the system.

## Restarting Services

If you are installing Void in production or otherwise have long lived services,
its important to note that XBPS does not restart services when they are updated.
This task is left to the administrator so they can orchestrate maintenance
windows, ensure reasonable backup capacity, and generally be present for service
upgrades.

To find processes running different versions than are present on disk, use the
`xcheckrestart` tool provided by the `xtools` package:

```
# xbps-install -S xtools
```

```
$ xcheckrestart
11339 /opt/google/chrome/chrome (deleted) (google-chrome)
```

`xcheckrestart` will print out the PID, path to the executable, status of the
path that was launched (almost always deleted) and the process name.

`xcheckrestart` can and should be run as an unprivileged user.

## Kernel Panic after Update

Your system likely ran out of space in `/boot`. XBPS installs kernels and
requests that hooks such as DKMS and Dracut be run, but it doesn't remove
kernels that are obsolete. This is left as a task for the administrator to
permit the retention of obsolete but still booted or known working kernels.

Remove kernels with [vkpurge(8)](https://man.voidlinux.org/vkpurge.8).
