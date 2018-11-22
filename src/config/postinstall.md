# Post Installation

This page provides a list of basic functions to perform after installing a Void
system.

### Updates

The first thing you should do on a new system is check for and install updates.
This is especially important if you installed from the `Local` packages on a
live install image as it is highly likely that some of your packages will be out
of date. To update your repository information and update all installed
packages, run the command:

```
# xbps-install -Su
```

> Note: XBPS must use a seperate transaction to update itself.  If
> your first update includes the package `xbps`, you will need to run
> an additional update for the rest of the system.
