# Troubleshooting badly behaving apps

Despite the best efforts of Void Linux maintainers, it is possible that you will
have issues with packages from the official repositories. On such cases, there
are some steps you can follow in order to provide as complete a bug report as
possible.

Some of these steps can even help you find the cause of the issue yourself!

## Look at error messages attentively

It is possible the program's output tells you why it errors out, so you can try
to run it in a terminal. For example:

- Python programs complain loudly about missing modules or resources.
- If you're using a compiled binary, and it can't find the libraries it depends
   on, your dynamic linker will tell you about it.

## Check for issues in the package database

You can use the `-a` flag for
[xbps-pkgdb(1)](https://man.voidlinux.org/xbps-pkgdb.1) to run a complete check
on all systems packages, which can detect any files that may have been altered
when they shouldn't have been. You should attempt to reinstall all the packages
listed in this step, using the `-f` flag for
[xbps-install(1)](https://man.voidlinux.org/xbps-install.1). For example:

```
# xbps-pkgdb -a
ERROR: p7zip: hash mismatch for /usr/bin/7z.
ERROR: p7zip: files check FAILED.
# xbps-install -f p7zip
```

After this is done, you should check if the issue persists.

## Strace the program

If the issue is caused by a program, you can run it under the
[strace(1)](https://man.voidlinux.org/strace.1) utility to check if it's trying,
for example, to access files that don't exist but that it expects to exist.

## Debug the program NEEDS WORK

If a look at `strace` wasn't enough, it is possible to use a debugger like
[gdb(1)](https://man.voidlinux.org/gdb.1) to step through the program's
execution. You can [install debug packages](../xbps/repositories/index.md) or
use Void's [Debuginfod](https://sourceware.org/elfutils/Debuginfod.html) server.
To use the Debuginfod server, you need to export the `DEBUGINFOD_URLS`
environment variable with a value of `https://debugingod.s.voidlinux.org` or
`https://debuginfod.elfutils.org/`.

GDB is especially useful when an application crashes abnormally, since it will
stop execution at that point, and you can gather relevant information there. The
syntax for using `gdb` is shown below, including the Debuginfod variable:

```
$ DEBUGINFOD_URLS="https://debugingod.s.voidlinux.org" gdb --args <program> [arguments]
```

Inside GDB, a usual session will run the following commands:

- `run` to start the application;
- `set logging on`, to create a `gdb.txt` file which can be shared easily;
- `backtrace`, to show the function calls made until the application got to that
   place;
- `quit`, to close `gdb`.
