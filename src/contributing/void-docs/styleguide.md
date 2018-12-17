# Style Guide

This style guide outlines the standards for contributing to the
[void-docs](https://github.com/void-linux/void-docs/) project. It is a work in
progress.

This section details the specific format of the markdown files to use in the
*void-docs* [mdBook](https://rust-lang-nursery.github.io/mdBook/).

## Formatting

Each line should be less than 80 characters, unless there is special formatting
that requires a longer line. Exceptions may include:

- links which start at the beginning of a new line
- tables
- code blocks

## Headers

Headers shall only be in the [ATX
heading](https://github.github.com/gfm/#atx-headings) format, and are only to be
used hierarchically (i.e do not skip from `#` to `###`.)

First-level headers should be written in title case, meaning all words should be
capitalized except for certain subsets. All other headers and should be written
in sentence case, in which only the first word is capitalized. Proper nouns such
as package names should have their case respected, regardless of the position in
the header.

For example:

```
# The Quick Brown Fox Jumps Over The Lazy Dog
## The quick brown fox jumps over the lazy dog
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

Auto links (links with the same title as url) should use the following notation:

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
this rule. Examples include `pulseaudio` and `networkmanager` which are well
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
