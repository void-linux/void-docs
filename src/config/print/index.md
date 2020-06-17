# Printing

CUPS (Common Unix Printing System) is the supported mechanism for connecting to
printers on Void Linux.

As prerequisites, install the `cups` package and enable the `cupsd` service.
Wait until the service is marked available.

## Installing Printing Drivers

If the printer is being accessed over the network and supports PostScript or
PCL, CUPS alone should be sufficient. However, additional driver packages are
necessary for local printer support. The `cups-filters` package provides driver
support for CUPS.

Depending on the hardware in question, additional drivers may be necessary.

Some CUPS drivers contain proprietary or binary-only extensions. These are
available only in the nonfree repository, and sometimes only for specific
architectures.

### Gutenprint drivers

Gutenprint provides support for many printers. These drivers are contained in
the `gutenprint` package.

### HP drivers

Printers from Hewlett-Packard require the `hplip` package.

Running the following command will guide you through the driver installation
process. The default configuration selections it suggests are typically
sufficient.

```
# hp-setup -i
```

### Brother drivers

For Brother printer support, install the foomatic drivers, which are contained
in the `foomatic-db` and `foomatic-db-nonfree` packages.

## Configuring a New Printer

CUPS provides a web interface and command line tools that can be used to
configure printers. Additionally, various native GUI options are available and
may be better suited, depending on the use-case.

### Web interface

To configure the printer using the CUPS web interface, navigate to
<http://localhost:631> in a browser. Under the "Administration" tab, select
"Printers > Add Printer".

### Command line

The [lpadmin(8)](https://man.voidlinux.org/lpadmin.8) tool may be used to
configure a printer using the command line.

### Graphical interface

The `system-config-printer` package offers simple and robust configuration of
new printers. Install and invoke it:

```
# system-config-printer
```

Normally this tool requires root privileges. However, if you are using
PolicyKit, you can install the `cups-pk-helper` package to allow unprivileged
users to use `system-config-printer`.

While `system-config-printer` is shown here, your desktop environment may have a
native printer dialog, which may be found by consulting the documentation for
your DE.

## Troubleshooting

### USB printer not shown

The device URI can be found manually by running:

```
# /usr/lib/cups/backend/usb
```
