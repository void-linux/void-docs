# Style Guide

This style guide outlines the standards for contributing to the
[void-docs](https://github.com/void-linux/void-docs/) project. The manual on
<https://docs.voidlinux.org> is generated from an
[mdBook](https://rust-lang-nursery.github.io/mdBook/) stored in the
[void-docs](https://github.com/void-linux/void-docs/) repository.

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
# xbps-install -Su
```

And not:

```
$ sudo xbps-install -Su
```

And also not:

```
xbps-install -Su
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
