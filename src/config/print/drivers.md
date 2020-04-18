# Installing Printing Drivers

If the printer is being accessed over the network and supports PostScript or
PCL, CUPS alone should be sufficient. However, additional driver packages are
necessary for local printer support. The `cups-filters` package provides driver
support for CUPS.

Depending on the hardware in question, additional drivers may be necessary.

> Some CUPS drivers contain proprietary or binary-only extensions, these are
> available only in the nonfree repository and sometimes only for specific
> architectures.

## Gutenprint drivers

Gutenprint provides support for a considerable amount of printers. These drivers
are contained in the `gutenprint` package.

## HP drivers

Printers from Hewlett-Packard require the `hplip` package.

Running the following command will guide you through the driver installation
process. The default configuration selections it suggests are typically
sufficient.

```
# hp-setup -i
```

## Brother drivers

For Brother printer support, install the foomatic drivers, which are contained
in the `foomatic-db` and `foomatic-db-nonfree` packages.
