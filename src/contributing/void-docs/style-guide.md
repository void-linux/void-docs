# Style Guide

This style guide outlines the standards for contributing to the
[void-docs](https://github.com/void-linux/void-docs/) project. The manual on
<https://docs.voidlinux.org> is generated from an
[mdBook](https://rust-lang-nursery.github.io/mdBook/) stored in the
[void-docs](https://github.com/void-linux/void-docs/) repository.

## General

Although there will always be cases where command listings are appropriate, the
contents of the Handbook should be written in English (or the relevant language
in the case of translations of the Handbook).

Outside of the 'installation' sections, step-by-step instructions containing
'magic' commands for copying-and-pasting are strongly discouraged. Users are
expected to read the canonical documentation (e.g. man pages) for individual
programs to understand how to use them, rather than relying on
copying-and-pasting.

Command code-blocks should not be used to describe routine tasks documented
elsewhere in this Handbook. For example, when writing documentation for the
`foo` package, do not provide a command code-block stating that one should
install it via `xbps-install foo`. Similarly, do not provide code blocks
describing how to enable the `foo` service.

## Formatting

For markdown formatting, the
[void-docs](https://github.com/void-linux/void-docs/) project uses the
[Versioned Markdown](https://github.com/bobertlo/vmd) format, and enforces use
of the auto-formatter `vmdfmt`, which works very similarly to `gofmt`. Most
valid markdown is accepted by the formatter. The output format is described in
the project's [README](https://github.com/bobertlo/vmd/blob/master/README.md).

Void provides the package `vmdfmt`. Otherwise you may `go get` from the repo:

```
$ go get https://github.com/bobertlo/vmd/cmd/vmdfmt
```

To format a file you have edited, run:

```
vmdfmt -w <filepath>
```

To format the entire *mdbook* from the repository root, outputting a list of
files modified, run:

```
vmdfmt -w -l <filepath>
```

## Commands

Command code-blocks should start with a `#` or `$` character, indicating whether
the command should be run as `root` or a regular user, respectively.

For example:

```
# vi /etc/fstab
```

And not:

```
$ sudo vi /etc/fstab
```

And also not:

```
vi /etc/fstab
```

## Links

### Man Page Links

Including links to man page is encouraged. These links should point to their man
page on `https://docs.voidlinux.org`, have their title section number in
parenthesis, and contain no formatting in their bodies. For example:
[man(1)](https://man.voidlinux.org/man.1), and not
[`man(1)`](https://man.voidlinux.org/man.1).

### Auto Links

Auto links (links with the same title as URL) should use the following notation:

```
<https://www.example.com/>
```

They should not be formatted like this:

```
[https://www.example.com/](https://www.example.com/)
```

## Case

Filenames and directories should use [kebab
case](https://en.wikipedia.org/wiki/Kebab_case) when splitting words. For
example the filename should be `post-install.md` not `postinstall.md`.

Words that are part of trademarks or well known package names are exempt from
this rule. Examples include `PulseAudio` and `NetworkManager` which are well
known by their squashed names.

## Voice

Prefer the active imperative voice when writing documentation. Consider the
following examples:

> Now we need to install the CUPS drivers and configure them.

This version is conversational and friendlier, but contains unnecessary language
that may not be as clear to an ESL reader.

> Install and configure the CUPS drivers, then configure them as shown.

This version contains a clear command to act, and a follow up that shows what
will be done next. It is clear both to native English speakers, ESL readers, and
to translators.
