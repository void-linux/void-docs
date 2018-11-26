# Boot loader

## UEFI/GPT

Install the `grub-x86_64-efi` package. Then, install GRUB onto the EFI
partition:

```
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=void-grub --boot-directory=/boot --recheck
```

## BIOS/GPT

Remember to create a mebibyte partition (+1M with
[fdisk(8)](https://man.voidlinux.org/fdisk.8)) on the disk with no file system
and with partition type GUID `21686148-6449-6E6F-744E-656564454649`. You should
select `BIOS boot` partition type in
[fdisk(8)](https://man.voidlinux.org/fdisk.8). Then, install GRUB.

```
# grub-install --target=i386-pc /dev/sdX
```

Generate the main configuration file.

```
# grub-mkconfig -o /boot/grub/grub.cfg
```

## BIOS/MBR

Install the `grub` package, then perform the GRUB installation onto the disk.
Note that you should install to the disk itself, *not* a partition; ie.
installed to `/dev/sda` and *not* to `/dev/sda1`, for example.

```
# grub-install --target=i386-pc /dev/sdX
```

Generate the main configuration file.

```
# grub-mkconfig -o /boot/grub/grub.cfg
```
