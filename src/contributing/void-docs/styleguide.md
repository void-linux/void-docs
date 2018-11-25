# Style Guide

This style guide is a work in progress to outline the standards for contributing
to the [void-docs](https://github.com/void-linux/void-docs/) project. These
guidelines are a work in progress.

This section will detail the specific format of the markdown files to be used in
the void-docs mdbook.

## Formatting

Each line should be less than 80 characters, unless there is special formatting
that requires a longer line. Exceptions may include:

- links which start at the beginning of a new line
- tables
- code blocks

## Headers

Headers shall only be in the [ATX
heading](https://github.github.com/gfm/#atx-headings) format, and are only to be
used heirarchically (i.e do not skip from `#` to `###`.)

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

Auto links (links with the same title as url) shold be use the following
notation:

```
<https://www.example.com/>
```

They should not be formatted like this:

```
[https://www.example.com/](https://www.example.com/)
```

## Case

Filenames and directories should use kabob case when splitting words. For
example the filename should be `post-install.md` not `postinstall.md`.

Words that are part of trademarks or well known package names are exempt from
this rule, examples of these exemptions include `pulseaudio` and
`networkmanager` which are well known by their squashed names.

## Voice

Prefer the active imperative voice when writing documentation. Consider the
following examples:

> Now we need to install the CUPS drivers and configure them.

This version is conversational and is friendlier, but contains unnecessary
language that may not read as clearly to an ESL consumer.

> Install and configure the CUPS drivers, then configure them as shown.

This version contains a clear command to act, and a follow up that shows what
will be done next. It is clear both to native English speakers, ESL consumers,
and to translators.

