# Installing Printing Packages

The CUPS daemon can be installed by running:

```
# xbps-install -S cups
```

## Drivers

If the printer is being accessed over the network, CUPS alone should be
sufficient. However, additional driver packages are necessary for local
printer support. The `cups-filters` package provides driver support for CUPS;
it can be installed by running:

```
# xbps-install -S cups-filters
```

Depending on the hardware in question, additional drivers may be necessary.

### Gutenprint drivers

Gutenprint provides support for a considerable amount of printers. These
drivers can be installed by running:

```
# xbps-install -S gutenprint
```

### HP drivers

Printers from Hewlett-Packard require the `hplip` package, which can be
installed by running:

```
# xbps-install -S hplip
```

Running the following command will guide you through the driver installation
process. The default configuration selections it suggests are typically
sufficient.

```
# hp-setup -i
```

### Brother drivers

For Brother printer support, install the foomatic drivers by running:

```
# xbps-install -S foomatic-db foomatic-db-nonfree
```

Note that these drivers are available in the non-free repositories only.

## Configuration Software

CUPS has a built-in web interface that can be used to configure printers, but
native GUI options exist and may be better suited.

One such option is the `system-config-printer` package, which can be installed
by running:

```
# xbps-install -S system-config-printer
```

Normally this tool would require root priveleges to configure printers, but
unprivileged access through PolicyKit can be achieved with a helper. This
helper can be installed by running:

```
# xbps-install -S cups-pk-helper
```
