# Configuring a New Printer

CUPS provides a web interface and command line tools that can be used to
configure printers. Additionally, various native GUI options are available and
may be better suited depending on the use case.

## Web interface

To configure the printer using the CUPS web interface, navigate to
<http://localhost:631> in a browser. Under the "Administration" tab, select
"Printers > Add Printer".

## Command line

The [lpadmin(8)](https://man.voidlinux.org/lpadmin.8) tool may be used to
configure a printer using the command line.

## Graphical interface

The `system-config-printer` package offers simple and robust configuration of
new printers. Install and invoke it:

```
# system-config-printer
```

Normally this tool requires root privileges. However if you are using PolicyKit,
you can install the `cups-pk-helper` package to allow unprivileged users to use
`system-config-printer`.

While `system-config-printer` is shown here, your desktop environment may have a
native printer dialog which may be found by consulting the documentation for
your DE.

## Troubleshooting

### USB printer not shown

The device URI can be found manually by running:

```
# /usr/lib/cups/backend/usb
```
