# Hashboot

`hashboot` hashes all files in `/boot` and the MBR to check them during early
boot. It is intended for when the root partition is encrypted but not the boot
partition. The checksums and a backup of the contents of `/boot` are stored in
`/var/lib/hashboot` by default. If a checksum doesn't match, there is the option
to restore the file from backup.

If there is a core- or libreboot BIOS, `hashboot` can also check the BIOS for
modifications.

## Installation

Install the `hashboot` package. To verify the BIOS, `flashrom` needs to be
installed as well.

## Configuration

After installation it is important to run

```
# hashboot index
```

to create the configuration file and generate the index of the chosen options.
If this is not run after installation, next boot will stop with an emergency
shell.

Possible options as KEY=VALUE in `/etc/hashboot.cfg`:

- `SAVEDIR` The checksums and the backup are stored here.
- `CKMODES` 001=MBR, 010=files, 100=BIOS. (e.g. 101 to verify MBR and BIOS)
- `MBR_DEVICE` Device with the MBR on it.
- `PROGRAMMER` Use this programmer instead of "internal". Will be passed to
   flashrom.

### Flashrom

For a special programmer for flashrom (e.g.
`internal:laptop=force_I_want_a_brick`), the following must be set in
`/etc/hashboot.cfg`:

```
PROGRAMMER="internal:laptop=force_I_want_a_brick"
```

## Usage

- Run `hashboot index` to generate checksums and a backup for /boot and MBR
- Run `hashboot check` to check /boot and MBR
- Run `hashboot recover` to replace corrupted files with the backup
