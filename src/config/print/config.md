# Configuring a New Printer

Enable the CUPS service:

```
# ln -s /etc/sv/cupsd /var/service/
```

Wait until the service is marked available:

```
# sv status cupsd
```

Then, power the printer on and connect it.

There are multiple ways to configure a CUPS printer.  The standard is
to use the web interface, but other mechanisms exist as well.

## Web interface

To configure the printer using the CUPS web interface, navigate to
<http://localhost:631> in a browser. Under the "Administration" tab, select
"Printers > Add Printer".

## Command line

The [lpadmin(8)](https://man.voidlinux.org/lpadmin.8) tool may be used to
configure a printer using the command line.

## Graphical interface

To configure the printer using a native GUI interface, run the following:

```
# xbps-install system-config-printer
# system-config-printer
```

This command does not need to be run as root if PolicyKit is in use and
`cups-pk-helper` is installed.

While `system-config-printer` is shown here, your desktop environment
may have a native printer dialog which may be found by consulting the
documentation for your DE.
