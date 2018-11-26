# Post Installation

This page contains a common set of tasks to take after installing Void on a new
machine.

## Updates

Installation media contains a snapshot of packages from the day it was made.
After installing and connecting the the network, new systems should be updated:

```
# xbps-install -Su
```

This will ensure that your system has applicable security patches and software
upgrades that happened after the installation media was created.

> Note: XBPS must use a separate transaction to update itself. If your first
> update includes the package `xbps`, you will need to run an additional update
> for the rest of the system.
