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
xbps-install -Suv
```

> Note: if the xbps package has been updated it will only update that package
> and the dependencies. You may need to run the update command twice to get all
> updates.

