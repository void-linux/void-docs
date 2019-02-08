# Installing Printing Drivers

If the printer is being accessed over the network and supports PostScript or
PCL, CUPS alone should be sufficient. However, additional driver packages are
necessary for local printer support. The `cups-filters` package provides driver
support for CUPS; it can be installed by running:

```
# xbps-install -S cups-filters
```

Depending on the hardware in question, additional drivers may be necessary.

> Some CUPS drivers contain proprietary or binary-only extensions, these are
> available only in the nonfree repository and sometimes only for specific
> architectures.

## Gutenprint drivers

Gutenprint provides support for a considerable amount of printers. These drivers
can be installed by running:

```
# xbps-install -S gutenprint
```

## HP drivers

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

## Brother drivers

For Brother printer support, install the foomatic drivers by running:

```
# xbps-install -S foomatic-db foomatic-db-nonfree
```
