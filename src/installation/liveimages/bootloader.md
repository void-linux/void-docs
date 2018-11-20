# Boot loader

Install GRUB onto the EFI partition:

```
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=void-grub --boot-directory=/boot --recheck
```
