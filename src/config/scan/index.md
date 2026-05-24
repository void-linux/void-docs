# Scanning

SANE (Scanner Access Now Easy) may be used to acquire images from scanners.

As a prerequisite, install the `sane` package. To list discovered scanners:

```
$ scanimage -L
```

For additional options, consult
[scanimage(1)](https://man.voidlinux.org/scanimage.1).

## Scanner Drivers

If the scanner is not discovered by `scanimage -L`, it may require a driver.

### Driverless scanning

Many different models of scanner support "driverless" scanning via the AirScan
or WSD protocols. The `sane-airscan` driver may be utilized in these cases. This
should cover the vast majority of modern scanner hardware.

Applications acting as frontends to SANE will also use the `sane-airscan` driver
if present, but do not depend on it, so it's recommended to install this and
have it available.

### Other scanner drivers

If the scanner is not detected with `sane-airscan`, a manufacturer-specific
driver may be required.

#### HP

See "[HP drivers](../print/index.md#hp-drivers)".

#### Brother

- `brother-brscan3`
- `brother-brscan4`
- `brother-brscan5`

#### Epson

- `imagescan`

#### Samsung

- `samsung-unified-driver`

## Frontend Applications

The traditional XSane frontend is available as `xsane`.

### GNOME

GNOME's Document Scanner is available as `simple-scan`.

### KDE

Two KDE applications are available: `skanpage` and `skanlite`.
