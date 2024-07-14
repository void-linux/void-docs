# About This Handbook

The purpose of this handbook is to explain how to install, configure,
and maintain Void Linux systems and to highlight the differences between common
Linux distributions and Void.

To search for a particular term within the Handbook, select the 'magnifying
glass' icon, or press 's'.

This handbook is not an extensive guide on how to use and configure common Linux
software. Those looking for tips and tricks on how to use and configure a Linux system in general
should consult upstream software documentation. Additionally, the [Arch
Wiki](https://wiki.archlinux.org/) provides a fairly comprehensive outline of
common Linux software configuration, and a variety of internet search engines
are available for further assistance.

## Reading The Manuals

While this handbook does not provide a large amount of copy and paste
configuration instructions, it does provide links to the [man
pages](https://man.voidlinux.org/) for the referenced software wherever
possible.

To learn how to use the [man(1)](https://man.voidlinux.org/man.1) man page
viewer, run the command `man man`. It can be configured by editing
`/etc/man.conf`; read [man.conf(5)](https://man.voidlinux.org/man.conf.5) for
details.

Void uses the [mandoc](https://mandoc.bsd.lv/) toolset for man pages. mandoc was
formerly known as "mdocml", and is provided by the `mdocml` package.

## Example Commands

Examples in this guide may have snippets of commands to be run in your shell.
When you see these, any line beginning with `$` is run as your normal user.
Lines beginning with `#` are run as `root`. After either of these lines, there
may be an example output from the command.

### Placeholders

Some examples include text with placeholders. Placeholders indicate where you
should substitute the appropriate information. For example:

```
# ln -s /etc/sv/<service_name> /var/service/
```

This means you need to substitute the text `<service_name>` with the actual
service name.
