# Configuring a New Printer

First, ensure that the CUPS daemon is enabled and running:

```
# ln -s /etc/sv/cupsd /var/service/
# sv status cupsd
```

Then, power the printer on and connect it.

Now that the drivers are installed, CUPS is running, and the printer is
connected, it is time to configure the printer using CUPS.

## Web interface

To configure the printer using the CUPS web interface, navigate to
<http://localhost:631> in a browser. Under the "Administration" tab, select
"Printers > Add Printer".

## Command line

The [lpadmin(8)](https://man.voidlinux.eu/lpadmin.8) tool may be used to
configure a printer using the command line.

## Graphical interface

To configure the printer using a native GUI interface, run the following:

```
# system-config-printer
```

This command does not need to be run as root if PolicyKit is in use and
`cups-pk-helper` is installed.

Other graphical printer configuration tools are typically shipped as part of a
desktop environment, such as KDE, GNOME, or XFCE.

