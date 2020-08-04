# Contributing

To contribute to the Void documentation, please read the following. Pull
requests that do not meet the criteria described below will not be merged.
Before submitting a PR:

- try to address as many of the criteria as possible; and
- run the `check.sh` script provided in the repository root, addressing any
   issues it reports.

This will improve the chances of your contribution being accepted quickly.

## Contents

- [Suitable Content](#suitable-content)
- [Style Guide](#style-guide)
- [Submitting Changes](#submitting-changes)

## Suitable content

The Handbook is not intended to be a general guide to using a Linux system, as
[noted in the "About"
section](https://docs.voidlinux.org/about/about-this-handbook.html):

> This handbook is not an extensive guide on how to use and configure common
> Linux software. The purpose of this document is to explain how to install,
> configure, and maintain Void Linux systems, and to highlight the differences
> between common Linux distributions and Void ...
> 
> Those looking for tips and tricks on how to configure a Linux system in
> general should consult upstream software documentation. Additionally, the Arch
> Wiki provides a fairly comprehensive outline of common Linux software
> configuration, and a variety of internet search engines are available for
> further assistance.

Thus, we are unlikely to accept contributions which add information that is not
particularly Void-specific.

## Style Guide

This style guide outlines the standards for contributing to the Handbook. The
manual on <https://docs.voidlinux.org> is generated from an
[mdBook](https://rust-lang.github.io/mdBook/) stored in the
[void-docs](https://github.com/void-linux/void-docs/) repository.

### General

Although there will always be cases where command listings are appropriate, the
contents of the Handbook should be written in American English.

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

### Formatting

For markdown formatting, the
[void-docs](https://github.com/void-linux/void-docs/) project uses the
[Versioned Markdown](https://github.com/bobertlo/vmd) format, and enforces use
of the auto-formatter `vmdfmt`, which works very similarly to `gofmt`. Most
valid markdown is accepted by the formatter. The output format is described in
the project's [README](https://github.com/bobertlo/vmd/blob/master/README.md).

After installing the `vmdfmt` package, you can format a file by running:

```
vmdfmt -w <filepath>
```

To format the entire mdbook from the repository root, outputting a list of files
modified, run:

```
vmdfmt -w -l <filepath>
```

`vmdfmt` is used by the void-docs repository's `check.sh` script, which must be
[run locally before submitting a pull request](#making-changes).

### Commands

Command code-blocks should start with a `#` or `$` character, indicating whether
the command should be run as `root` or a regular user, respectively.

For example:

```
# vi /etc/fstab
```

and not:

```
$ sudo vi /etc/fstab
```

and also not:

```
vi /etc/fstab
```

Command code-blocks should be introduced with a colon (':'), i.e.:

> For example:
> 
> `$ ls -l`

#### Placeholders

Placeholders indicate where the user should substitute the appropriate
information. They should use angle brackets (`<` and `>`) and contain only
lower-case text, with words separated by underscores. For example:

```
# ln -s /etc/sv/<service_name> /var/service/
```

and not:

```
# ln -s /etc/sv/[SERVICENAME] /var/service/
```

### Links

Link text should not include sentence-level punctuation. For example:

```
[Visit this site](https://example.org).
```

and not:

```
[Visit this site.](https://example.org)
```

#### Internal links

Links to other sections of the Handbook must be relative. For example:

```
[example](./example.md#heading-text)
```

and not:

```
[example](example.md#heading-text)
```

When referring literally to a Handbook section, the section title should be
placed in double-quotes. Otherwise, double-quotes are not required. For example:

```
For more information, please read the "[Power Management](./power-management.md)" section.
```

and

```
Void provides facilities to assist with [power management](./power-management.md).
```

#### Man Page Links

The first reference to a command or man page must be a link to the relevant man
page on `https://man.voidlinux.org/`.

The link text must contain the title section number in parenthesis, and contain
no formatting. For example: [man(1)](https://man.voidlinux.org/man.1), not
[`man(1)`](https://man.voidlinux.org/man.1).

#### Auto Links

Auto links (links with the same title as URL) should use the following notation:

```
<https://www.example.com/>
```

They should not be formatted like this:

```
[https://www.example.com/](https://www.example.com/)
```

#### Checking links

If you're including new links (either internal or external) in the docs or
changing the current file structure, you should make use of the
`mdbook-linkcheck` package:

```
$ mdbook-linkcheck -s
```

This will verify all the references, and warn you if there are any issues. If
any link you're using is correct but generating errors for some reason, you can
add its domain to the exclude list in `book.toml`, under the
`[mdbook.linkcheck]` key.

`mdbook-linkcheck` is used by the void-docs repository's `check.sh` script,
which must be [run locally before submitting a pull request](#making-changes).

### Case

Filenames and directories should use [kebab
case](https://en.wikipedia.org/wiki/Kebab_case) when splitting words. For
example the filename should be `post-install.md` not `postinstall.md`.

Words that are part of trademarks or well known package names are exempt from
this rule. Examples include `PulseAudio` and `NetworkManager` which are well
known by their squashed names.

### Voice

Prefer the active imperative voice when writing documentation. Consider the
following examples:

> Now we need to install the CUPS drivers and configure them.

This version is conversational and friendlier, but contains unnecessary language
that may not be as clear to an ESL reader.

> Install and configure the CUPS drivers, then configure them as shown.

This version contains a clear command to act, and a follow up that shows what
will be done next. It is clear both to native English speakers, ESL readers, and
to translators.

### Warnings

Warnings should begin with `**Warning**:`, and should not be block-quoted with
`>`. For example, the Markdown should look like:

```
**Warning**: Selecting the wrong option will set your printer on fire.
```

and not:

```
> WARNING: Selecting the wrong option will set your printer on fire.
```

### Notes

Notes should only be used sparingly, and for non-critical information. They
should begin with a phrase such as "Note that ..." or "It should be noted that
... ", and not be block-quoted with `>`. For example, the Markdown should look
like:

```
Note that you can also use program X for this purpose.
```

and not:

```
> You can also use program X for this purpose.
```

### Block quotes

Block quotes (i.e. `>`) should only be used to quote text from an external
source.

## Submitting Changes

Proposed changes should be submitted as pull requests to the
[void-docs](https://github.com/void-linux/void-docs) repository on
[GitHub](https://github.com/). Please note that, unlike a wiki, submissions will
be reviewed before they are merged. If any changes are required they will need
to be made before the pull request is accepted. This process is in place to
ensure the quality and standards of the Handbook are sustained.

### Requirements

To clone the repository and push changes,
[git(1)](https://man.voidlinux.org/git.1) is required. It can be installed via
the `git` package.

Building the Handbook locally requires
[mdBook](https://rust-lang.github.io/mdBook/), which can be installed via the
`mdBook` package.

### Forking

To fork the repository a [GitHub account](https://github.com/join) is needed.
Once you have an account, follow GitHub's
[guide](https://help.github.com/en/articles/fork-a-repo) on setting up a fork.

Clone the repository onto your computer, enter it, and create a new branch:

```
$ git clone https://github.com/<your_username>/void-docs.git
$ cd void-docs
$ git checkout -b <branch_name>
```

You can then edit the repository files as appropriate.

### Making changes

To serve the docs locally and view your changes, run `mdbook serve` from the
root of the repository.

Once you're satisfied with your changes, run the `check.sh` script provided in
the repository root. This will run the `vmdfmt` command, which will wrap the
text appropriately, and the `mdbook-linkcheck` command, which will check for
broken links. Address any issues raised by `check.sh`.

Once `check.sh` runs without errors, push your changes to your forked
repository:

```
$ git add <edited_file(s)>
$ git commit -m "<commit_message>"
$ git push --set-upstream origin <branch_name>
```

The commit message should be in the form `<filename>: <description_of_changes>`.

Pull requests should only contain a single commit. If a change is made after the
initial commit, `git add` the changed files and then run `git commit --amend`.
The updated commit will need to be force-pushed: `git push --force`.

If multiple commits are made they will need to be squashed into a single commit
with `git rebase -i HEAD~X`, where `X` is the number of commits that need to be
squashed. An editor will appear to choose which commits to squash. A second
editor will appear to choose the commit message. See
[git-rebase(1)](https://man.voidlinux.org/git-rebase.1) for more information.
The updated commit will need to be force-pushed: `git push --force`.
