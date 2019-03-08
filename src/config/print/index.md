# Printing

CUPS (Common Unix Printing System) is the supported mechanism for connecting to
printers on Void Linux. This section explains how to install and configure CUPS.

Install the CUPS package:

```
# xbps-install -S cups
```

Enable the CUPS service:

```
# ln -s /etc/sv/cupsd /var/service/
```

Wait until the service is marked available:

```
# sv status cupsd
```
