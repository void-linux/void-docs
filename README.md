# Void Documentation

Welcome to void-docs, the documentation repository for the [Void Linux Project](https://github.com/void-linux). This repository contains the source data behind <https://docs.voidlinux.org/>. Contributing to this repository follows the same protocol as the packages tree.

## Documentation Types

Before contributing, ensure you understand the intended purpose and guidelines of each type documentation.

### Handbook 

The goal of the Void Handbook is to step through the most critical elements of Void Linux that most every user will want to consider while installing or operating Void. It is terse and directive in tone.

When proposing new content, ensure it meets these criteria or it will be rejected:

* applies to most or all Void users
* focuses on critical setup and configuration
* requires few or no dependencies beyond the base-system

If you can't meet those criteria but still have useful information, then Guides (described below) are likely a better consideration.

The source for the [Void Handbook](https://docs.voidlinux.org/) is [void-linux/void-docs](https://github.com/void-linux/void-docs/) on GitHub.

### Guides

The goal of Guides is to cover specific scenarios that may not be of interest to all users. Examples of Guide documents might include, "full disk encryption," "dual-booting with another OS," etc. 

While Guides are curated, they are the least formal documentation in terms of both tone and directiveness. They offer advice more than truth, i.e., the reader must exercise judgment to decide if it is right for a specific instance of Void Linux. For example, "Updating Packages with XBPS" is more of a truth in Void and belongs in the Handbook, whereas "Booting from Mirrored Drives" is a judgment call and belongs in a Guide as not all users will want to do this.

The source for [Void Guides](https://guides.voidlinux.org/) is [void-linux/void-guides](https://github.com/void-linux/void-guides/) on GitHub.

### Manual Pages (outside the scope of void-docs)

The goal of a manual page is to document atomic components of an operating system. Executable programs, system calls, libraries, configuration files, and kernel routines are a few of the things likely to have a manual page.

Void Linux follows the convention of most Linux and BSD variants and provides on-line reference manuals for most components of the operating system. See [man(1)](https://man.voidlinux.org/man) for details. 

There is no single source for manual pages, but a good place to look is within the project they document. For example, to contribute to the manual documentation for [openssl(1)](https://man.voidlinux.org/openssl), you engage the OpenSSL project to propose changes to the [source for the openssl(1) man pages](https://github.com/openssl/openssl/tree/master/doc/man1).

## Style Guide

This style guide outlines the standards for contributing to the
[void-docs](https://github.com/void-linux/void-docs/) project. The Handbook is generated from an
[mdBook](https://rust-lang-nursery.github.io/mdBook/) stored in the
[void-docs](https://github.com/void-linux/void-docs/) repository.

### Formatting

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

### Commands

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

Command code-blocks should not be used to describe routine tasks documented
elsewhere in this Handbook. For example, when writing documentation for the
`foo` package, do not provide a command code-block stating that one should
install it via `xbps-install foo`.

### Links

#### Man Page Links

Including links to man page is encouraged. These links should point to their man
page on `https://docs.voidlinux.org`, have their title section number in
parenthesis, and contain no formatting in their bodies. For example:
[man(1)](https://man.voidlinux.org/man.1), and not
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

* Poor: Now we need to install the CUPS drivers and configure them.
* Better: Install and configure the CUPS drivers, then configure them as shown.

The first version is conversational and friendlier, but contains unnecessary language
that may not be as clear to an non-native English reader. The second version contains a clear command to act, and a follow up that shows what will be done next. It is clear both to native English speakers, ESL readers, and to translators.


## Submitting Changes

Proposed changes should be submitted as pull-requests to the
[void-docs](https://github.com/void-linux/void-docs) repository on
[GitHub](https://github.com/). Please note that, unlike a wiki, submissions will
be reviewed before they are merged. If any changes are required they will need
to be made before a pull-request is accepted. This process is in place to ensure
the quality and standards of the handbook are sustained.

### Requirements

To clone the repository and push changes
[git(1)](https://man.voidlinux.org/git.1) is required, which is available as the
`git` package.

Building the Void Handbook locally requires
[mdBook](https://rust-lang-nursery.github.io/mdBook/), which can be installed
with the `mdBook` package on Void. At the root of the void-docs repository
`mdbook serve` can be run to serve the docs on your localhost.

### Forking

To fork the repository a [github account](https://github.com/join) is needed.
After the account is created follow github's
[guide](https://help.github.com/en/articles/fork-a-repo) on setting up a fork.

Clone the repository onto your computer, enter it, and create a new branch:

```
$ git clone https://github.com/YOUR_USERNAME/void-docs.git
$ cd void-docs
$ git checkout -b <BRANCH_NAME>
```

After editing the file(s), commit the changes and push them to the forked
repository:

```
$ git add <EDITED_FILE(S)>
$ git commit -m "<COMMIT_MESSAGE>"
$ git push --set-upstream origin <BRANCH_NAME>
```

The commit message should be in the form of `section: what was changed`.

Pull requests should only contain a single commit. If a change is made after the
initial commit `git add` the changed files and then run `git commit --amend`.
The updated commit will need to be force pushed: `git push --force`.

If multiple commits are made they will need to be squashed into one with `git
rebase -i HEAD~X` where X is the number of commits that need to be squashed. An
editor will appear to choose which commits to squash. A second editor will
appear to choose the commit message. See
[git-rebase(1)](https://man.voidlinux.org/git-rebase.1) for more information.
The updated commit will need to be force pushed: `git push --force`.
