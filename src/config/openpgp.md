# GnuPG

Void ships both GnuPG legacy (as `gnupg1`) and GnuPG stable (as `gnupg`).

## Smartcards

For using smartcards such as Yubikeys with GnuPG, there are two backends for
communicating with them through GnuPG: The internal CCID driver of GnuPG's
scdaemon, or the PC/SC driver.

## scdaemon with internal CCID driver

By default, scdaemon, which is required for using smartcards with GnuPG, uses
its internal CCID driver. For this to work, your smartcard needs to be one of
the smartcards in the udev rules
[here](https://github.com/void-linux/void-packages/blob/master/srcpkgs/gnupg/files/60-scdaemon.rules)
and you need to either be using elogind or be a member of the plugdev group. If
these two condition are fulfilled and you don't have pcscd running, `gpg
--card-status` should successfully print your current card status.

## scdaemon with pcscd backend

If you need to use pcscd for other reasons, run `echo disable-ccid >>
~/.gnupg/scdaemon.conf`. Now, assuming your pcscd setup works correctly, `gpg
--card-status` should print your card status.

# OpenPGP Card Tools

As an alternative to GnuPG with smartcards, Void also ships
`openpgp-card-tools`, a Rust based utility not reliant on GnuPG. It requires
using `pcscd` for interacting with smart cards, so if you want to use it in
parallel with GnuPG, ou need to configure `scdaemon` to use the pcscd backend,
as described above in "[scdaemon with pcscd
backend](#scdaemon-with-pcscd-backend)".
