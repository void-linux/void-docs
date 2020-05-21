# Updating

Like any other system, it is important to keep Void up-to-date. Use
[xbps-install(1)](https://man.voidlinux.org/xbps-install.1) to update:

```
# xbps-install -Su
```

XBPS must use a separate transaction to update itself. If your first update
includes the package `xbps`, you will need to run an additional update for the
rest of the system.

## Restarting Services

XBPS does not restart services when they are updated. This task is left to the
administrator, so they can orchestrate maintenance windows, ensure reasonable
backup capacity, and generally be present for service upgrades.

To find processes running different versions than are present on disk, use the
`xcheckrestart` tool provided by the `xtools` package:

```
$ xcheckrestart
11339 /opt/google/chrome/chrome (deleted) (google-chrome)
```

`xcheckrestart` will print out the PID, path to the executable, status of the
path that was launched (almost always `deleted`) and the process name.

`xcheckrestart` can and should be run as an unprivileged user.

## Kernel Panic After Update

If you get a kernel panic after an update, it is likely your system ran out of
space in `/boot`. Refer to "[Removing old
kernels](../config/kernel.md#removing-old-kernels)" for further information.
